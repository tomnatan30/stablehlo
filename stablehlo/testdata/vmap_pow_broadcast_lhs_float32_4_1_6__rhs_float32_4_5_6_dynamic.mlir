// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x4x1x6xf32> {mhlo.sharding = ""}, %arg2: tensor<?x4x5x6xf32> {mhlo.sharding = ""}) -> tensor<?x4x5x6xf32> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<4> : tensor<1xi32>
    %3 = stablehlo.constant dense<5> : tensor<1xi32>
    %4 = stablehlo.constant dense<6> : tensor<1xi32>
    %5 = stablehlo.concatenate %1, %2, %3, %4, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<4xi32>
    %6 = stablehlo.dynamic_broadcast_in_dim %arg1, %5, dims = [0, 1, 2, 3] : (tensor<?x4x1x6xf32>, tensor<4xi32>) -> tensor<?x4x5x6xf32>
    %7 = stablehlo.power %6, %arg2 : tensor<?x4x5x6xf32>
    return %7 : tensor<?x4x5x6xf32>
  }
}

