---
layout: post
title: Basic Concepts in Computer Science
---

A short introduction to some basic concepts in computer science.

## Boolean Logic and Logic Gates

Representing __transistors__ of two states - the __binary__ representation $\Rightarrow$ `true/false` & $0/1$ - representing raw electrical signals.

In terms of mathematics - the field of __Boolean Algebra__ (named after [__George Boole__](https://en.wikipedia.org/wiki/George_Boole)). Fundamental operators in __Boolean Algebra__: __and__, __or__, __not__ $\to$ the values are only `true/false`.

__Transistor__ may be thought of as an *electrically controlled switch*.

### NOT operator Gate ($\neg$)

```txt
              / --- 1st electrode
--- control_wire 
              \ --- 2nd electrode
```

In order to reach an __output__ from a transistor, there needs to be some __input__. A `NOT` indicates the __negation__.


### AND operator Gate ($\land$)

We assume that the transistor only yields `true`, such that both of the inputs are `true`.

```txt
--- control_wire --- o --- o ---- output
                     |     | 
                     A     B
```

### OR operator Gate ($\lor$)

We assume that the transistor yields `true` $\iff$ either of inputs is true or both are true.

```txt
                / --- A --- \
--- control_wire              --- output
                \ --- B --- /
```

### Exclusive OR (`XOR`) operator Gate ($\oplus$) 

We assume that the transistor yields `true` $\iff$ either of inputs is true only. A `XOR` Gate is created from a __combination__ of other __gate operators__.

### Representing Numbers and Letters with Binary

In a __binary representation__, we rely on the 2 possible digits: $[0, 1]$, i.e. a base-two notation.

Expressed __mathematically__ (conversion `bin -> dec`):

$$(A)_{2} = (B)_{10} \equiv \sum_{i = 0}^{n = \bar{A}} A_{i}^{n - i}$$

where $\bar{A}$ denotes the number of digits of $A$, and $A_{i}$ is the $i$-th digit of $A$.

Conversion `dec -> bin`: 

We rely on the [__modulo__](https://en.wikipedia.org/wiki/Modulo_operation) ($\%$) operator. Example given (no. 47):

| remainder | mod ($n \% 2$) | 
| :-------: | :------------: |
| 47        | -              |
| 23        | 1              |
| 11        | 1              |
| 5         | 1              |
| 2         | 1              |
| 1         | 0              |
| 0         | 1              |

We then __concatenate__ the digits to a binary notation from bottom to the top $\Rightarrow (47)_{10} = (101111)_2$.

Each `0,1` represents a single `bit` (`b`), hence a number made from $n$ bits belongs to the interval from $0$ to $(2^{n} - 1) \subset \mathbb{N}$, making $2^{n}$ total __possible numbers__. 

\*First bit - __sign__ of the number; positive - `0`, negative - `1`.

- 8 `bit`s (b) = 1 `Byte` (B)

__Floating point numbers__ (`float`): sign + exponent + significant.

### Representing textual data

1. __ASCII__: `7-bit` - 128 characters.
2. __Extended ASCII__: `8-bits` - 256 characters.
3. __Unicode__: single universal __encoding scheme__ - `16-bits`.

### Compilers and Interpreters

__TL;DR__

- __Interpreter__: direct translation, one-by-one, to execute each line from instructions (much slower process; each translation is processed manually).
- __Compiler__: all instructions processed at once; there's no space to fix a problem on the go, though performs much faster.
