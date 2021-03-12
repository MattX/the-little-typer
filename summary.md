--

title: Little Typer reading notes

--

## Chapter 1

Four forms of judgment:

1. _x_ is a _y_
2. _t_ is a type
3. _x_ is the same _t_ as _y_
4. _t_ and _u_ are the same type

Normal forms are the simplest way to write expressions and types. Normal forms for expressions are _according to a type_ (just like equality is). Types also have normal forms. Expressions and types are equal iff their normal forms are equal. Every expression has a normal form.

_Values_ are expressions with a constructor at the top. Expressions are in normal form if they are values, and each argument to the top constructor is also in normal form. Not all values are in normal form.

Evaluation is the process of turning an expression into a value.

## Chapter 2

The opposite of a _constructor_ is an _eliminator_. 

λ is the constructor for functions. Function application is the eliminator for functions.

If _f_ is an (→ _X_ _Y_), and `arg` is an _X_, (_f_  `arg`) is a _Y_. Functions that have the same number of arguments are equal if they are α-equivalent.

Expressions are not values and cannot be evaluated because of a free variable are called _neutral_. Variables are the same as their definition.

### which-Nat

If _target_ is a Nat, _base_ is an _X_, and _step_ is an (→ Nat _X_), then (which-Nat _target_ _base_ _step_) is an _X_.

If (which-Nat zero _base_ _step_) is an _X_, then it's the same _X_ as _base_.

If (which-Nat (add1 _n_) _base_ _step_) is an _X_, then it's the same _X_ as (_step_ _n_).

### 𝒰

Every expression described by 𝒰 is a type, but not every expression that is a type is described by 𝒰. For instance, 𝒰 itself is a type, but is not described by 𝒰 (or by anything else, in Pie). Any type that contains a 𝒰 somewhere is similarly not a 𝒰 itself.

## Interlude

If _X_ is a type and _e_ is an _X_, then (the _X_ _e_) is the same _X_ as _e_.

You can form type expressions containing 𝒰, like (Pair Atom 𝒰), and they have no type, like 𝒰 itself.

## Chapter 3

In Pie, all functions are total.

### iter-Nat

If _target_ is a Nat, _base_ is an _X_, and _step_ is an (→ _X_ _X_), then (iter-Nat _target_ _base_ _step_) is an _X_.

If (iter-Nat zero _base_ _step_) is an _X_, then it's the same _X_ as _base_.

If (iter-Nat (add1 _n_) _base_ _step_) is an _X_, then it's the same _X_ as (_step_ (iter-Nat _n_ _base_ _step_)).

### rec-Nat

If _target_ is a Nat, _base_ is an _X_, and _step_ is an (→ Nat _X_ _X_), then (rec-Nat _target_ _base_ _step_) is an _X_.

If (rec-Nat zero _base_ _step_) is an _X_, then it's the same _X_ as _base_.

If (rec-Nat (add1 _n_) _base_ _step_) is an _X_, then it's the same _X_ as (_step_ _n_ (rec-Nat _n_ _base_ _step_)).

## Chapter 4

We introduce Π with the following law:

> If _f_ is a (Π ((_Y_ 𝒰)) _X_) and _Z_ is a 𝒰, then (_f_ _Z_) is an _X_.

Π lets us define generic functions. Types must be passed explicitly when invoked.

## Chapter 5

Introduces homogenous lists, which use nil as the empty list, and :: instead of cons.

### rec-List

Much like rec-Nat:

* If (rec-List nil _base_ _step_) is an _X_, then it's the same _X_ as _base_.
* If (rec-List (:: _e_ _es_) _base_ _step_) is an _X_, then it's the same _X_ as (_step_ _e_ _es_ (rec-List _es_ _base_ _step_)).

## Chapter 6

We can have arbitrary expressions in types. For instance, (Vec _E_ _k_) is a type if _E_ is a type and _k_ is a Nat. It's the type of lists of _E_ of length exactly _k_.

The law of Π is

> The expression (Π ((_y_ _Y_)) _X_) is a type when _Y_ is a type, and _X_ is a type if _y_ is a _Y_.

→ is just syntactic sugar for Π: specifically, (→ _Y_ _X_) is a shorter way of writing (Π ((_y_ _Y_)) _X_) if _y_ is not used in _X_.

## Chapter 7

`ind-Nat` is like `rec-Nat`, but lets you specify a motive, that is, a type that depends on `n` for the returned expression.

* (ind-Nat zero _mot base step_) is the same (_mot_ zero) as _base_.
* (ind-Nat (add1 _n_) _mot base step_) and (_step_ _n_ (ind-Nat _n mot base step_)) are the same (_mot_ (add1 _n_)).

ind-Nat lets us perform _induction on natural numbers_.

## Chapter 8

More dependent types! First, =. An (= _X from to_) is a type if _X_ is a type, _from_ is an _X_, and _to_ is an _X_. _from_ and _to_ are called the "from" and the "to" of the =-expression, unsurprisingly.

How do we build an =? (same _e_) is an (= _X e e_) if _e_ is an _X_.

We also get a more precise definition of neutral expressions: variables that are not `define`d are neutral, and if the target of an eliminator is neutral, then the eliminator expression is neutral. (But every expression that contains a variable need not be neutral).

We can interpret function types as conditional statements: (→ _X Y_) can be read as "if _X_ then _Y_"; the function tells us how to turn a value of type _X_, i.e. a proof of _X_, into a proof of _Y_.

Once we have a same-expression, we can make a new one with cong. If _f_ is an (→ _X Y_), and _target_ is an (= _X from to_), then (cong _target f_) is an (= _Y_ (_f from_) (_f to_)). If additonally _x_ is an _X_, (cong (same _x_) _f_) is the same (= _Y_ (_f x_) (_f x_)) as (same (_f x_)).