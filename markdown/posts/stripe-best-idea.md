---
title: Stripe's best idea
description: "How tokenization shrinks PCI scope to a single service: Stripe's 'abstraction for security'."
date: 2026-10-24
---

Stripe's engineering is really strong and they have had several good ideas, but for me the best one to come out of there is the concept of "abstraction for security". When we build software that handles credit card information, we have to follow PCI.

PCI compliance means adhering to the Payment Card Industry Data Security Standard (PCI DSS), which sets the minimum security requirements for organizations that handle card data. It is not legally mandated, but failing to comply can lead to fines and increased transaction costs. Compliance also makes building software much more expensive: every service that touches a card number inherits audits, network segmentation, encryption rules and restrictions on what can be logged.

Stripe's idea was to move that boundary. Instead of giving the whole software stack access to the card data, only the "front" stores it: the part that receives the card number and sends it to the processing partner. That part is called BAPI, and everything else in the stack gets a UUID instead: a token.

When a service needs to do something with a card, it builds the message with the token, and BAPI swaps the token for the real number right before the message goes to a third party. Tokens are opaque and only meaningful to BAPI, so a token leaking through a log line or a database dump exposes nothing. And because BAPI is small, it is cheap to harden at both the infrastructure and code level: a small surface is easier to audit, easier to keep correct, and easier to make sure we never log what we should not.

Security came from the abstraction boundary, not from discipline everywhere. The idea is cheap to copy elsewhere: don't let data flow through your whole system, especially now that LLM agents write code, and confine it to the systems that truly need it. Abstract it away.

<img src="https://www.elias.sh/stripe.png" />
