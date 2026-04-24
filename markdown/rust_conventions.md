---
title: Rust conventions 
date: 2025-02-24
---

(this is not really a blog post, but rather a note that I will keep updating)

A list of Rust conventions that may not be that obvious for newcomers:

## Functions that transforms data

1. `as_$type`: Cheap (low-cost) conversions (e.g. `as_bytes()`)
2. `to_$type`: Higher-cost conversions that needs some "work" to be done, may need to allocate (e.g. `to_string`)
3. `into()` (`impl trait From`): Similar to `to_$type`.
