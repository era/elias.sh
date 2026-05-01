---
title: Understanding Cybersecurity: MITRE ATT&CK + CIA Triad
date: 2026-05-01
---

Working on Cybersecurity for over a year has made me realise how much this industry relies on naming that is not common among the rest of the software engineering industry. Even when I was interviewing people for my team, the term "endpoint" would often be misunderstood, as it has a different meaning outside the cybersecurity world. Thus, the idea for this series of posts is to try to put some of my personal notes out there. And since it's a huge topic, I will split it into different parts. For the first post I will focus more on data. I won´t repeat what I have already described regarding [EDR](https://www.elias.sh/posts/kernel-mode-and-cybersecurity), [ETW](https://www.elias.sh/posts/etw-rust), eBPF and [Apple endpoint-security](https://www.elias.sh/posts/apple-edr-rust).

## MITRE ATT&CK framework

Maybe one of the most important terms is the famous MITRE ATT&CK framework. Microsoft has a great explanation for it \[1\]:

> The MITRE ATT&CK framework is a globally accessible knowledge base that documents real-world adversary tactics, techniques, and procedures (TTPs) based on actual [cybersecurity](https://www.microsoft.com/en-us/security/business/security-101/what-is-cybersecurity) incidents. It was developed by MITRE, a not-for-profit organisation that was established to advance national security and serve the public interest as an independent advisor. The MITRE ATT&CK helps organizations understand how attackers operate, improve threat detection, and strengthen defense strategies. ATT&CK stands for adversarial tactics, techniques, and common knowledge.

In a way, it's a knowledge database, covering: why an attacker performs a certain action (tactic), how they perform it (technique and sub-technique), and how this looks in the real world (procedures). Besides allowing blue teams (defence teams) to build software to prevent attacks, red teams ("attack simulating teams") to mimic real behaviour, and SOC (Security operations centre) to quickly handle issues, it also gives all of us a common nomenclature, a common way to name what is going on. Imagine joining a call and having to explain each step performed by the attacker in order to make everyone aware of what is going on. It's much easier to just refer to the MITRE ATT&CK framework, as all the explanation needed is already known or at least easily accessible.

That is why it's extremely important for cybersecurity software to highlight the ATT&CK technique they blocked or detected.

Understanding this framework also helps in finding the right data sources. We are normally interested in the smallest set of log sources and fields that still support robust, high-value detections \[2\].

### What good data looks like

I worked for years (7 years) at Cloud companies (Huawei Cloud and AWS). A lot of time writing software that consumed or emitted telemetry for detecting production incidents. The concepts \[3\] are not so far away from the cybersecurity telemetry data.

For cybersecurity \[2\], we should focus on data sources that provide:  

Context: Can we differentiate malicious intent from normal use?

Coverage: "Does the source enable detections for all implementations?"

Robustness: "Does the source enable detections that are difficult to evade?"

Fidelity: "Does the source provide enough detail to fully investigate the activity?"

And these targets are always changing \[4\]: 

> Detection creation is not just about creating and fine-tuning alerts. There are many different ways that a detection can be developed. \[…\] If you don't have an understanding of your landscape, it creates huge gaps in your ability to detect the true bad. MITRE is always changing, always in review. Understand that as the threat landscape increases, as attacks become more complex and interconnected, it is difficult to see the complete picture.

## CIA Triad (Confidentiality, Integrity, Availability)

The CIA triad is the foundation for major governmental regulations, such as Brasil's LGPD and the EU's GPDR. The concept maps information security measures to three components: confidentiality, integrity, and availability. It was introduced by Anderson Report in 1972. It's used mainly as goals or characteristics that software must hold regarding information security \[5\], it's less about "how to detect and prevent cyber attacks" and more about "the bare minimum companies holding your data should do":

**Confidentiality**: the property of information not being available or disclosed to unauthorised users. Data can only be accessed by the intended individuals or entities.

**Integrity:** the property of accuracy and completeness. Data cannot be modified by unauthorised users at any stage of its lifecycle or in transit.

**Availability**: the property of accessibility and usability on demand. Data systems must function so that authorised users are able to access data whenever and wherever they need.

It goes a little bit further than just cybersecurity, as software bugs may also compromise this: errors on permissions, allowing unauthorised employees to access personal information about colleagues, production incidents hurting availability and so on.

\[1\] - <https://www.microsoft.com/en-us/security/business/security-101/what-is-mitre-attack-framework>

\[2\] - <https://ctid.mitre.org/blog/2026/02/19/ambiguous-techniques-extension/>

\[3\] - <https://www.elias.sh/posts/opentelemetry_timeseries_metrics_and_a_bit_of_rust>

\[4\] - <https://www.deepwatch.com/blog/deepwatch-detections-content-and-mitre-attck/>

\[5\] - <https://shardsecure.com/blog/cia-triad-explained>
