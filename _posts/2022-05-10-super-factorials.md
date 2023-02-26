---
layout: post
title: Superfactorials - A summary of Advanced Methods of Factorials
tags: Mathematics, factorials
---

Herein, I present a summary of some **advanced methods of factorials**. These are some interesting methods of expressing factorials, which are not commonly known. Still, they can be useful in, rather more specific, cases.

0\. **Standard** factorial

Suppose $n!$ for some $n \in \mathbb{N}$, then:

$$n!=n \times (n-1) \times (n-2) \dots 2 \times 1$$

Which can be expressed more concisely as the following:

$$n!=\prod_{k=1}^{n} n$$

**Double** factorial

The parity of $n$ affects the series. Suppose $n!!$ for some $n \in \mathbb{N}$, then:

$$n!!=
\begin{cases}
  n \times (n-2) \dots 4 \times 2 \text{ | even} \\
  n \times (n-2) \dots 3 \times 1 \text{ | odd}  \\
\end{cases}
$$

Now, written more elegantly as the following expression:

$$n!!=
\begin{cases}
 \prod_{k=1}^{\cfrac{n}{2}} (2 \times k) \text{ | even}      \\
 \prod_{k=1}^{\cfrac{n+1}{2}} (2 \times k - 1) \text{ | odd} \\
\end{cases}
$$

**Subfactorial**

A subfactorial of $n$, denoted as $!n$, expresses the number of de-arrangements of a set with $n$ terms, where $n \in \mathbb{N}$. That is, the number of ways in which $n$ elements can be arranged in a sequence, such that no element is in its original position. The following expression thereby holds:

$$!n = n! \times \big( 1-\frac{1}{1!}+\frac{1}{2!} \times \dots \times (-1)^{n} \times \frac{1}{n!}\big)$$

**Primorial**

Suppose a **primorial** of $n$, denoted as _n#_, which express the series of __prime numbers__ $p$, such that $p \leq n$. That is:

$$n\# = \prod_{p \leq n} p$$

**Super** factorial (the _Sloane_ definition)

Suppose a **super** factorial of $n$, denoted as $sf(n)$, which expresses the series of all $k!$, such that $k \leq n$, where $n, k \in \mathbb{N}$. Hence:

$$sf(n)=n! \times (n-1)! \times (n-2)! \times \dots \times 2! \times 1!$$

Which is similarly expressed in the following form:

$$sf(n)=\prod_{k=1}^{n} k!$$

**Exponential** factorial (also know as the **hyperpower**)

As the name suggests, the **exponential** factorial of $n$, denoted as _n\$_, expresses $n$ raised to the power of $(n-1)$ that is raised to the power of $(n-2)$ and so forth. This relation is also defined with a **recurrent sequence**, such that $a_{n}= n^{a_{n-1}} \land a_{0}= 1$. 

For instance, the **exponential** factorial of $4$ is $4^{3^{2^{1}}}$.

**Hyper** factorial

A **hyper** factorial of $n$, denoted as $H(n)$, expresses the following series:

$$H(n)=n^n \times (n-1)^{n-1} \times (n-2)^{n-2} \times \dots \times 2^2 \times 1^1$$

Or, expressed in a more elegant form:

$$H(n)=\prod_{k=0}^{n} (n-k)^{n-k}$$

These have been some interesting advanced methods for describing alternative forms of factorials. Indeed, there is
a lot more to explore - this is just the tip of the iceberg (i.e., a short summary). Still, there's much to delve into, and some further applications may be covered in the future. For now, I hope you've enjoyed this post, and I hope you've learned something new. In case of some inconsistencies, please, do not hesitate to leave an __issue__ on the `GitHub` repository. Thank you for reading!
