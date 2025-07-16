using HomotopyContinuation

function solve_and_write_solutions(F, solutions_output_filename)
    println("Solving the system with HomotopyContinuation.jl...")
    result = solve(F)
    println("Solver finished.")

    println("Writing solutions to '$solutions_output_filename'...")
    all_sols = solutions(result)
    real_sols_count = length(real_solutions(result))

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

            write(file, "  λ = $(round(λ_val, digits=8))\n")
            write(file, "  Magnitude of λ = $(abs(round(λ_val, digits=8)))\n")
            write(file, "  x = [\n")
            for val in x_val
                write(file, "        $(round(val, digits=8))\n")
            end
            write(file, "      ]\n")
        end
        write(file, "\n========================================\n")
    end
end