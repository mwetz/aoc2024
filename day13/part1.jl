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
        machine = Machine(claw_A, claw_B, target)
        push!(machines, machine)
    end
end
machines


function evaluate_machine(machine)
    valid = Vector{CartesianIndex{2}}()
    for i in 1:Int(floor(machine.target[1] / min(machine.A[1], machine.B[1])))
        for j in 1:Int(floor(machine.target[2] / min(machine.A[2], machine.B[2])))
            if i * machine.A + j * machine.B == machine.target
                push!(valid, CartesianIndex(i, j))
            end
        end
    end
    if length(valid) == 0
        return 0
    else
        return reduce(min, map(x -> x[1] * 3 + x[2], valid))
    end
end

display(sum([evaluate_machine(m) for m in machines]))
