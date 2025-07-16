try
    include("runner.jl")

catch e
    println("Error: Make sure 'runner.jl' is in the same directory as this script.")
    rethrow(e)
end

function kronecker_product(A::AbstractArray, B::AbstractArray)
    # Get the sizes of the input tensors
    sA = size(A)
    sB = size(B)

    # Ensure the tensors have the same number of dimensions
    if ndims(A) != ndims(B)
        error("Input tensors must have the same number of dimensions. Got $(ndims(A)) and $(ndims(B))")
    end

    # The Kronecker product can be computed efficiently by repeating each element of A to match the size of B, and tiling B to match the size of A followed by an element-wise product.
    A_repeated = repeat(A, inner=sB)
    B_repeated = repeat(B, outer=sA)

    return A_repeated .* B_repeated
end

function check()
    # Run the workflow for Tensor A 
    # println("Running workflow for Tensor A:")
    largest_magnitude_lambda_A = run_heigenpair_workflow(tensor_A, "A")

    # Run the workflow for Tensor B
    # println("\nRunning workflow for Tensor B:")
    largest_magnitude_lambda_B = run_heigenpair_workflow(tensor_B, "B")

    # Run the workflow for Tensor C (Tensor B ⊗ Tensor A)
    # println("\nRunning workflow for Tensor C (Tensor B ⊗ Tensor A):")
    largest_magnitude_lambda_C = run_heigenpair_workflow(kronecker_product_result, "C")

    product_of_lambdas = largest_magnitude_lambda_A * largest_magnitude_lambda_B

    println("\n--- Verification ---")
    println("Largest |λ_A|: $largest_magnitude_lambda_A")
    println("Largest |λ_B|: $largest_magnitude_lambda_B")
    println("Largest |λ_C|: $largest_magnitude_lambda_C")
    println("|λ_A| * |λ_B|: $product_of_lambdas")

    if isapprox(product_of_lambdas, largest_magnitude_lambda_C, atol=1e-8)
        println("\nCheck PASSED: |λ_A| * |λ_B| is approximately equal to |λ_C| (precision 1e-8).")
    else
        println("\nCheck FAILED: |λ_A| * |λ_B| is NOT equal to |λ_C|.")
        println("Difference: $(abs(product_of_lambdas - largest_magnitude_lambda_C))")
    end
end

# Tensor A Values
a_values = [
    # Slice (:,:,1,1)
    -0.5,  0.6,
     0.6,  0.2,
    # Slice (:,:,2,1)
     0.6,  0.2,
     0.2,  0.1,
    # Slice (:,:,1,2)
     0.6,  0.2,
     0.2,  0.1,
    # Slice (:,:,2,2)
     0.2,  0.1,
     0.1, -1.7
]

# Reshape the flat list into a 2x2x2x2 tensor.
tensor_A = reshape(a_values, 2, 2, 2, 2)

# Tensor B Values
b_values = [
    # Slice (:,:,1,1)
    -0.3,  1.0,
     1.0,  0.1,
    # Slice (:,:,2,1)
     1.0,  0.1,
     0.1, -1.0,
    # Slice (:,:,1,2)
     1.0,  0.1,
     0.1, -1.0,
    # Slice (:,:,2,2)
     0.1, -1.0,
    -1.0, -0.9
]

# Reshape the flat list into a 2x2x2x2 tensor.
tensor_B = reshape(b_values, 2, 2, 2, 2)

# println("\nKronecker Product (Tensor B ⊗ Tensor A):")
kronecker_product_result = kronecker_product(tensor_B, tensor_A)
# println("The resulting tensor is of size: ", size(kronecker_product_result)) 

# display(kronecker_product_result)
# display(reshape(kronecker_product_result, (16, 16)))

check()