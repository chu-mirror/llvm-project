//--------------------------------------------------------------------------------------------------
// WHEN CREATING A NEW TEST, PLEASE JUST COPY & PASTE WITHOUT EDITS.
//
// Set-up that's shared across all tests in this directory. In principle, this
// config could be moved to lit.local.cfg. However, there are downstream users that
//  do not use these LIT config files. Hence why this is kept inline.
//
// DEFINE: %{sparsifier_opts} = enable-runtime-library=true
// DEFINE: %{sparsifier_opts_sve} = enable-arm-sve=true %{sparsifier_opts}
// DEFINE: %{compile} = mlir-opt %s --sparsifier="%{sparsifier_opts}"
// DEFINE: %{compile_sve} = mlir-opt %s --sparsifier="%{sparsifier_opts_sve}"
// DEFINE: %{run_libs} = -shared-libs=%mlir_c_runner_utils,%mlir_runner_utils
// DEFINE: %{run_libs_sve} = -shared-libs=%native_mlir_runner_utils,%native_mlir_c_runner_utils
// DEFINE: %{run_opts} = -e main -entry-point-result=void
// DEFINE: %{run} = mlir-runner %{run_opts} %{run_libs}
// DEFINE: %{run_sve} = %mcr_aarch64_cmd --march=aarch64 --mattr="+sve" %{run_opts} %{run_libs_sve}

// DEFINE: %{env} =
//--------------------------------------------------------------------------------------------------

// RUN: %{compile} | %{run} | FileCheck %s
//
// Do the same run, but now with direct IR generation.
// REDEFINE: %{sparsifier_opts} = enable-runtime-library=false enable-buffer-initialization=true
// RUN: %{compile} | %{run} | FileCheck %s
//
// Do the same run, but now with direct IR generation and vectorization.
// REDEFINE: %{sparsifier_opts} = enable-runtime-library=false enable-buffer-initialization=true vl=2 reassociate-fp-reductions=true enable-index-optimizations=true
// RUN: %{compile} | %{run} | FileCheck %s
//
// Do the same run, but now with direct IR generation and VLA vectorization.
// RUN: %if mlir_arm_sve_tests %{ %{compile_sve} | %{run_sve} | FileCheck %s %}

#MAT_C_C = #sparse_tensor.encoding<{map = (d0, d1) -> (d0 : compressed, d1 : compressed)}>
#MAT_D_C = #sparse_tensor.encoding<{map = (d0, d1) -> (d0 : dense, d1 : compressed)}>
#MAT_C_D = #sparse_tensor.encoding<{map = (d0, d1) -> (d0 : compressed, d1 : dense)}>
#MAT_D_D = #sparse_tensor.encoding<{
  map = (d0, d1) -> (d1 : dense, d0 : dense)
}>

#MAT_C_C_P = #sparse_tensor.encoding<{
  map = (d0, d1) -> (d1 : compressed, d0 : compressed)
}>

#MAT_C_D_P = #sparse_tensor.encoding<{
  map = (d0, d1) -> (d1 : compressed, d0 : dense)
}>

#MAT_D_C_P = #sparse_tensor.encoding<{
  map = (d0, d1) -> (d1 : dense, d0 : compressed)
}>

