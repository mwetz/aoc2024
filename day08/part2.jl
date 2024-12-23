# lines = readlines("C:/tmp/factorio/julia/day09/example.txt")
lines = readlines("C:/tmp/factorio/julia/day09/input.txt")

memorypattern = parse.(Int, [i for i in lines[1]])


struct MemBlock
    id::Int64
    size::Int64
end

memory = Vector{MemBlock}()
for (i, j) in enumerate(memorypattern)
    if i % 2 == 0
        push!(memory, MemBlock(-1, j))
    else
        id = Int((i - 1) / 2)
        push!(memory, MemBlock(id, j))
    end
end

for i in reverse(0:memory[end].id)
    # Get position and size of block with id
    block_pos = findfirst(x -> x.id == i, memory)
    block_size = memory[block_pos].size

    # Check if there is sufficient empty space
    empty_pos = findfirst(x -> x.id == -1 && x.size ≥ block_size, memory)

    # If empty space is before block move ahead and reduce empty space
    if empty_pos !== nothing && empty_pos < block_pos
        local block = popat!(memory, block_pos)
        insert!(memory, block_pos, MemBlock(-1, block.size))
        memory[empty_pos] = MemBlock(-1, memory[empty_pos].size - block.size)
        insert!(memory, empty_pos, block)
        # TODO: Merge consecutive empty blocks - not required for solution
    end
end
memory

memory_new = Vector{Int64}()
for b in memory
    append!(memory_new, [b.id for j in 1:b.size])
end
memory_new
memory_new = replace(memory_new, -1 => 0)

checksum = Int128(0)
for (i, j) in enumerate(memory_new)
    global checksum += (i - 1) * j
end
display(checksum)

# 90329907628 - too low
# 96920286140 - too low
# 6378826667552