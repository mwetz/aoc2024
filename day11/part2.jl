# lines = readlines("C:/tmp/factorio/julia/day11/example.txt")
lines = readlines("C:/tmp/factorio/julia/day11/input.txt")

struct Stone
    value::Int64
    rem::Int32
end

init = parse.(Int, split(lines[1], " "))

memo = Dict{Stone,Int64}()

function eval_stone(stone)
    # Get memoized value
    if stone ∈ keys(memo)
        return memo[stone]
    end

    # If no blinks remain return 1 stone
    if stone.rem == 0
        return 1
    end

    # Evaluate the stone
    stonestr = string(stone.value)
    if stone.value == 0
        new_stone = Stone(1, stone.rem - 1)
        memo[new_stone] = eval_stone(new_stone)
        return memo[new_stone]
    elseif length(stonestr) % 2 == 0
        splitpos = Int(length(stonestr) / 2)
        new_stone_A = Stone(parse(Int, stonestr[1:splitpos]), stone.rem - 1)
        new_stone_B = Stone(parse(Int, stonestr[splitpos+1:end]), stone.rem - 1)
        memo[new_stone_A] = eval_stone(new_stone_A)
        memo[new_stone_B] = eval_stone(new_stone_B)
        return memo[new_stone_A] + memo[new_stone_B]
    else
        new_stone = Stone(stone.value * 2024, stone.rem - 1)
        memo[new_stone] = eval_stone(new_stone)
        return memo[new_stone]
    end
end

res = sum([eval_stone(Stone(i, 75)) for i in init])
res
