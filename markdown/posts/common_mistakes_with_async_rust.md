---
title: Common mistakes with Async Rust 
date: 2025-01-26
---

Rust prevents a lot of problems, but in order to work with Async Rust you must keep in mind how green threads work.

## 1. Do not block inside a Rust Async Runtime

If you perform I/O blocking operations inside a runtime like Tokio, you will be blocking one of the working threads, if you do that on all your working threads you could make your whole program stuck. I wrote a small example of [this.](https://github.com/era/do-not-block-inside-rust-async)

Instead you should use async I/O or use something like [spawn_blocking](https://docs.rs/tokio/latest/tokio/task/fn.spawn_blocking.html) which will run the closure on a thread which blocking won't cause issues.

## 2. Drop implementations which may block

This is really a variation of the first item. Some structs may try to clean up resources (like deleting a file or closing a socket) when they are dropped. Some of those operations are blocking, such as dropping [std::net::TcpListener](https://doc.rust-lang.org/std/net/struct.TcpListener.html): "The socket will be closed when the value is dropped." 

## 3. Creating futures too big for the stack

Async / Await generates a state machine which is by default stored on the Stack ([ref1](https://eventhelix.com/rust/rust-to-assembly-async-await/), [ref2](https://www.youtube.com/watch?v=ThjvMReOXYM), [ref3](https://www.youtube.com/watch?v=bnmln9HtqEI)). In certain cases, you may end up with a state machine so big that it cannot be stored on the Stack. For those cases you may need to Box the future so it's allocated in the heap and not on the stack.

There is a clippy lint for that, [more details here](https://users.rust-lang.org/t/stack-overflow-in-async-main-function-due-to-excessive-stack-allocation-not-from-recursion/109571).

## 4. Mutexes 

Mutexes are a hard topic. First, you can use the standard library Mutex in async context. The Tokio documentation is pretty clear [about it](https://docs.rs/tokio/latest/tokio/sync/struct.Mutex.html#which-kind-of-mutex-should-you-use). Basically, [you are fine if lock taks a short time to unblock](https://github.com/tokio-rs/tokio/discussions/6785#discussioncomment-10365146). The [Tokio book also states the same](https://tokio.rs/tokio/tutorial/shared-state).

But when you are using Tokio Mutex, you must be careful because "in contrast to std::sync::Mutex, this implementation does not poison the mutex when a thread holding the MutexGuard panics. In such a case, the mutex will be unlocked. If the panic is caught, this might leave the data protected by the mutex in an inconsistent state.".

That is true not only for threads that panic'ed but also for futures that were in the middle of an operation and were dropped, [for example this](https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=b68c55f773aaaace2d805c3c656b21a9). You should keep the invariants true at every await point.


----

Post based on [a thread on bsky.app](https://bsky.app/profile/alilleybrinker.com/post/3lggs4l5y3k27) and a [PoC](https://github.com/era/do-not-block-inside-rust-async/tree/master) I did at work to exemplify the problem with blocking inside an async runtime in Rust.


Code for the mutex problem from: https://bsky.app/profile/mattkeeter.com/post/3lgguzn3vec2u