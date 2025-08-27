function generate_heigenpair_system(A::Array)
    # Get the order (m) and dimension (n) of the tensor
    m = ndims(A)
    n = size(A, 1)

    if !all(d == n for d in size(A))
        error("Tensor must have all dimensions must be equal.")
    end

    @var x[1:n] λ
    all_vars = [x..., λ]

    # Initialize an empty array to store the expressions (lhs - rhs)
    expressions = []

    # --- Generate the first n expressions ---
    for i in 1:n
        lhs = 0
        indices_iterator = CartesianIndices(ntuple(_ -> n, m - 1))
        for idx_tuple in indices_iterator
            tensor_element = A[i, idx_tuple.I...]
            x_product = prod(x[idx_tuple[k]] for k in 1:(m-1))
            lhs += tensor_element * x_product
        end
        rhs = λ * x[i]^(m-1)
        
        # Create the expression (lhs - rhs) and add it to our list
        push!(expressions, lhs - rhs)
    end

    # --- Generate the normalization expression ---
    normalization_expr = sum(x[i]^2 for i in 1:n) - 1
    push!(expressions, normalization_expr)

    # --- Create the System for HomotopyContinuation.jl ---
    # The System is built directly from the expressions and variables.
    F = System(expressions, variables = all_vars)

    # Return the system and the expressions for logging purposes.
    return F, expressions, x, λ
end
