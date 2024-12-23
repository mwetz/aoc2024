# lines = readlines("C:/tmp/aoc2024/day16/example.txt")
lines = readlines("C:/tmp/aoc2024/day16/input.txt")
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))

start = findfirst(x -> x == 'S', tiles)
finish = findfirst(x -> x == 'E', tiles)

turn_left = Dict(
    CartesianIndex(1, 0) => CartesianIndex(0, -1),
    CartesianIndex(0, -1) => CartesianIndex(-1, 0),
    CartesianIndex(-1, 0) => CartesianIndex(0, 1),
    CartesianIndex(0, 1) => CartesianIndex(1, 0),
)

turn_right = Dict(value => key for (key, value) in turn_left)

struct Trail
    # path::Vector{CartesianIndex{2}}
    pos::CartesianIndex{2}
    dir::CartesianIndex{2}
    score::Int
end

function valid_moves(pos, dir)
    moves = Vector{CartesianIndex{2}}()
    if tiles[pos+turn_right[dir]] != '#'
        push!(moves, turn_right[dir])
    end
    if tiles[pos+dir] != '#'
        push!(moves, dir)
    end
    if tiles[pos+turn_left[dir]] != '#'
        push!(moves, turn_left[dir])
    end
    return moves
end

function distance(a, b)
    return sum(abs.((b - a).I))
end

function follow_path(trail_init,)
    queue = [trail_init]
    best_states = Dict{Tuple{CartesianIndex{2},CartesianIndex{2}},Int}()
    completed = Vector{Trail}()
    while !isempty(queue)
        trail = popfirst!(queue)

        # Check if we are the least cost path otherwise, we found a better option already
        best_state = get(best_states, (trail.pos, trail.dir), Inf)
        if trail.score < best_state
            best_states[(trail.pos, trail.dir)] = trail.score
        else
            continue
        end

        # Return score if we reach the end
        if trail.pos == finish
            push!(completed, trail)
        end

        adjacent = valid_moves(trail.pos, trail.dir)
        for new_dir in adjacent

            if new_dir == trail.dir
                new_score = 1
            else
                new_score = 1001
            end
            new_trail = Trail(trail.pos + new_dir, new_dir, trail.score + new_score)
            pushfirst!(queue, new_trail)
        end

        # Sort queue to continue with best position
        sort!(queue, by=x -> x.score + distance(x.pos, finish))
    end
    return completed
end

init = Trail(start, CartesianIndex(0, 1), 0)
trails = follow_path(init)
reduce(min, map(x -> x.score, trails))

# 148532 - too high
# 143524 - too high
# 141524 - too high