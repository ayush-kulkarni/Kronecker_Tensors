using LinearAlgebra

function check_heigenpair(A::Array{Float64, 4}, x::Vector{Complex{Float64}})
    n = size(A, 1)
    m = ndims(A)
    lambda = NaN + NaN*im # To be changed later
    is_eigenvector = false

    # --- Condition 1: Ax^(m-1) = λx^[m-1] ---
    y = zeros(Complex{Float64}, n)
    for i in 1:n
        for j in 1:n
            for k in 1:n
                for l in 1:n
                    y[i] += A[i, j, k, l] * x[j] * x[k] * x[l]
                end
            end
        end
    end
    x_pow = x .^ (m - 1)
    candidate_lambdas = []
    initial_check_passed = true
    for i in 1:n
        # If x[i] is non-zero, calculate a candidate lambda
        if !isapprox(x_pow[i], 0.0)
            push!(candidate_lambdas, y[i] / x_pow[i])
        # If x[i] is zero, y[i] must also be zero for the equation to hold
        elseif !isapprox(y[i], 0.0)
            initial_check_passed = false
            break
        end
    end

    # Check if all candidate lambdas are consistent (approx. equal)
    first_lambda = candidate_lambdas[1]
    all_consistent = all(isapprox(l, first_lambda) for l in candidate_lambdas)
    
    if all_consistent
        is_eigenvector = true
        lambda = first_lambda
    end

    # --- Condition 2: Σxᵢ² = 1 (Normalization) ---
    norm_sum_sq = sum(x.^2)
    is_normalized = isapprox(norm_sum_sq, 1.0)

    # --- Print detailed step-by-step results ---
    # println("--- Verification Report ---")
    # println("Tensor A is order m=$m, dimension n=$n.")
    # println("Testing vector x = $x")
    # println("\n1. Verifying Eigenvector Equation: Ax³ = λx³")
    # println("   Result: Equation holds? -> $is_eigenvector")
    
    # println("\n2. Verifying Normalization: Σxᵢ² = 1")
    # println("   Calculated Σxᵢ² = $norm_sum_sq")
    # println("   Result: Vector is normalized? -> $is_normalized")
    # println("---------------------------")

    return is_eigenvector, is_normalized, lambda
end

# Testing with Tensor B and its corresponding eigenvector x
tensor = reshape([
   -0.1, -0.3, -0.3,  0.0,
   -0.3,  0.0,  0.0,  0.1,
   -0.3,  0.0,  0.0,  0.1,
    0.0,  0.1,  0.1, -0.6
], (2, 2, 2, 2))

x = [-1.4552694507413437 + 0.4702904912729456im,
     -0.6081492536560303 - 1.1253806213018107im]

is_eigenvector, is_normalized, lambda = check_heigenpair(tensor, x)

# --- Final Conclusion ---
# println("\n>>> Conclusion <<<")
# if is_eigenvector
#     println(" The vector satisfies the eigenvector equation Ax³ = λx³.")
# else
#     println(" The vector does not satisfy the eigenvector equation Ax³ = λx³.")
# end
println("   The calculated eigenvalue is:")
println("   λ ≈ $lambda")
# if is_normalized
#     println("\n The vector satisfies the normalization condition Σxᵢ² = 1.")
# else
#     println("\n The vector does not satisfy the normalization condition Σxᵢ² = 1.")
# end

println("\nOverall judgement:")
if is_eigenvector && is_normalized
    println("The pair (λ, x) is a valid H-eigenpair.")
else
    println("The pair (λ, x) is NOT a valid H-eigenpair.")
end