using HomotopyContinuation

function solve_and_write_solutions(F, solutions_output_filename)
    local_largest_magnitude_lambda = 0.0
    # println("Solving the system with HomotopyContinuation.jl...")
    result = solve(F)
    # println("Solver finished.")

    # println("Writing solutions to '$solutions_output_filename'...")
    all_sols = solutions(result)
    real_sols = real_solutions(result)
    real_sols_count = length(real_solutions(result))

    if (real_sols_count == 0)
        # println("No real solutions found.")
        return -1
    end

    open(solutions_output_filename, "w") do file
        write(file, "Solutions for H-Eigenpair System\n")
        write(file, "========================================\n\n")
        write(file, "Found $(length(all_sols)) total solutions (real and complex).\n")
        write(file, "Of these, $real_sols_count are real solutions.\n")
        write(file, "----------------------------------------\n")

        for (i, sol) in enumerate(all_sols)
            write(file, "\n--- Solution $i ---\n")

            λ_val = sol[end]
            x_val = sol[1:end-1]
            # It is better to calculate magnitude from the high-precision value
            magnitude_lambda = abs(λ_val)

            write(file, "  λ = $(round(λ_val, digits=12))\n")
            write(file, "  Magnitude of λ = $(round(magnitude_lambda, digits=12))\n")
            
            if magnitude_lambda > local_largest_magnitude_lambda
                local_largest_magnitude_lambda = magnitude_lambda
            end
            
            write(file, "  x = [\n")
            for val in x_val
                write(file, "        $(round(val, digits=12))\n")
            end
            write(file, "      ]\n")
        end
        write(file, "\n========================================\n")



        local_largest_magnitude_lambda_2 = 0.0
        for (j, sol_2) in enumerate(real_sols)
            λ_val_2 = sol_2[end]
            x_val_2 = sol_2[1:end-1]
            magnitude_lambda_2 = abs(λ_val_2)
            if magnitude_lambda_2 > local_largest_magnitude_lambda_2
                local_largest_magnitude_lambda_2 = magnitude_lambda_2
            end
        end

        if (local_largest_magnitude_lambda_2 == local_largest_magnitude_lambda)
            # print("Largest magnitude of real solutions matches the largest magnitude of all solutions.\n")
        else
            return -1
            # print("WARNING: Largest magnitude of real solutions does not match the largest magnitude of all solutions.\n")
        end
        

    end
    return local_largest_magnitude_lambda
end