---
title: Quic server in Rust
date: 2025-08-27
---

Last year, I was working in a server that would "bridge" notebooks with a custom backend service. One of the decisions was to use QUIC instead of your
old TCP or UDP friends. 

I like to describe [QUIC](https://quicwg.org/) as "TCP implemented on User Space on top of UDP". It establishes a bunch of multiplexed connections on top of UDP and it's 
suppose to be an improvement over TCP.

This was my first time working with QUIC, so I wanted a playground where I could learn all the details of the protocol without the deadlines. And that is why I put
together [debra](https://github.com/era/debra). `debra` is basically a chat application, where computers can connect to a single backend that handles the routing of 
the messages. 
Since QUIC allows us to have bi-directional streams, everything works out of the box. Computer A sends a message to the server to be routed to Computer B.
 Server finds which stream belongs to the Computer B and sends the message. Since this is a toy, we drop the message if Computer B is not online.

I wanted to play with the protocol, but not implement it from scratch, I decided to use [quinn](https://docs.rs/quinn/latest/quinn/) to abstract it away for
 me (it was the same crate used at work as well).

The code is simple, every time a new connection comes, we get the bidirectional stream. For the receiver, we put it in a tokio task to handle all the new messages.
For the sender, we put it in our map, so we later can find it when we need to send a message. We also assume the first message the client will send is its id.

```rust

pub async fn new_connection(&self, conn: quinn::Incoming) -> Result<()> {
    let connection = conn.await?;

    let stream = connection.accept_bi().await;
    let (sender, mut receiver) = match stream {
        Err(quinn::ConnectionError::ApplicationClosed { .. }) => {
            info!("connection closed");
            return Ok(());
        }
        Err(e) => {
            return Err(e.into());
        }
        Ok(s) => s,
    };


    let bytes = read_bytes(&mut receiver).await?;

    let message =
        root_as_message(&bytes).map_err(|e| anyhow!("failed parsing message: {:?}", e))?;

    if message.message_type() != MessageType::ClientRegistration {
        error!("not expecting message type: {:?}", message.message_type());
        return Err(anyhow!("First Message should be client registration"));
    }

    let id = message.client_id();

    // we just assume something else is setting the ids for the clients
    // and we can trust the clients
    self.clients
        .insert(message.client_id(), Arc::new(Mutex::new(sender)));

    let sender = self.tx.clone();

    tokio::spawn(async move {
        // this will keep reading messages from the stream
        // until an error happens.
        loop {
            match read_bytes(&mut receiver).await {
                Ok(bytes) => {
                    info!("new message from client: {id}");
                    let letter_to = root_as_message(&bytes)
                        .map_err(|e| error!("failed parsing message: {:?}", e))
                        .ok()
                        .map(|m| m.for_client());

                    if let Some(letter_to) = letter_to {
                        // ignore the error for now
                        let _ = sender.send(Letter::Forward(letter_to, bytes)).await;
                    } else {
                        info!("message for nobody");
                    }
                }
                Err(e) => {
                    error!("error while reading message: {:?}", e);
                    // ignore the error for now
                    let _ = sender.send(Letter::Remove(id)).await;
                    break;
                }
            }
        }
    });

    Ok(())
}
```

In order to send messages we just need to find the right stream:

```rust

async fn handle_letters(&self, letter: Letter) -> Option<()> {
    match letter {
        Letter::Remove(id) => {
            self.clients.remove(&id);
        }
        Letter::Forward(letter_to, bytes) => {
            // clones to avoid deadlock due to clashmap
            let stream = self.clients.get(&letter_to)?.clone();
            // spawns a new task to avoid blocking our main loop
            tokio::spawn(async move {
                let mut stream = stream.lock().await;
                // first bytes are always the size
                let _ = stream
                    .write_all(&bytes.len().to_be_bytes())
                    .await
                    .map_err(|e| error!("error while sending message {:?}", e));

                let _ = stream
                    .write_all(&bytes)
                    .await
                    .map_err(|e| error!("error while sending message {:?}", e));

                info!("finished forwarding message");
            });
        }
    }

    Some(())
}

```

I also built a [client](https://github.com/era/debra/blob/master/src/bin/client.rs)
for it. The client code is a bit more hacky, since I needed something quick and dirty 
to test. And as you can imagine, it follows more or less the same steps as the server.

