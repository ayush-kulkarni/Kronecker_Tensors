using HomotopyContinuation

"""
    generate_singularity_system(A::Array)

Generates the system of equations for finding the singular points of a tensor A.
A non-zero vector x is a singular point if the gradient of the potential
function U(x) = A*x^m vanishes. This is equivalent to A*x^(m-1) = 0.

# Arguments
- `A::Array`: A hypercubic tensor of order `m` and dimension `n`.

# Returns
- `System`: The HomotopyContinuation.jl System object.
- `Vector`: The symbolic variables for the singular vector x.
"""
function generate_singularity_system(A::Array)
    # Get the order (m) and dimension (n) of the tensor
    m = ndims(A)
    n = size(A, 1)

    if !all(d == n for d in size(A))
        error("Input must be a hypercubic tensor.")
    end

    # Define the symbolic variables for the singular vector x
    @var x[1:n]

    # Initialize an empty array to store the expressions
    expressions = []

    # --- Generate the n equations: (A*x^(m-1))_i = 0 ---
    for i in 1:n
        term = 0
        indices_iterator = CartesianIndices(ntuple(_ -> n, m - 1))
        for idx_tuple in indices_iterator
            tensor_element = A[i, idx_tuple.I...]
            x_product = prod(x[idx_tuple[k]] for k in 1:(m-1))
            term += tensor_element * x_product
        end
        push!(expressions, term)
    end
    
    # To avoid the trivial solution x=0, we add a normalization condition.
    # A common choice is a random linear slice.
    coeffs = randn(n)
    push!(expressions, sum(coeffs[i] * x[i] for i in 1:n) - 1)


    # Create the System object
    F = System(expressions, variables = x)

    return F, x
end