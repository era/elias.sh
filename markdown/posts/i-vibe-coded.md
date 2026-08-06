---
title: I vibe coded something, and I hate it
date: 2026-08-07
---

After all the hype around LLMs and coding agents, I decided to learn a little bit more about how they work. As a software engineer I was curious about two aspects: (1) how their internals work, and (2) how far we could push them. So I thought: what better way to learn it than by trying to build it? And what better way to push it to its limits than trying to "vibe code" it myself? I read about [Stripes' minions](https://stripe.dev/blog/minions-stripes-one-shot-end-to-end-coding-agents) some time ago and decided to mimic its behaviour for this experiment.

For the experiment I used: [GLM-5.2](https://z.ai/) to review all the code using [open code-review](https://github.com/alibaba/open-code-review) from Alibaba. For coding, I mixed a bit of Claude and [DeepSeek V4 Flash](https://deepseek.com/en/index.html). For the harness, I used Claude Code and Pi. I wanted to use Chinese providers as much as possible, as I don't trust the USA ones.

The idea was to create a "one-shot" coding agent, I didn't want the agent to coordinate all the actions. I wanted to use a workflow. Whatever could be deterministic would use a tool and would be a separate node. The probabilistic nodes (the agent) could use different tools to perform the task, but running tests, creating PRs, checking the format of the code, all of that would use deterministic tooling after the probabilistic node. That way I was sure that I would run all the checks I desired.

For the first PRs, I decided I would take a look at all the code, and if I found something I was not aware of, I would find papers that taught me that concept. It worked great, I ended up reading [a couple](https://arxiv.org/abs/2210.03629) of [good papers](https://arxiv.org/abs/2302.04761) and I felt like I finally grasped how LLMs can use tools and how the whole "coding agents" can work.

After a few days of letting one agent code and another review, I had something working. I called it [boitata](https://github.com/cats-of-the-world/boitata). The name comes from Brazilian native folklore, a fire snake that protects the forest. Of course, at that point, my workflow was generating so much code that I stopped reading the code. Every weekend I would spend sometime testing the software and checking it seemed to work as I expected.

<img src="https://github.com/cats-of-the-world/boitata/raw/master/docs/src/screenshots/blueprint-graph.png" />

Boitata became its own thing, when I added TypeScript and a UI to it, I knew I had lost the game. My last contact with web development was years ago, before TypeScript was a mainstream thing. I'm comfortable with JavaScript from the early days of the internet until the first versions of node.js. I broke my own promise of understanding all the code and I was not motivated enough to learn TypeScript.

I asked it to create its own documentation. I needed to try to make sense of all the code it was generating. I still felt like this experiment could lead to something nice, but the more I looked at the result, the more I believed it would take a great amount of human labour to make it something I would like to use.


The code seems good enough. It feels production grade. I would never spend that amount of time on a side-pet project refining comments around the code or even adding so many tests. Normally, on pet-projects I want to learn a specific subject and I focus only on it, everything else that I need to build in order to learn what I really want is just a draft.

But that is the thing, it looks like production-grade, can I affirm it's production grade?
