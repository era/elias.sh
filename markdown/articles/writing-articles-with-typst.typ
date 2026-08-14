---
title: Writing Articles With Typst
date: 3030-08-14
tags: meta, typst
excerpt: How the articles collection works, as a working example of its own conventions.
---

= Introduction

This collection renders long form pieces through Typst instead of Markdown. The
build compiles each file in process and drops the result straight into the
article template, so the conventions below are the ones the template expects,
not suggestions.

A short paragraph can carry *bold* text, _italic_ text, and a #link("https://typst.app")[plain link]
without any special handling.

= Structure

Top level sections use a single equals sign. The template turns them into
numbered headings automatically through CSS counters, so you never write the
number yourself.

== Subsections

A double equals sign nests one level down and picks up a matching `x.y` number.
Keep nesting shallow; three levels is already a lot for a web page.

Lists work as expected.

- first point
- second point
- third point

+ step one
+ step two
+ step three

= Quotes and Code

A block quote:

#quote(block: true)[
  The template renders this as a real blockquote element, styled to sit apart
  from body text.
]

A fenced code block keeps its own monospace styling:

```rust
fn main() {
    println!("compiled in process, no external binary needed");
}
```

= Citations

Because compilation happens on a single self contained file, there is no
external bibliography file to pull from. Citations are built by hand with two
small pieces: an anchor placed at the reference entry, and a link pointing at
that anchor from the body text.

A claim that needs a source looks like this#link("#ref-typst")[#super[[1]]],
and a second claim can point at another entry#link("#ref-squid")[#super[[2]]].

Each anchor is a zero width span with an id, placed right before the entry
text so the numbered list still handles its own numbering:

```
+ #html.elem("span", attrs: (id: "ref-typst"))[] Full citation text here.
```

= References

#html.elem("section", attrs: (class: "references"))[
+ #html.elem("span", attrs: (id: "ref-typst"))[] Typst. _Typst Documentation: HTML Export._ #link("https://typst.app")[typst.app]
+ #html.elem("span", attrs: (id: "ref-squid"))[] Squid. _A static site generator with Typst support._ #link("https://github.com/era/squid")[github.com/era/squid]
]
