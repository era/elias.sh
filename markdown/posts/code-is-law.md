---
title: Code is law (not really) 
date: 2026-08-22
---

Startups and big corps produce software in a very different way. One side will use Agile methodology, with people in its center; the other will use waterfall, process are the center. Agile most of the times is almost like vibe coding something. You have a loosely defined feature (called user story), you plan how to deliver this during one sprint and you are done. Waterfall is extremely boring, you spend months defining all the aspects of your software; then you develop, then you test; then you ship something that is useless because the world has moved on.

A Startup just don't have the time for doing it, so they just go by feelings and adapt super fast. The only source of truth is the code, you want to know how a feature that was developed last year is working? Go straight to the code, it's your only hope. And I have to say that it works pretty well. When humans write code they have the intention in mind, they tend to produce code that is closer to the conversation they had and their understanding of the requirements. Good code comments will even highlight this: "oh, because we were asked X, I'm implementing this like bla and bla". If there is a bug, you normally can tell a bit easier if the bug is due to a bad requirement or a bad implementation. Don't get me wrong, it's not something that someone starting in the industry can do, but over the years you acquire this super power.

Meanwhile, in a big corp you have UML. Oh, god, I hate UML. I know how to read code, I can quickly understand how something was develop and move around the code. UML software is slow, is visual, I cannot easily `grep` I can't do almost nothing with that. I hate it.

It's 2026. My work role changes and the world is also another. People write requirements with LLMs, code those requirements with LLMs and hopefully validate it by themselves.

Software is hard because the small details. When I was at AWS my favourite type of interview question was a to give a very abstract problem and check if the person would ask clarifying questions and would come up with possible edge cases for us to discuss. Implementing what I have asked initially would be easy, but would explode in production or you would need to play by the ear every time you either saw a bug or found an edge case. Not very far away from someone vibecoding. 

Let's talk again about Startups. They want to go fast. With LLMs and enough money you can probably build in few days what previously would take years. So the act of producing a software is not the hardest part. Also: because you are producing so many things so fast, you don't have time to process the feature in background. I mean, which software engineer never had a Eureka moment at the shower after working for days on the same feature? Now, features are like reels or TikTok, you spend 30 seconds on it, and you move to the next. No time to reflect on it.

No time to reflect on it.

No time to reflect on it.

Isn't that important? Wait a minute, isn't waterfall a way to stop and reflect about the problem for months? And Agile a way to maybe reflect less, but deliver faster? Is it safe to skip the reflection part?


During the pandemic I got addicted to the theme "tools for thoughts". I was mostly interesting in building software that would help us to better manage our thoughts or visualize information, a [memex](https://www.youtube.com/watch?v=DFWxvQn4cf8). This type of software seems even more important now that we are spending less time on the small details of our office jobs and looking more and more at the bigger picture.

Fast forwarding a few years on a business trip to China, I learnt about Formal Methods from [Ananth](https://www.linkedin.com/in/ananthshrinivas/). I got a new addiction: how to formally prove software was working. In a way, the two themes overlap: isn't TLA+ just a tool for formalizing thought?

[Martin Kleppmann](https://martin.kleppmann.com/2025/12/08/ai-formal-verification.html) has a prediction: AI will make formal verification to become mainstream. I think that too, but I also believe we are far away from it as today. Although, I think we can slowly pave the way.

What if merge the speed of Agile with a bit more formality? Instead of talking about user stories, for more technical problems (e.g. how an EDR agent should handle file access) we produce specs?

Ok, so we are going to write specs, how are we going to prove that we are following those specs? Oh, well, that is a harder problem, but what if we take a smaller step here: what if we don't prove we are correctly following the spec, but at very least we point at the code where we had the INTENTION of following a certain item of the spec?

There is a tool called [tracey](https://tracey.bearcove.eu/), which I like to think as a "tool for thought". If you write your specs following its syntax, where you annotate requirements with `r[rule.id]`:

```
## Connection Lifecycle

r[conn]

r[conn.open]
The client MUST send a handshake frame
before any other communication.

r[conn.close]
Either side MAY initiate a graceful close.
``` 
```
```

And later on you also annotate on your code where you had the INTENTION of implementing that rule:

```rust
// [impl conn.open]
fn open_connection(&mut self) -> Result<()> {
    self.send_handshake()?;
    self.state = State::Open;
    Ok(())
}

#[test]
fn test_handshake() {
    // [verify conn.open]
    let mut conn = Connection::new();
    assert!(conn.open_connection().is_ok());
}
``` 
```
```

Tracey allows you to use a web dashboard or a CLI to ask questions like: "we defined this behaviour 2 weeks ago as `r[rule.id]`, are we following it?" or even "the observed behaviour during test does not seem correct, let me find where in the code we were trying to implement this part of the spec and confirm if we implemented correctly".

So the tool give us traceability. The spec gives a more formal definition of how something should work, it also give us a media where we can discuss behaviour, edge cases and important details without implementation details of the programming language we use. It's a place where other folks that are not software engineers or don't have time to read big pull requests to give their inputs.


In other words, it gives us more formality without forcing us to make waterfall mainstream again.
