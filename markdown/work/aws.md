---
title: Working at AWS 
date: 2020-09-23
---

# What I Learned Working at Amazon

Working at Amazon, especially in infrastructure and operations-heavy environments, shaped how I think about software engineering. These are some of the most important lessons I took with me:

- Don’t restart systems just to “fix” issues. Understand the root cause, debug the problem, and fix it properly.
- People should not be paged in the middle of the night if there is nothing meaningful they can do.
- If an application requires constant manual supervision, invest in metrics, observability, and automation.
- At large scale, even rare failures become frequent. Either fix the issue or build systems that recover automatically.
- If a human has to run a manual command, eventually someone will make a mistake. Build safer systems.
- Automation should live in code, not only in documentation.
- Code is more reliable than undocumented processes.
- Documentation is better than tribal knowledge.
- If something can safely wait a few hours, it probably does not need an immediate interruption.
- Understanding Linux and Unix fundamentals is essential.
- Learn shell scripting and automate repetitive tasks.
- If a tool helps you, share it with your team.
- Encourage others to share their automation.
- Build reusable tools and frameworks whenever possible.
- Automatic recovery is usually better than requiring human intervention for routine failures.

# Working at Amazon AWS (2015 - 2019)

## The First Year

My first year was both challenging and rewarding.

I was starting a new job, living in a new country, and working daily in a second language. Fortunately, many members of the team were also relatively new, which created a strong sense of collaboration from the beginning.

I learned a great deal from my teammates, both technically and professionally.

During my first months, I spent a significant amount of time in operational rotations, dealing with infrastructure incidents, hardware issues, and production support. That experience gave me a strong foundation in distributed systems and operational excellence.

Each engineer participated in operational rotations that included:

- One week as primary on-call every month
- One additional week focused on operational improvements and maintenance

The workload was intense, but it created excellent opportunities to learn how large-scale systems behave in production.

The team culture was healthy and focused on continuous improvement. Engineers were encouraged to take ownership, learn from mistakes, and support one another.

## 2017 - 2019

Over time, our organization evolved significantly.

As the product and team matured, engineering priorities increasingly focused on reliability, operational excellence, and long-term maintainability.

This created opportunities to improve existing systems, reduce operational overhead, and invest heavily in automation.

Our local leadership created an environment of trust, ownership, and technical autonomy, which allowed engineers to propose and implement meaningful improvements.

The team also grew internationally, including the opening of a new engineering office in Berlin. I had the opportunity to help onboard and mentor engineers there.

As our tooling and automation improved, operational load decreased significantly, allowing the team to focus more on engineering initiatives and platform improvements.

# Projects I Worked On

## Redshift

I worked across multiple areas of the platform, primarily using Java, building internal tools, improving operational systems, and contributing to platform reliability.

### OpsConsole

Lead developer for an internal Rails application that allowed engineers to:

- Perform operational actions on Redshift clusters
- Inspect cluster state
- Troubleshoot production issues safely

The goal was to reduce operational complexity and standardize critical workflows.

### Auto-Recovery

I helped design and implement automated recovery systems for Redshift clusters.

These systems consumed events emitted by clusters and supporting infrastructure such as EC2, then executed recovery workflows automatically when known failure patterns were detected.

The goal was to reduce operational intervention and improve system resilience.

### Canary

Lead developer for a workflow-aware canary system.

I modernized an existing Ruby application that initially performed basic API checks and expanded it into a system capable of validating real production workflows.

This included:

- Creating clusters
- Running operational actions
- Validating state transitions
- Cleaning up resources

This approach allowed us to detect issues that traditional health checks could not identify.
