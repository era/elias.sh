---
title: I vibe coded something, and I hate it
date: 2026-08-07
---

<img src="https://elias.sh/vibe/sin.jpg" />

After all the hype around LLMs and coding agents, I decided to learn a little bit more about them. As a software engineer I was curious about two aspects: (1) how their internals work, and (2) how far we could push them. So I thought: what better way to learn it than by trying to build it? And what better way to test its limits than trying to "vibe code" it myself? I read about [Stripe's minions](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents) some time ago and decided to mimic its behaviour for this experiment.

For the experiment, I used [GLM-5.2](https://z.ai/) to review all the code using [open code-review](https://github.com/alibaba/open-code-review) from Alibaba. For coding, I mixed a bit of Claude and [DeepSeek V4 Flash](https://deepseek.com/en/index.html). For the harness, I used Claude Code and Pi. I wanted to use Chinese providers as much as possible, as I don't trust the USA ones.

The idea was to create a "one-shot" coding agent; I didn't want the agent to coordinate all the actions. I wanted a workflow instead, a graph of tasks to be done. Whatever could be deterministic would use a tool and would be a separate node. The probabilistic nodes (the agent) had access to all the tooling needed to perform the task, but running tests, creating PRs, and checking the format of the code would all use deterministic tooling after the probabilistic node. That way I was sure that I would run all the checks I desired.

For the first PRs, I decided I would take a look at all the code, and if I found something I was not aware of, I would find papers that taught me that concept. It worked great; I ended up reading [a couple](https://arxiv.org/abs/2210.03629) of [good papers](https://arxiv.org/abs/2302.04761). Maybe LLMs can be used to learn and build something from scratch?

<img src="https://elias.sh/vibe/fera.webp" />

After a few days of letting one agent code and another review, I had something working. I called it [boitata](https://github.com/cats-of-the-world/boitata). The name comes from Brazilian native folklore, a fire snake that protects the forest. Of course, at that point, my workflow was generating so much code that I stopped it. I decided to take a more "user approach". Every weekend I would spend some time testing the software and checking that it seemed to work as I expected.

<img src="https://github.com/cats-of-the-world/boitata/raw/master/docs/src/screenshots/blueprint-graph.png" />

Boitata became its own thing. When I added TypeScript and a UI to it, I knew I had lost the game. My last contact with web development was years ago, before TypeScript was a mainstream thing. I'm comfortable with JavaScript from the early days of the internet until the first versions of node.js. I broke my own promise of understanding all the code, and I was not motivated enough to learn TypeScript.

I asked it to create its own documentation. I needed to try to make sense of all the code it was generating. I still felt like this experiment could lead to something nice, but the more I looked at the result, the more I believed it would take a large amount of human labour to make it something I would like to use.


The code seems good enough. It feels polished, even careful. I would never spend that amount of time on a side project refining comments around the code or even adding so many tests. Normally, on pet projects I want to learn a specific subject and I focus only on it; everything else that I need to build in order to get to what I really want is just a draft.

But that is the thing: it looks production-grade, but can I affirm it's production-grade? Maybe legacy software, if anything. Now I have a lot of code in a repo, and every single time I want to fix something manually or debug a problem, I need to navigate something I haven't seen before, but "should be working". Isn't handling legacy, almost black-box software one of the most hated tasks for a software engineer? Why did I have to turn my own side project into something I hate?
