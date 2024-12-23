lines = readlines("C:/tmp/factorio/julia/day09/example.txt")
# lines = readlines("C:/tmp/factorio/julia/day09/input.txt")

memorypattern = parse.(Int, [i for i in lines[1]])

memory = Vector{Char}()
memory_rev = Vector{Char}()
for (i, j) in enumerate(memorypattern)
    if i % 2 == 0
        append!(memory, repeat('.', j))
    else
        id = Int((i - 1) / 2)
        append!(memory, repeat(string(id), j))
        prepend!(memory_rev, repeat(string(id), j))
    end
end


memory_new = Vector{Char}()
spaces = count(x -> x == '.', memory)
for i in memory
    if i == '.'
        append!(memory_new, popfirst!(memory_rev))
    else
        append!(memory_new, i)
    end
end
memory_new = memory_new[1:end-spaces]

checksum =  Int128(0)
for (i, j) in enumerate(memory_new)
    part = (i - 1) * parse(Int, j)
    global checksum += part
end
checksum

# 90329907628 - too low