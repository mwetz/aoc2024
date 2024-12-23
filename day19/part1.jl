# lines = readlines("C:/tmp/aoc2024/day19/example.txt")
lines = readlines("C:/tmp/aoc2024/day19/input.txt")

towels = string.(split(lines[1], ", "))
patterns = lines[3:end]

struct Towelseq
    matched::Vector{String}
    remaining::String
end

function is_pattern_possible(towels, pattern)
    display(pattern)
    queue = [Towelseq([], pattern)]
    rev_queue = [Towelseq([], pattern)]
    memo = Dict{String,Bool}()

    while !isempty(queue) && !isempty(rev_queue)
        # Get first towelsequence
        towelseq = popfirst!(queue)
        rev_towelseq = popfirst!(rev_queue)

        # If remaining is emptpy return true
        if isempty(towelseq.remaining)
            return true
        end

        if isempty(rev_towelseq.remaining)
            return true
        end

        # Else, check if another towel can be added
        new_towelseqs = Vector{Towelseq}()
        new_rev_towelseqs = Vector{Towelseq}()
        for towel in towels
            if startswith(towelseq.remaining, towel)
                matchseq = push!(copy(towelseq.matched), towel)
                push!(new_towelseqs, Towelseq(matchseq, towelseq.remaining[length(towel)+1:end]))
            end
            if endswith(rev_towelseq.remaining, towel)
                matchseq = pushfirst!(copy(rev_towelseq.matched), towel)
                push!(new_rev_towelseqs, Towelseq(matchseq, rev_towelseq.remaining[1:end-length(towel)]))
            end
        end
        display(new_towelseqs)
        display(new_rev_towelseqs)

        # # If sequence cannot be continured invalidate remaining sequence
        # if isempty(new_towelseqs)
        #     memo[towelseq.remaining] = false
        # end

        # Filter out invalidated sequences
        append!(queue, new_towelseqs)
        append!(rev_queue, new_rev_towelseqs)

        sort!(rev_queue, by=x -> length(x.remaining))
        sort!(queue, by=x -> length(x.remaining))
    end
    return false
end

# count([is_pattern_possible(towels, pattern) for pattern in patterns])

is_pattern_possible(towels, "urbrbuwgbgwwwbgbwrugruburguwgwbgrugwrrbwbubgrwgww")
# 258 - too low
# 284 - too low