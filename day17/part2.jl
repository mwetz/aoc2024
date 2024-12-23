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

function run_program(program, reg, A_new)
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

function seq_to_int(seq)
    sum([d * 8^((length(seq) - i)) for (i, d) in enumerate(seq)])
end

function find_sequence()
    init = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    pos = 1
    while pos < 16
        (output, reg) = run_program(program, Register(seq_to_int(init), B, C), seq_to_int(init))
        if output[end-pos:end] == program[end-pos:end]
            display(init)
            display(program[end-pos:end])
            display(output[end-pos:end])
            pos += 1
        else
            init[pos] += 1
        end
    end
    display(init)
end

find_sequence()
init = [3, 0, 57, 10699, 4, 3, 17, 3, 310, 1, 0, 4, 6, 3, 2]
(output, reg) = run_program(program, Register(seq_to_int(init), B, C), seq_to_int(init))
display(program)
display(output)
display(seq_to_int(init))