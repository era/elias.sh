---
title: 2 years working with observability
date: 2024-09-10
---

As you get old, you start looking at your past and reflecting on what you learnt. I notice today that I worked more than 2 years 
with observability at Huawei Cloud. On previous roles at Stripe and AWS I looked at observability from the user point of view: how to prove my new feature is working? I was just paged, what is going on with my service? I will be oncall next week, what is the state of our dashboards and alarms?

That is all great, but not the same as working on the platform team focused on observability.

When you are responsible for designing the tools to enable other engineers to properly observe their software, you pay more attention to certain details.

That lead me to write a little bit about my thoughts around observability:

1. [Visualizing Metrics](https://www.elias.sh/posts/visualizing_metrics)
2. [OpenTelemetry, time series, metrics and a bit of Rust](https://www.elias.sh/posts/opentelemetry_timeseries_metrics_and_a_bit_of_rust)

Anyway, I am not here to talk about things I have written in the past. On the last couple of days I have been looking at observability from the perspective of service owner again. This gave me a wish to write down things I encountered in the past, before memory fades it away.

1. Business metrics are crucial, and while the [four golden signals](https://sre.google/sre-book/monitoring-distributed-systems/) provide valuable insights, they don't necessarily prove correctness or easily detect behavior changes. For example, if a client usually sends up to 10 items in a batch request but suddenly starts sending 100, something has changed. This could be an intentional logic change, which is fine, but it might also indicate a bug. Without a quick way to visualize this shift, you may not catch the issue before it leads to more significant problems.
2. Distributed Tracing is amazing, they give us a view similar to logs in a summarised way. Instead of looking for the end-to-end "life of a request" divided into multiple log lines, you have the [waterfall view](https://www.elastic.co/guide/en/observability/current/apm-spans.html) with all the spans. Instrumenting your code and enriching the spans are much more useful than adding logs into random places without any standard.
3. Create alarms for edge cases, do not expect people to "notice when something is wrong".
4. High Cardinality is a big issue, either because of price, or because of indexing. Either way, avoid them when emitting metrics.
5. Logs are still useful. You want macro-views with metrics, detailed summarised views with distributed tracing and logs as a way of diving into more details.
6. [OpenTelemetry](https://opentelemetry.io) is a great idea and it's perfect for avoiding vendor lock-in.




