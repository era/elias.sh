---
title: Learned Indexes, new definition for an old problem
date: 2026-08-15
tags: learned-indexes, databases, indexes, data-structures
excerpt: What if we think of indexes as a ML model?
---

= Introduction

One of the things I love the most in Computer Science is the philosophy behind it. Of course, we are dealing with the real world, but if we abstract problems in the right way, we could find the solution in a very unexpected place. That was my reaction when I first read about "Learned Indexes". #link("https://arxiv.org/abs/1712.01208")[The original paper is very approachable] so I do suggest you all read it, but its introduction goes something like: What if we stopped looking at indexes as these deterministic data-structures and looked at them as models. For example: a B-Tree-Index can be considered
as "a model which takes a key as an input and predicts the position of a data record in a sorted set". If we do such a thing, we can replace them with different models, including deep-learning models, for which they coined the term learned indexes. The crazy part is that this new layer of abstraction works very well: what we call "re-balancing" is just "re-training", and so on.

= The Abstraction

If we know the distribution of the data, we can use an array as our index and have lookups in O(1). Take the simplest example possible: if we have 100 keys from 0 to 99, we can just create an array where Key = Array Position, that way we know exactly where to go to fetch key 51. If we could learn the data distribution of our keys, we could build similar models. Even if we don't have a precision of 100%, given that the keys are sorted, even when we are wrong, we should be close enough to just walk to the region of the array where we were told our key would be, and in very few checks we can find it. In terms of performance, there is a whole argument on the paper about how "every CPU already has powerful SIMD capabilities and [...] that many laptops and mobile phones will soon have a Graphics Processing Unit (GPU) or Tensor Processing Unit (TPU)". 

#html.elem("img", attrs: (src: "https://www.elias.sh/learned_indexes/lerned_keys.png"))


= Range-Indexes

The argument here goes as follows: for efficiency we normally don't index every single key of the sorted records, but rather only the key of every nth record. "Thus, the B-Tree is a model, or in ML terminology, a regression tree:
it maps a key to a position with a min- and max-error (a min-error of 0 and a max-error of the page-size),
with a guarantee that the key can be found in that region if it exists". Therefore we can replace a B-tree with another model, as long as we keep the same guarantees about min-error and max-error. The authors also argue (as I stated before) that the error guarantees don't need to be held, as "the data has to be sorted anyway to support range requests, so any error is
easily corrected by a local search around the prediction (e.g., using exponential search) and thus, even allows
for non-monotonic models."


== Range index models are CDF models

This is the part that I find most interesting: "a model that predicts the position given a
key inside a sorted array effectively approximates the cumulative distribution function (CDF)." Wikipedia defines CDF as "the cumulative distribution function of a real-valued random variable X, or just distribution function of X, evaluated at x, is the probability that X will take a value less than or equal to x". In other words, if the model predicts position 30 for key Y, we can jump to that position and check if Y is the key there. If it's not, we can check position 31; if the key there is greater than Y, then Y is nowhere to be found in our array.

= Conclusion

The way we formulate the question, guides our mind on possible answers. Rephrasing the problem may help us to come with better answers. In my opinion, this paper describes this well. If we keep asking ourselves the same question over decades, we will be pretty good at that theme, but not necessarily will we archive the best solution. Isn't Computer Science beautiful?
