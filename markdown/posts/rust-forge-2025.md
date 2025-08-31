---
title: Rust Forge 2025
date: 2025-09-02
---

I normally don't write about the conferences I go here, but [Rust Forge](https://rustforgeconf.com/) is different for two reasons: (1) I had the pleasure to give my first
talk in English there, and (2) the conference really felt like a place to share ideas and not necesarry consume content.

Let me focus for now on the conference. The first two days were "co-creation days" with a bunch of (technical) workshops and some tours
around Wellington (NZ). It was a great opportunity to bound with different people over the activities. We visited [Zealandia](https://www.visitzealandia.com/Visit) at night, and
some people were able to see Kiwis (not me :C).

During a dinner, I was lucky enough to sit with amazing people and learn so much from the conversation. I learnt some details about [Rust Incremental Compilation](https://rustc-dev-guide.rust-lang.org/queries/incremental-compilation-in-detail.html).
How a "push-based" approach could speed up things ([more similar to Zig approach](https://ziggit.dev/t/how-zig-incremental-compilation-is-implemented-internally/3543/2))
and that sometimes the rustc may do some work and throw the result away later, because it was not needed.
I also learnt about [wild linker](https://github.com/davidlattimore/wild) (btw, amazing talk during the conf about it by David!) and [zngur](https://github.com/HKalbasi/zngur) 
(tool for C++/Rust interop).

![](https://www.elias.sh/forge/all_of_us.webp)

The talks were about Rust in embedded, passing by linkers, [cargo-semver-checks](https://github.com/obi1kenobi/cargo-semver-checks) to community and governance.

A lot of the talks were made by the local community which made everything even more fun!

I also gave a talk there about [Rust testing](https://github.com/era/rust-forge-2025). It was my first time speaking in a conference in English, the last
time I talked in a conf was during FliSol in 2013, back in Brazil!

My talk was mainly about how the [Hyrum's Law](https://www.hyrumslaw.com/) makes any re-write much harder than we can think of, because we
have to keep any observable behaviour, which may be hidden away in some abstraction / lib we used and won't be able to use it anymore. Of course, we can 
use tests to help us: "replaying production traffic", table-driven tests and shadow envs. That is what I tried to show with a real world example.

I almost forgot about the food, [Tim](https://timclicks.dev/) prepared for us a lot of snacks and food during the breaks. All of it was vegetarian or vegan,
which really made my life (as a vegan) much nicer. Normally the vegan food is just an after-thought, but during Rust Forge it was one of the main options!

I hope there is a Rust Forge next year, and for that to happen more companies need to step up and help financially...
