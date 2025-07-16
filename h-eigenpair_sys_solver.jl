using HomotopyContinuation

function solve_and_write_solutions(F, solutions_output_filename)
    local_largest_magnitude_lambda = 0.0
    # println("Solving the system with HomotopyContinuation.jl...")
    result = solve(F)
    # println("Solver finished.")

    # println("Writing solutions to '$solutions_output_filename'...")
    all_sols = solutions(result)
    real_sols_count = length(real_solutions(result))

    # open(solutions_output_filename, "w") do file
    #     write(file, "Solutions for H-Eigenpair System\n")
    #     write(file, "========================================\n\n")
    #     write(file, "Found $(length(all_sols)) total solutions (real and complex).\n")
    #     write(file, "Of these, $real_sols_count are real solutions.\n")
    #     write(file, "----------------------------------------\n")

        for (i, sol) in enumerate(all_sols)
            # write(file, "\n--- Solution $i ---\n")

            λ_val = sol[end]
            x_val = sol[1:end-1]
            # It is better to calculate magnitude from the high-precision value
            magnitude_lambda = abs(λ_val)

            # write(file, "  λ = $(round(λ_val, digits=12))\n")
            # write(file, "  Magnitude of λ = $(round(magnitude_lambda, digits=12))\n")
            
            if magnitude_lambda > local_largest_magnitude_lambda
                local_largest_magnitude_lambda = magnitude_lambda
            end

            # write(file, "  x = [\n")
            # for val in x_val
                # write(file, "        $(round(val, digits=12))\n")
            # end
            # write(file, "      ]\n")
        end
        # write(file, "\n========================================\n")
    # end
    return local_largest_magnitude_lambda
end