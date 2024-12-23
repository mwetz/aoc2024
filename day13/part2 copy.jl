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
    a = (machine.target[1] - machine.target[2] * machine.B[1] / machine.B[2]) / (machine.A[1] - machine.A[2] * machine.B[1] / machine.B[2])
    b = (machine.target[1] - machine.A[1] * a) / machine.B[1]

    if abs(a - round(a)) < 0.01 && abs(b - round(b)) < 0.01
        return 3 * round(a) + round(b)
    else
        return 0
    end
end

display(Int(sum([evaluate_machine(m) for m in machines])))

# 103250856399884 too low
# 105933713809561
# 107824497933339 # correct
# 107824497933339
# 119202234398253 too high
# 202737377421204032 too high
