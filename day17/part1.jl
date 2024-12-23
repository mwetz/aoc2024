# lines = readlines("C:/tmp/aoc2024/day17/example.txt")
lines = readlines("C:/tmp/aoc2024/day17/input.txt")

A = parse(Int, match(r"Register A: (\d+)", lines[1])[1])
B = parse(Int, match(r"Register B: (\d+)", lines[2])[1])
C = parse(Int, match(r"Register C: (\d+)", lines[3])[1])

program = parse.(Int, split(match(r"Program: ((\d+,?)+)$", lines[5])[1], ","))

mutable struct Register
    A::Int
    B::Int
    C::Int
end


function adv(reg, combo, instrpoint, combo_ops, output)
    reg.A = floor(Int, reg.A / 2^combo_ops[combo])
    return (reg, instrpoint + 2, output)
end

function bdv(reg, combo, instrpoint, combo_ops, output)
    reg.B = floor(Int, reg.A / 2^combo_ops[combo])
    return (reg, instrpoint + 2, output)
end

function cdv(reg, combo, instrpoint, combo_ops, output)
    reg.C = floor(Int, reg.A / 2^combo_ops[combo])
    return (reg, instrpoint + 2, output)
end

function bxl(reg, combo, instrpoint, combo_ops, output)
    reg.B = reg.B ⊻ combo
    return (reg, instrpoint + 2, output)
end

function bxc(reg, combo, instrpoint, combo_ops, output)
    reg.B = reg.B ⊻ reg.C
    return (reg, instrpoint + 2, output)
end

function bst(reg, combo, instrpoint, combo_ops, output)
    reg.B = combo_ops[combo] % 8
    return (reg, instrpoint + 2, output)
end

function jnz(reg, combo, instrpoint, combo_ops, output)
    if reg.A == 0
        return (reg, instrpoint + 2, output)
    else
        return (reg, combo + 1, output)
    end
end

function fnout(reg, combo, instrpoint, combo_ops, output)
    push!(output, combo_ops[combo] % 8)
    return (reg, instrpoint + 2, output)
end

function run_program(program, reg)
    output = []

    instr_ops = Dict(
        0 => adv,
        1 => bxl,
        2 => bst,
        3 => jnz,
        4 => bxc,
        5 => fnout,
        6 => bdv,
        7 => cdv,
    )


    pinstr = 1
    while pinstr < length(program)
        println("#####")
        display(pinstr)
        display(instr_ops[program[pinstr]])
        display(reg)

        combo_ops = Dict(
            0 => 0,
            1 => 1,
            2 => 2,
            3 => 3,
            4 => reg.A,
            5 => reg.B,
            6 => reg.C,
        )

        (reg, pinstr, output) = instr_ops[program[pinstr]](reg, program[pinstr+1], pinstr, combo_ops, output)
    end
    return (output, reg)
end

# run_program([2, 6], Register(0, 0, 9))
# run_program([5, 0, 5, 1, 5, 4], Register(10, 0, 0))
# run_program([0, 1, 5, 4, 3, 0], Register(2024, 0, 0))
# run_program([1, 7], Register(0, 29, 0))
# run_program([4, 0], Register(0, 2024, 43690))
# run_program([0,1,5,4,3,0], Register(729, 0, 0))
(output, reg) = run_program(program, Register(A, B, C))
join(output, ',')