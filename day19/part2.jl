# lines = readlines("C:/tmp/aoc2024/day19/example.txt")
lines = readlines("C:/tmp/aoc2024/day19/input.txt")

towels = string.(split(lines[1], ", "))
patterns = lines[3:end]

function count_combinations(towels, pattern)
    display(pattern)
    memo = Dict{String,Int}()
    return check_sequence(towels, pattern, memo)
end

function check_sequence(towels, remaining, memo)
    if remaining ∈ keys(memo)
        return memo[remaining]
    end

    if isempty(remaining)
        return 1
    end

    results = Vector{Int}()
    for towel in towels
        if startswith(remaining, towel)
            push!(results, check_sequence(towels, remaining[length(towel)+1:end], memo))
        end
    end
    res = sum(results)
    memo[remaining] = res
    return res
end

sum([count_combinations(towels, pattern) for pattern in patterns])
