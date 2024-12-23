# lines = readlines("C:/tmp/factorio/julia/day09/example.txt")
lines = readlines("C:/tmp/factorio/julia/day09/input.txt")

memorypattern = parse.(Int, [i for i in lines[1]])

memory = Vector{String}()
for (i, j) in enumerate(memorypattern)
    if i % 2 == 0
        append!(memory, ["." for j in 1:j])
    else
        id = Int((i - 1) / 2)
        append!(memory, [string(id) for j in 1:j])
    end
end
memory

while count(x -> x == ".", memory) > 0
    local block = pop!(memory)
    local pos = findfirst(x -> x == ".", memory)
    memory[pos] = block
end
memory_new = parse.(Int, memory)

checksum = Int128(0)
for (i, j) in enumerate(memory_new)
    global checksum += (i - 1) * j
end
display(checksum)

# 90329907628 - too low
# 96920286140 - too low
# 6378826667552

something