# StableHLO Specification Draft

## Types

Following are the supported element types in StableHLO:

  * **Integer types**
    * Signed integer with two’s complement representation. Referred to in the
    document as `si<N>`, where the bit-width N ∊ {4, 8, 16, 32, 64}
    * Unsigned integer referred to in the document as `ui<N>`, where the
    bit-width N ∊ {4, 8, 16, 32, 64}
  * **Boolean types** referred to in the document as `pred`. Exact
  representation of boolean types (e.g. 1 byte per boolean vs 1 bit per boolean)
  is implementation-defined.
  * **Floating-point types**
    * Single precision `f32`, double precision `f64` and half precision `f16`
    floating-points complying with [IEEE 754
    format](https://ieeexplore.ieee.org/document/8766229).
    * Bfloat16 `bf16` floating-point complying with [Brain Floating-Point Format](https://cloud.google.com/blog/products/ai-machine-learning/bfloat16-the-secret-to-high-performance-on-cloud-tpus).
    Provides the same number of exponent bits as `f32`, so that it matches its
    dynamic range, but with greatly reduced precision. This also ensures
    identical behavior for underflows, overflows, and NaNs. However, `bf16`
    handles denormals differently from `f32`: it flushes them to zero.
  * **Complex types** represents a pair of floating-point types. Supported ones
 are `c64` (represents paired `f32`) and `c128` (represents paired `f64`).

StableHLO supports a shaped tensor to model the type of a n-dimensional
array, represented in the opset as `tensor<SxE>` such that

  * Shape `S` is a list of number of elements in each of the dimensions and
  represented, in increasing order of the corresponding dimension number, as an
  array of values of type `ui64`. A zero value in a dimension is allowed and
  represents empty data in that dimension.
  * Element type `E` is any one of the supported element types mentioned above.

## Programs

StableHLO programs consist of functions. Each function has operands and results
of supported types and a list of ops in static single-assignment (SSA) form
which is terminated by a return op which produces the results of the function.
StableHLO ops take operands and produce results.

```mlir
ml_program.func @example_func(%arg: tensor<4x16xf32>) -> tensor<4x16xf32> {
 %1 = stablehlo.floor %arg : tensor<4x16xf32>
 %2 = stablehlo.ceil %arg : tensor<4x16xf32>
 %3 = stablehlo.add %1, %2 : tensor<4x16xf32>
 ml_program.return %3 : tensor<4x16xf32>
}
```

A program is executed by passing argument values to a given function and
computing result values. Result values of a function are computed by evaluating
the graph of ops rooted in the corresponding return op. The evaluation order is
implementation-defined, as long as ops are evaluated before their uses. Possible
execution orders of the above example program are `%1` → `%2` → `%3` → `return`
or `%2` → `%1` → `%3` → `return`.

### Errors

StableHLO programs are validated through an extensive set of constraints for
individual ops, which rules out many classes of errors prior to run time.
However, error conditions are still possible, e.g. through integer overflows,
out-of-bounds accesses, etc. Unless explicitly called out, all these errors
result in implementation-defined behavior.

As an exception to this rule, floating-point exceptions in StableHLO programs
have well-defined behavior. Operations which result in exceptions defined by the
IEEE-754 standard (invalid operation, division-by-zero, overflow, underflow, or
inexact exceptions) produce default results (as defined in the standard) and
continue execution without raising the corresponding status flag; similar to
`raiseNoFlag` exception handling from the standard. Exceptions for nonstandard
operations (e.g. complex arithmetic and certain transcendental functions) are
implementation-defined.

## Constants

The section describes the constants supported in StableHLO along with their
syntax.

  * **Integer Constants** Standard integers, e.g. `123`, are constants of the
  integer type (signed or unsigned). Negative numbers can be used with signed
  integer types.
  * **Boolean Constants** `true` and `false` are both valid constants of the
  `pred` type.
  * **Floating-point Constants** Floating-point constants use standard decimal
  notation, e.g. `123.421`, exponential notation, e.g. `1.23421e+2`, or a more
  precise hexadecimal notation, e.g. `0x42f6d78d`.
  * **Complex Constants** Complex constants are represented as a pair of real
  and imaginary values of `f32` or `f64` types, e.g. `(12.34, 56,78)`.

## Structure of an Op’s Specification

The specification of an op comprises of the following components (in the order
    described below)

  * **Syntax** Operation mnemonic and its signature.
  * **Semantics** Semantics of the operation.
  * **Operands** Meaning of operand(s) and their type(s).
  * **Results** Meaning of the result(s) and the type(s).
  * **Constraints** Constraints on the operand(s) and the result(s).
  * **Examples** Examples demonstrating the working of the op.


## Index of Documented Ops
   * [abs](#stablehloabs)
   * [add](#stablehloadd)
   * [and](#stablehloand)
   * [ceil](#stablehloceil)
   * [constant](#stablehloconstant)
   * [cosine](#stablehlocosine)
   * [divide](#stablehlodivide)
   * [exp](#stablehloexp)
   * [floor](#stablehlofloor)
   * [log](#stablehlolog)
   * [logistic](#stablehlologistic)
   * [max](#stablehlomaximum)
   * [min](#stablehlominimum)
   * [negate](#stablehlonegate)
   * [not](#stablehlonot)
   * [or](#stablehloor)
   * [remainder](#stablehloremainder)
   * [rsqrt](#stablehlorsqrt)
   * [sine](#stablehlosine)
   * [sqrt](#stablehlosqrt)
   * [tanh](#stablehlotanh)
   * [xor](#stablehloxor)

### stablehlo.abs

`stablehlo.abs(operand) -> result`

### Semantics

Performs element-wise absolute value of `operand` tensor and produces a `result`
tensor. For floating-point element types, it implements the `abs` operation from
the IEEE-754 specification.

For n-bit signed integer, the absolute value of $-2^{n-1}$ is implementation-
defined and one of the following:

  * Saturation to $2^{n-1}-1$
  * $-2^n-1$


### Operands

| Name | Type |
|-|-|
| `operand` | tensor of integer, floating-point, or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point, or complex element types |

### Constraints

  * (C1)  `operand` and `result` have the same shape.
  * (C2)  `operand` and `result` have the same element type, except when the
  element type of the `operand` is complex type, in which case the element type
  of the `result` is the element type of the complex type (e.g. the element type
  of the `result` is `f64` for operand type `c128`).

### Examples

```mlir
// integers
// %a: [-2, 0, 2]
%x = stablehlo.abs %a : tensor<3xsi32>
// %x: [2, 0, 2]

// floats
// %b: [-2.2, 0.0, 2.2]
%y = stablehlo.abs %b : tensor<3xf32>
// %y = [2.2, 0.0, 2.2]

// complex
// %c: [(0.0, 1.0), (4.0, -3.0)]
%z = stablehlo.abs %c : tensor<2xc128>
// %z = [1, 5.0]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.add

`stablehlo.add(lhs, rhs) -> result`

### Semantics

Performs element-wise addition of two tensors `lhs` and `rhs` and produces a
`result` tensor. For integer element types, if the element-wise sum has an
unsigned/signed overflow/underflow, the result is implementation-defined and one
of the following:

  * mathematical result modulo $2^n$, where n is the bit width of the result.
  * saturation to $2^{n-1} - 1$ (or $-2^{n-1}$) for signed overflow (or signed
      underflow) and saturation to $2^n - 1$ (or $0$) for unsigned overflow (or
        unsigned underflow).

For floating-point element types, it implements the `addition` operation from
the IEEE-754 specification.

### Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer, floating-point, or complex element types |
| `rhs` | tensor of integer, floating-point, or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point, or complex element types |

### Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

### Examples

```mlir
// %lhs: [[1, 2], [3, 4]]
// %rhs: [[5, 6], [7, 8]]
%result = stablehlo.add %lhs, %rhs : tensor<2x2xf32>
// %result: [[6, 8], [10, 12]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.and

`stablehlo.and(lhs, rhs) -> result`

### Semantics

Performs element-wise bitwise AND of two tensors `lhs` and `rhs` of integer
types and produces a `result` tensor. For boolean tensors, it computes the
logical operation.

## Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer or boolean element types |
| `rhs` | tensor of integer or boolean element types |

## Results

| Name | Type |
|-|-|
| `result` | tensor of integer or boolean element types |

## Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

## Examples

```mlir
// Bitwise operation with with integer tensors
// %lhs: [[1, 2], [3, 4]]
// %rhs: [[5, 6], [7, 8]]
%result = stablehlo.and %lhs, %rhs : tensor<2x2xsi32>
// %result: [[1, 2], [3, 0]]

// Logical operation with with boolean tensors
// %lhs: [[false, false], [true, true]]
// %rhs: [[false, true], [false, true]]
%result = stablehlo.and %lhs, %rhs : tensor<2x2xpred>
// %result: [[false, false], [false, true]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.ceil

`stablehlo.ceil(operand) -> result`

### Semantics

Performs element-wise ceil of `operand` tensor and produces a `result` tensor.
Implements the rounding to integral towards positive infinity operation from the
IEEE-754 specification.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point element types |


### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %x: [-0.8166, -0.2530, 0.2530, 0.8166, 2.0]
%z = stablehlo.ceil %x : tensor<5xf32>
// %z: [-0.0, -0.0, 1.0, 1.0, 2.0]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.constant

`stablehlo.constant(value) -> result`

### Semantics

Produces a `result` tensor from a constant `value`.

### Operands

| Name | Type |
|-|-|
| `value` | tensor of any supported types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of any supported types |

### Constraints

  * (C1) `value` and `result` have the same type.

### Examples

```mlir
%result = stablehlo.constant dense<true> : tensor<pred>
// %result: true

%result = stablehlo.constant dense<0> : tensor<i32>
// %result: 0

%result = stablehlo.constant dense<[[0.0, 1.0], [2.0, 3.0]]> : tensor<2x2xf32>
// %result: [
//       [0.0, 1.0],
//       [2.0, 3.0]
//     ]

%result = stablehlo.constant dense<[(0.0, 1.0), (2.0, 3.0)]> : tensor<2xcomplex<f32>>
// %result: [(0.0, 1.0), (2.0, 3.0)]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.cosine

`stablehlo.cosine(operand) -> result`

### Semantics

Performs element-wise cosine operation on `operand` tensor and produces a
`result` tensor, implementing the `cos` operation from the IEEE-754
specification. Numeric precision is implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [
//            [0.0, 1.57079632],       // [0, pi/2]
//            [3.14159265, 4.71238898] // [pi, 3pi/2]
//           ]
%result = stablehlo.cosine %operand : tensor<2x2xf32>
// %result: [[1.0, 0.0], [-1.0, 0.0]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.divide

`stablehlo.divide(lhs, rhs) -> result`

### Semantics

Performs element-wise division of dividend `lhs` and divisor `rhs` tensors and
produces a `result` tensor. For floating-point element types, it implements the
`division` operation from IEEE-754 specification. For integer element types, it
implements integer division truncating any fractional part. For n-bit integer
types, division overflow (division by zero or division of $-2^{n-1}$ with $-1$)
produces an implementation-defined value.

### Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer, floating-point or complex element types |
| `rhs` | tensor of integer, floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point or complex element types |

### Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

### Examples

  ```mlir
// %lhs: [17.1, -17.1, 17.1, -17.1]
// %rhs: [3.0, 3.0, -3.0, -3.0]
%result = stablehlo.divide %lhs, %rhs : tensor<4xf32>
// %result: [5.66666651, -5.66666651, -5.66666651, 5.66666651]

// %lhs: [17, -17, 17, -17]
// %rhs: [3, 3, -3, -3]
%result = stablehlo.divide %lhs, %rhs : tensor<4xi32>
// %result: [5, -5, -5, 5]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.exp

`stablehlo.exp(operand) -> result`

### Semantics

Performs element-wise exponential operation on `operand` tensor and produces a
`result` tensor. For floating-point element types, it implements the `exp`
operation from the IEEE-754 specification. For complex element types, it
computes a complex exponential, with corner cases TBD. Numeric precision is
implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [[0.0, 1.0], [2.0, 3.0]]
%result = stablehlo.exp %operand : tensor<2x2xf32>
// %result: [[1.0, 2.71828183], [7.38905610, 20.08553692]]

// %operand: (1.0, 2.0)
%result = stablehlo.exp %operand : tensor<complex<f32>>
// %result: (-1.13120438, 2.47172667)
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.floor

`stablehlo.floor(operand) -> result`

### Semantics

Performs element-wise floor of `operand` tensor and produces a `result` tensor.
Implements the rounding to integral towards negative infinity operation from the
IEEE-754 specification.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %x: [-0.8166, -0.2530, 0.2530, 0.8166, 2.0]
%z = stablehlo.floor %x : tensor<5xf32>
// %z: [-1.0, -1.0, 0.0, 0.0, 2.0]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.log

`stablehlo.log(operand) -> result`

### Semantics

Performs element-wise logarithm operation on `operand` tensor and produces a
`result` tensor. For floating-point element types, it implements the `log`
operation from the IEEE-754 specification. For complex element types, it
computes a complex logarithm, with corner cases TBD. Numeric precision is
implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [[1.0, 2.0], [3.0, 4.0]]
%result = stablehlo.log %operand : tensor<2x2xf32>
// %result: [[0.0, 0.69314718], [1.09861229, 1.38629436]]

// %operand: (1.0, 2.0)
%result = stablehlo.log %operand : tensor<complex<f32>>
// %result: (0.80471896, 1.10714871)
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.logistic

`stablehlo.logistic(operand) -> result`

### Semantics

Performs element-wise logistic (sigmoid) function on `operand` tensor and
produces a `result` tensor. For floating-point element types, it implements:
$$logistic(x) = division(1, addition(1, exp(-x)))$$
where `addition`, `division`, and `exp` are operations from IEEE-754
specification. For complex element types, it computes a complex logistic
function, with corner cases TBD. Numeric precision is implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [[0.0, 1.0], [2.0, 3.0]]
%result = stablehlo.logistic %operand : tensor<2x2xf32>
// %result: [[0.5, 0.73105858], [0.88079708, 0.95257413]]

// %operand: (1.0, 2.0)
%result = stablehlo.logistic %operand : tensor<complex<f32>>
// %result: (1.02141536, 0.40343871)
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.maximum

`stablehlo.maximum(lhs, rhs) -> result`

### Semantics

Performs element-wise max operation on tensors `lhs` and `rhs` and produces a
`result` tensor. For floating-point element types, it implements the `maximum`
operation from the IEEE-754 specification. For complex element type, it performs
lexicographic comparison on the (real, imaginary) pairs.

### Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer, floating-point, or complex element types |
| `rhs` | tensor of integer, floating-point, or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point, or complex element types |

### Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

### Examples

```mlir
// %lhs: [[1, 2], [7, 8]]
// %rhs: [[5, 6], [3, 4]]
%result = stablehlo.max %lhs, %rhs : tensor<2x2xi32>
// %result: [[5, 6], [7, 8]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.minimum

`stablehlo.minimum(lhs, rhs) -> result`

### Semantics

Performs element-wise max operation on tensors `lhs` and `rhs` and produces a
`result` tensor. For floating-point element types, it implements the `minimum`
operation from the IEEE-754 specification. For complex element type, it performs
lexicographic comparison on the (real, imaginary) pairs.

### Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer, floating-point, or complex element types |
| `rhs` | tensor of integer, floating-point, or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point, or complex element types |

### Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

### Examples

```mlir
// %lhs: [[1, 2], [7, 8]]
// %rhs: [[5, 6], [3, 4]]
%result = stablehlo.min %lhs, %rhs : tensor<2x2xi32>
// %result: [[1, 2], [3, 4]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.negate

`stablehlo.negate(operand) -> result`

### Semantics

Performs element-wise negation of `operand` tensor and produces a `result`
tensor. For floating-point element types, it implements the `negate` operation
from the IEEE-754 specification. For signed integer types, it performs the
regular negation operation where the negation of $-2^{n-1}$ is implementation-
defined and one of the following:

  * Saturation to $2^{n-1}-1$
  * $-2^n-1$

For unsigned integer types, it bitcasts to the corresponding signed integer type,
performs the regular negation operation and bitcasts back to the original
unsigned integer type.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of integer, floating-point, or complex element types |


### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point, or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// Negation operation with integer Tensors
// %x: [0, -2]
%z = stablehlo.negate %x : tensor<2xsi32>
// %z: [0, 2]

// Negation operation with with complex tensors
// %x: (2.5, 0.0)
%z = stablehlo.negate %x : tensor<1xc64>
// %z: [-2.5, -0.0]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.not

`stablehlo.not(operand) -> result`

### Semantics

Performs element-wise bitwise NOT of tensor `operand` of type integer and
produces a `result` tensor. For boolean tensors, it computes the logical NOT.

### Arguments

| Name | Type |
|-|-|
| `operand` | tensor of integer or boolean element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer or boolean element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// Bitwise operation with with integer tensors
// %operand: [[1, 2], [3, 4]]
%result = stablehlo.not %operand : tensor<2x2xsi32>
// %result: [[-2, -3], [-4, -5]]

// Bitwise operation with with boolean tensors
// %operand: [true, false]
%result = stablehlo.not %operand : tensor<2xpred>
// %result: [false, true]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.or

`stablehlo.or(lhs, rhs) -> result`

### Semantics

Performs element-wise bitwise OR of two tensors `lhs` and `rhs` of integer types
and produces a `result` tensor. For boolean tensors, it computes the logical
operation.

## Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer or boolean element types |
| `rhs` | tensor of integer or boolean element types |

## Results

| Name | Type |
|-|-|
| `result` | tensor of integer or boolean element types |

## Constraints

  * (C1) `operand` and `result` have the same type.

## Examples

```mlir
// Bitwise operation with with integer tensors
// %lhs: [[1, 2], [3, 4]]
// %rhs: [[5, 6], [7, 8]]
%result = stablehlo.or %lhs, %rhs : tensor<2x2xsi32>
// %result: [[5, 6], [7, 12]]

// Logical operation with with boolean tensors
// %lhs: [[false, false], [true, true]]
// %rhs: [[false, true], [false, true]]
%result = stablehlo.or %lhs, %rhs : tensor<2x2xpred>
// %result: [[false, true], [true, true]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.remainder

`stablehlo.remainder(lhs, rhs) -> result`

### Semantics

Performs element-wise remainder of dividend `lhs` and divisor `rhs` tensors and
produces a `result` tensor. The sign of the result is taken from the dividend,
and the absolute value of the result is always less than the divisor's absolute
value. The remainder is calculated as `lhs - d * rhs`, where
`d = stablehlo.divide`. For floating-point element types, this is in contrast
with the `remainder` operation from IEEE-754 specification where `d` is an
integral value nearest to the exact value of `lhs/rhs` with ties to even. For
floating-point types, the corner cases are TBD. For n-bit integer, division
overflow (remainder by zero or remainder of $-2^{n-1}$ with $-1$) produces an
implementation-defined value.

### Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer, floating-point or complex element types |
| `rhs` | tensor of integer, floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of integer, floating-point or complex element types |

### Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

### Examples

```mlir
// %lhs: [17.1, -17.1, 17.1, -17.1]
// %rhs: [3.0, 3.0, -3.0, -3.0]
%result = stablehlo.remainder %lhs, %rhs : tensor<4xf32>
// %result: [2.1, -2.1, 2.1, -2.1]

// %lhs: [17, -17, 17, -17]
// %rhs: [3, 3, -3, -3]
%result = stablehlo.remainder %lhs, %rhs : tensor<4xi32>
// %result: [2, -2, 2, -2]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.rsqrt

`stablehlo.rsqrt(operand) -> result`

### Semantics

Performs element-wise reciprocal square root operation on `operand` tensor and
produces a `result` tensor, implementing the `rSqrt` operation from the IEEE-754
specification. Numeric precision is implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [[1.0, 4.0], [9.0, 25.0]]
%result = stablehlo.rsqrt %operand : tensor<2x2xf32>
// %result: [[1.0, 0.5], [0.33333343, 0.2]]

// %operand: [(1.0, 2.0)]
%result = stablehlo.rsqrt %operand : tensor<complex<f32>>
// %result: [(0.56886448, -0.35157758)]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.sine

`stablehlo.sine(operand) -> result`

### Semantics

Performs element-wise sine operation on `operand` tensor and produces a `result`
tensor, implementing the `sin` operation from the IEEE-754
specification. Numeric precision is implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [
//            [0.0, 1.57079632],       // [0, pi/2]
//            [3.14159265, 4.71238898] // [pi, 3pi/2]
//           ]
%result = stablehlo.sine %operand : tensor<2x2xf32>
// %result: [[0.0, 1.0], [0.0, -1.0]]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.sqrt

`stablehlo.sqrt(operand) -> result`

### Semantics

Performs element-wise square root operation on `operand` tensor and produces a
`result` tensor, implementing the `squareRoot` operation from the IEEE-754
specification.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [[0.0, 1.0], [4.0, 9.0]]
%result = stablehlo.sqrt %operand : tensor<2x2xf32>
// %result: [[0.0, 1.0], [2.0, 3.0]]

// %operand: [(1.0, 2.0)]
%result = stablehlo.sqrt %operand : tensor<complex<f32>>
// %result: [(1.27201965, 0.78615138)]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.tanh

`stablehlo.tanh(operand) -> result`

### Semantics

Performs element-wise tanh operation on `operand` tensor and produces a `result`
tensor, implementing the `tanh` operation from the IEEE-754
specification. Numeric precision is implementation-defined.

### Operands

| Name | Type |
|-|-|
| `operand` | tensor of floating-point or complex element types |

### Results

| Name | Type |
|-|-|
| `result` | tensor of floating-point or complex element types |

### Constraints

  * (C1) `operand` and `result` have the same type.

### Examples

```mlir
// %operand: [-1.0, 0.0, 1.0]
%result = stablehlo.tanh %operand : tensor<3xf32>
// %result: [-0.76159416, 0.0, 0.76159416]
```

[Back to Ops](#index-of-documented-ops)

## stablehlo.xor

`stablehlo.xor(lhs, rhs) -> result`

### Semantics

Performs element-wise bitwise XOR of two tensors `lhs` and `rhs` of integer
types and produces a `result` tensor. For boolean tensors, it computes the
logical operation.

## Operands

| Name | Type |
|-|-|
| `lhs` | tensor of integer or boolean element types |
| `rhs` | tensor of integer or boolean element types |


## Results

| Name | Type |
|-|-|
| `result` | tensor of integer or boolean element types |

## Constraints

  * (C1) `lhs`, `rhs` and `result` have the same type.

## Examples

```mlir
// Bitwise operation with with integer tensors
// %lhs: [[1, 2], [3, 4]]
// %rhs: [[5, 6], [7, 8]]
%result = stablehlo.xor %lhs, %rhs : tensor<2x2xsi32>
// %result: [[4, 4], [4, 12]]

// Logical operation with with boolean tensors
// %lhs: [[false, false], [true, true]]
// %rhs: [[false, true], [false, true]]
%result = stablehlo.xor %lhs, %rhs : tensor<2x2xpred>
// %result: [[false, true], [true, false]]
```

[Back to Ops](#index-of-documented-ops)