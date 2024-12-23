# lines = readlines("C:/tmp/factorio/julia/day11/example.txt")
lines = readlines("C:/tmp/factorio/julia/day11/input.txt")

init = parse.(Int, split(lines[1], " "))

function blink(stones)
    stones_new = Vector{Int64}()
    for stone in stones
        stonestr = string(stone)
        if stone == 0
            push!(stones_new, 1)
        elseif length(stonestr) % 2 == 0
            splitpos = Int(length(stonestr) / 2)
            push!(stones_new, parse(Int, stonestr[1:splitpos]))
            push!(stones_new, parse(Int, stonestr[splitpos+1:end]))
        else
            push!(stones_new, stone * 2024)
        end
    end
    return stones_new
end

function blink_n_times(stones, blinks)
    for i in 1:blinks
        stones = blink(stones)
    end
    return length(stones)
end

blink_n_times(init, 25)
