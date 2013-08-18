## querystring-pickle

[![Build Status](https://secure.travis-ci.org/brendanhay/querystring-pickle.png)](http://travis-ci.org/brendanhay/querystring-pickle)


## Table of Contents

* [Introduction](#introduction)
* [Examples](#examples)
* [Common Instances](#common-instances)
  - [Either/Maybe](#either-maybe)
* [Compatibility](#compatibility)
* [Contributing](#contributing)
* [Licence](#licence)


## Introduction

> TODO


## Examples

> TODO


## Common Instances

### Either/Maybe

`IsQuery` instances for `Maybe a` and `Either a b` are not supplied due to
ambiguous semantics, take the following example:

```haskell
instance IsQuery a => IsQuery (Maybe a) where
    queryPickler = qpOption queryPickler

instance (IsQuery a, IsQuery b) => IsQuery (Either a b) where
    queryPickler = queryPickler `qpEither` queryPickler

data A = A { aInt1 :: Int, aInt2 :: Int } deriving (Show, Generic)
data B = B { bA :: Maybe A } deriving (Show, Generic)
data C = C { cB :: B } deriving (Show, Generic)
data D = D { dAInt :: Either A Int } deriving (Show, Generic)

instance IsQuery A
instance IsQuery B
instance IsQuery C
instance IsQuery D

let c = C $ B Nothing
let d = D . Left $ A 1 2
let e = D $ Right 3
```

Running `toQuery` / `fromQuery` on the example bindings yields:

```haskell

λ: toQuery c
[]

λ: fromQuery (toQuery c) :: Either String C
Left "qpElem: non-locatable - B - List []"

λ: toQuery d
[("AInt.Int1","1"),("AInt.Int2","2")]

λ: fromQuery (toQuery d) :: Either String D
Right (D {dAInt = Left (A {aInt1 = 1, aInt2 = 2})})

λ: toQuery e
[("AInt","3")]

λ: fromQuery (toQuery e) :: Either String D
Right (D {dAInt = Right 3})

```

If data type `B` has a second non-optional field, the `fromQuery` deserialisation
of binding `c` will succeed.

This is due to the overly simple underlying rose tree used
as the intermediate data structure for query transforms.
Something that will hopefully be fixed in a future release.

It is left up to the consumer of the library to decide best how to handle this
case. I apologies if it forces anyone to use orhaned instances.


## Compatibility

Due to the dependency on `GHC.Generics` a version of `base 4.6` or higher is required.


## Contributing

For any problems, comments or feedback please create an issue [here on GitHub](github.com/brendanhay/querystring-pickle/issues).


## Licence

querystring-pickle is released under the [Mozilla Public License Version 2.0](http://www.mozilla.org/MPL/)
