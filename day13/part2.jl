using JuMP
using HiGHS

# lines = readlines("C:/tmp/factorio/julia/day13/example.txt")
lines = readlines("C:/tmp/factorio/julia/day13/input.txt")

struct Machine
    A::CartesianIndex{2}
    B::CartesianIndex{2}
    target::CartesianIndex{2}
end

machines = Vector{Machine}()
for (i, line) in enumerate(lines)
    if i % 4 == 1
        global claw_A = match(r"X[\+\=](\d+), Y[\+\=](\d+)", line)
        global claw_A = CartesianIndex(parse(Int, claw_A[1]), parse(Int, claw_A[2]))
    elseif i % 4 == 2
        global claw_B = match(r"X[\+\=](\d+), Y[\+\=](\d+)", line)
        global claw_B = CartesianIndex(parse(Int, claw_B[1]), parse(Int, claw_B[2]))
    elseif i % 4 == 3
        global target = match(r"X[\+\=](\d+), Y[\+\=](\d+)", line)
        global target = CartesianIndex(parse(Int, target[1]), parse(Int, target[2]))
        machine = Machine(claw_A, claw_B, target + CartesianIndex(10_000_000_000_000, 10_000_000_000_000))
        push!(machines, machine)
    end
end
machines

function evaluate_machine(machine)
    m = Model(HiGHS.Optimizer)
    # set_attribute(m, "presolve", "on")
    set_attribute(m, "solver", "ipm")
    set_attribute(m, "simplex_scale_strategy", 0)
    set_silent(m)
    @variable(m, a ≥ 0, Int)
    @variable(m, b ≥ 0, Int)
    @constraint(m, a * machine.A[1] + b * machine.B[1] == machine.target[1])
    @constraint(m, a * machine.A[2] + b * machine.B[2] == machine.target[2])
    @objective(m, Min, 3 * a + b)
    optimize!(m)
    if is_solved_and_feasible(m)
        val_a = value(a)
        val_b = value(b)
        if abs(val_a - round(val_a)) < 0.001 && abs(val_b - round(val_b)) < 0.001
            return 3 * round(val_a) + round(val_b)
        else
            return 0
        end
    else
        return 0
    end
end

display(round(Int, sum([evaluate_machine(m) for m in machines])))

# 103250856399884 too low
# 105933713809561
# 107824497933339 # correct
# 119202234398253 too high
# 202737377421204032 too high