module {
  func.func private @printMemrefF64(%ptr : tensor<*xf64>)
  func.func private @printMemref1dF64(%ptr : memref<?xf64>) attributes { llvm.emit_c_interface }

  //
  // Tests with permutation.
  //

  // Concats all sparse matrices (with different encodings) to a sparse matrix.
  func.func @concat_sparse_sparse_perm(%arg0: tensor<2x4xf64, #MAT_C_C_P>, %arg1: tensor<3x4xf64, #MAT_C_D>, %arg2: tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64, #MAT_C_C_P> {
    %0 = sparse_tensor.concatenate %arg0, %arg1, %arg2 {dimension = 0 : index}
         : tensor<2x4xf64, #MAT_C_C_P>, tensor<3x4xf64, #MAT_C_D>, tensor<4x4xf64, #MAT_D_C> to tensor<9x4xf64, #MAT_C_C_P>
    return %0 : tensor<9x4xf64, #MAT_C_C_P>
  }

  // Concats all sparse matrices (with different encodings) to a dense matrix.
  func.func @concat_sparse_dense_perm(%arg0: tensor<2x4xf64, #MAT_C_C_P>, %arg1: tensor<3x4xf64, #MAT_C_D_P>, %arg2: tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64> {
    %0 = sparse_tensor.concatenate %arg0, %arg1, %arg2 {dimension = 0 : index}
         : tensor<2x4xf64, #MAT_C_C_P>, tensor<3x4xf64, #MAT_C_D_P>, tensor<4x4xf64, #MAT_D_C> to tensor<9x4xf64>
    return %0 : tensor<9x4xf64>
  }

  // Concats mix sparse and dense matrices to a sparse matrix.
  func.func @concat_mix_sparse_perm(%arg0: tensor<2x4xf64>, %arg1: tensor<3x4xf64, #MAT_C_D_P>, %arg2: tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64, #MAT_C_C> {
    %0 = sparse_tensor.concatenate %arg0, %arg1, %arg2 {dimension = 0 : index}
         : tensor<2x4xf64>, tensor<3x4xf64, #MAT_C_D_P>, tensor<4x4xf64, #MAT_D_C> to tensor<9x4xf64, #MAT_C_C>
    return %0 : tensor<9x4xf64, #MAT_C_C>
  }

  // Concats mix sparse and dense matrices to a dense matrix.
  func.func @concat_mix_dense_perm(%arg0: tensor<2x4xf64>, %arg1: tensor<3x4xf64, #MAT_C_D>, %arg2: tensor<4x4xf64, #MAT_D_C_P>) -> tensor<9x4xf64> {
    %0 = sparse_tensor.concatenate %arg0, %arg1, %arg2 {dimension = 0 : index}
         : tensor<2x4xf64>, tensor<3x4xf64, #MAT_C_D>, tensor<4x4xf64, #MAT_D_C_P> to tensor<9x4xf64>
    return %0 : tensor<9x4xf64>
  }

  func.func @dump_mat_9x4(%A: tensor<9x4xf64, #MAT_C_C>) {
    %c = sparse_tensor.convert %A : tensor<9x4xf64, #MAT_C_C> to tensor<9x4xf64>
    %cu = tensor.cast %c : tensor<9x4xf64> to tensor<*xf64>
    call @printMemrefF64(%cu) : (tensor<*xf64>) -> ()

    %n = sparse_tensor.number_of_entries %A : tensor<9x4xf64, #MAT_C_C>
    vector.print %n : index

    %1 = sparse_tensor.values %A : tensor<9x4xf64, #MAT_C_C> to memref<?xf64>
    call @printMemref1dF64(%1) : (memref<?xf64>) -> ()

    return
  }

  func.func @dump_mat_dense_9x4(%A: tensor<9x4xf64>) {
    %u = tensor.cast %A : tensor<9x4xf64> to tensor<*xf64>
    call @printMemrefF64(%u) : (tensor<*xf64>) -> ()

    return
  }

  // Driver method to call and verify kernels.
  func.func @main() {
    %m42 = arith.constant dense<
      [ [ 1.0, 0.0 ],
        [ 3.1, 0.0 ],
        [ 0.0, 2.0 ],
        [ 0.0, 0.0 ] ]> : tensor<4x2xf64>
    %m43 = arith.constant dense<
      [ [ 1.0, 0.0, 1.0 ],
        [ 1.0, 0.0, 0.5 ],
        [ 0.0, 0.0, 1.0 ],
        [ 5.0, 2.0, 0.0 ] ]> : tensor<4x3xf64>
    %m24 = arith.constant dense<
      [ [ 1.0, 0.0, 3.0, 0.0],
        [ 0.0, 2.0, 0.0, 0.0] ]> : tensor<2x4xf64>
    %m34 = arith.constant dense<
      [ [ 1.0, 0.0, 1.0, 1.0],
        [ 0.0, 0.5, 0.0, 0.0],
        [ 1.0, 5.0, 2.0, 0.0] ]> : tensor<3x4xf64>
    %m44 = arith.constant dense<
      [ [ 0.0, 0.0, 1.5, 1.0],
        [ 0.0, 3.5, 0.0, 0.0],
        [ 1.0, 5.0, 2.0, 0.0],
        [ 1.0, 0.5, 0.0, 0.0] ]> : tensor<4x4xf64>

    %sm24cc = sparse_tensor.convert %m24 : tensor<2x4xf64> to tensor<2x4xf64, #MAT_C_C>
    %sm34cd = sparse_tensor.convert %m34 : tensor<3x4xf64> to tensor<3x4xf64, #MAT_C_D>
    %sm44dc = sparse_tensor.convert %m44 : tensor<4x4xf64> to tensor<4x4xf64, #MAT_D_C>

    %sm24ccp = sparse_tensor.convert %m24 : tensor<2x4xf64> to tensor<2x4xf64, #MAT_C_C_P>
    %sm34cdp = sparse_tensor.convert %m34 : tensor<3x4xf64> to tensor<3x4xf64, #MAT_C_D_P>
    %sm44dcp = sparse_tensor.convert %m44 : tensor<4x4xf64> to tensor<4x4xf64, #MAT_D_C_P>

    //
    // CHECK:      ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 18
    // CHECK-NEXT: dim = ( 9, 4 )
    // CHECK-NEXT: lvl = ( 4, 9 )
    // CHECK-NEXT: pos[0] : ( 0, 4 )
    // CHECK-NEXT: crd[0] : ( 0, 1, 2, 3 )
    // CHECK-NEXT: pos[1] : ( 0, 5, 11, 16, 18 )
    // CHECK-NEXT: crd[1] : ( 0, 2, 4, 7, 8, 1, 3, 4, 6, 7, 8, 0, 2, 4, 5, 7, 2, 5 )
    // CHECK-NEXT: values : ( 1, 1, 1, 1, 1, 2, 0.5, 5, 3.5, 5, 0.5, 3, 1, 2, 1.5, 2, 1, 1 )
    // CHECK-NEXT: ----
    //
    %4 = call @concat_sparse_sparse_perm(%sm24ccp, %sm34cd, %sm44dc)
               : (tensor<2x4xf64, #MAT_C_C_P>, tensor<3x4xf64, #MAT_C_D>, tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64, #MAT_C_C_P>
    sparse_tensor.print %4 : tensor<9x4xf64, #MAT_C_C_P>

    // CHECK:      {{\[}}[1,   0,   3,   0],
    // CHECK-NEXT:  [0,   2,   0,   0],
    // CHECK-NEXT:  [1,   0,   1,   1],
    // CHECK-NEXT:  [0,   0.5,   0,   0],
    // CHECK-NEXT:  [1,   5,   2,   0],
    // CHECK-NEXT:  [0,   0,   1.5,   1],
    // CHECK-NEXT:  [0,   3.5,   0,   0],
    // CHECK-NEXT:  [1,   5,   2,   0],
    // CHECK-NEXT:  [1,   0.5,   0,   0]]
    %5 = call @concat_sparse_dense_perm(%sm24ccp, %sm34cdp, %sm44dc)
               : (tensor<2x4xf64, #MAT_C_C_P>, tensor<3x4xf64, #MAT_C_D_P>, tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64>
    call @dump_mat_dense_9x4(%5) : (tensor<9x4xf64>) -> ()

    //
    // CHECK:      ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 18
    // CHECK-NEXT: dim = ( 9, 4 )
    // CHECK-NEXT: lvl = ( 9, 4 )
    // CHECK-NEXT: pos[0] : ( 0, 9 )
    // CHECK-NEXT: crd[0] : ( 0, 1, 2, 3, 4, 5, 6, 7, 8 )
    // CHECK-NEXT: pos[1] : ( 0, 2, 3, 6, 7, 10, 12, 13, 16, 18 )
    // CHECK-NEXT: crd[1] : ( 0, 2, 1, 0, 2, 3, 1, 0, 1, 2, 2, 3, 1, 0, 1, 2, 0, 1 )
    // CHECK-NEXT: values : ( 1, 3, 2, 1, 1, 1, 0.5, 1, 5, 2, 1.5, 1, 3.5, 1, 5, 2, 1, 0.5 )
    // CHECK-NEXT: ----
    //
    %6 = call @concat_mix_sparse_perm(%m24, %sm34cdp, %sm44dc)
               : (tensor<2x4xf64>, tensor<3x4xf64, #MAT_C_D_P>, tensor<4x4xf64, #MAT_D_C>) -> tensor<9x4xf64, #MAT_C_C>
    sparse_tensor.print %6 : tensor<9x4xf64, #MAT_C_C>

    // CHECK:      {{\[}}[1,   0,   3,   0],
    // CHECK-NEXT:  [0,   2,   0,   0],
    // CHECK-NEXT:  [1,   0,   1,   1],
    // CHECK-NEXT:  [0,   0.5,   0,   0],
    // CHECK-NEXT:  [1,   5,   2,   0],
    // CHECK-NEXT:  [0,   0,   1.5,   1],
    // CHECK-NEXT:  [0,   3.5,   0,   0],
    // CHECK-NEXT:  [1,   5,   2,   0],
    // CHECK-NEXT:  [1,   0.5,   0,   0]]
    %7 = call @concat_mix_dense_perm(%m24, %sm34cd, %sm44dcp)
               : (tensor<2x4xf64>, tensor<3x4xf64, #MAT_C_D>, tensor<4x4xf64, #MAT_D_C_P>) -> tensor<9x4xf64>
    call @dump_mat_dense_9x4(%7) : (tensor<9x4xf64>) -> ()

    // Release resources.
    bufferization.dealloc_tensor %sm24cc  : tensor<2x4xf64, #MAT_C_C>
    bufferization.dealloc_tensor %sm34cd  : tensor<3x4xf64, #MAT_C_D>
    bufferization.dealloc_tensor %sm44dc  : tensor<4x4xf64, #MAT_D_C>
    bufferization.dealloc_tensor %sm24ccp : tensor<2x4xf64, #MAT_C_C_P>
    bufferization.dealloc_tensor %sm34cdp : tensor<3x4xf64, #MAT_C_D_P>
    bufferization.dealloc_tensor %sm44dcp : tensor<4x4xf64, #MAT_D_C_P>
    bufferization.dealloc_tensor %4  : tensor<9x4xf64, #MAT_C_C_P>
    bufferization.dealloc_tensor %5  : tensor<9x4xf64>
    bufferization.dealloc_tensor %6  : tensor<9x4xf64, #MAT_C_C>
    bufferization.dealloc_tensor %7  : tensor<9x4xf64>
    return
  }
}
