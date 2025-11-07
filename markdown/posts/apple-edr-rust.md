---
title: EDR, Rust and Apple
date: 2025-11-07
---

[In the last post](https://www.elias.sh/posts/kernel-mode-and-cybersecurity), I described a little bit about EDR and how we can implement it for Windows. If you look closer at what I described, you are going to see a clear pattern:

1. We have a Driver hook up to certain events from the kernel that sends this info to a user-mode application
2. The user-mode application reads the information about the event and makes a decision ("Inline Threat Prevention")

As we discussed previously, building a driver is hard, and any mistake can make your whole system restart. Imagine every single EDR provider building their own drivers and making repeated mistakes (because everything is proprietary). This is not good for all the parts.

Apple has a better way of implementing this, which is called "[endpoint security](https://developer.apple.com/documentation/endpointsecurity)". As they describe it: "Endpoint Security is a C API for monitoring system events for potentially malicious activity. Your client registers with Endpoint Security to authorize pending events, or receive notifications of events that already occurred. These events include process executions, mounting file systems, forking processes, and raising signals."

In a way, it's like Apple already wrote the driver for us, and we just need to consume the messages sent from them on our User-mode application. Yay, perfect, one less source of mistakes, right?

There is only one problem, it's a C API. If you know me, you know I'm interested in Rust. So how can we use this to build a Rust UserMode EDR application? Well, [HarfangLab](https://github.com/HarfangLab) did a lot of the hard work for us and created a safe abstraction for us: endpoint_sec.

We basically need two things, first [we need to create a client able to handle the different messages types](https://docs.rs/endpoint-sec/0.4.3/endpoint_sec/struct.Client.html#method.new):

```rust

endpoint_sec::Client::new(|client: &mut endpoint_sec::Client, message: endpoint_sec::Message| {
    // try not to block here and reply very fast to AUTH messages
    // if you are too slow the system may kill your EDR application, but worst than that:
    // Messages are handled strictly serially and in the order they are delivered. 
    // Returning control from the handler causes the next available message to be dequeued.
   match message.event_type() {
      endpoint_sec_sys::es_event_type_t::ES_EVENT_TYPE_AUTH_EXEC => todo!(),
      _ => todo!(),
   };

}).unwrap(); 
```

Second we need to subscribe to the different events with [subscribe](https://docs.rs/endpoint-sec/0.4.3/endpoint_sec/struct.Client.html#method.subscribe).

There are two types of messages: Notify and Auth. Notify messages are notification only. The event already happened and the system is just letting us know. The Auth messages on the other hand are messages that we need to authorize (using a [special function from our client](https://docs.rs/endpoint-sec/0.4.3/endpoint_sec/struct.Client.html#method.respond_auth_result)).

So yeah, while an EDR product 100% written in Rust is a bit complicated on Windows, it seems like a reality on MacOS! So reality, that maybe [Harfanglab](https://harfanglab.io/) is already doing it? Not sure, but we have to thank them for the opensource crate!
