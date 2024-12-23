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
    path::Vector{CartesianIndex{2}}
    crossings::Vector{CartesianIndex{2}}
    pos::CartesianIndex{2}
    dir::CartesianIndex{2}
    score::Int
end

function valid_moves(pos, dir, tiles)
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

function follow_path(trail_init, tiles)
    queue = [trail_init]
    best_states = Dict{Tuple{CartesianIndex{2},CartesianIndex{2}},Int}()
    max_cost = 79404
    completed = Vector{Trail}()
    while !isempty(queue)
        trail = popfirst!(queue)

        # Check if we are the least cost path otherwise, we found a better option already
        best_state = get(best_states, (trail.pos, trail.dir), max_cost + 1)
        if trail.score < best_state
            best_states[(trail.pos, trail.dir)] = trail.score
        else
            continue
        end

        # Return score if we reach the end
        if trail.pos == finish
            display(trail.score)
            push!(completed, trail)
        end

        adjacent = valid_moves(trail.pos, trail.dir, tiles)
        for new_dir in adjacent
            if new_dir == trail.dir
                new_score = 1
            else
                new_score = 1001
            end

            if length(adjacent) == 1
                new_crossings = trail.crossings
            else
                new_crossings = vcat(trail.crossings, trail.pos)
            end

            new_trail = Trail(vcat(trail.path, trail.pos + new_dir), new_crossings, trail.pos + new_dir, new_dir, trail.score + new_score)
            pushfirst!(queue, new_trail)
        end

        # Sort queue to continue with best position
        sort!(queue, by=x -> x.score + distance(x.pos, finish))
    end
    return completed
end

init = Trail([start], [], start, CartesianIndex(0, 1), 0)
trails = follow_path(init, tiles)
best_score = reduce(min, map(x -> x.score, trails))
best_trails = filter!(x -> x.score == best_score, trails)
best_trail = best_trails[1]

alt_trails = Vector{Trail}()
for (i, cross) in enumerate(best_trail.crossings)
    println(string(i) * " out of " * string(length(best_trail.crossings)))
    cross_idx = findfirst(x -> x == cross, best_trail.path)
    tiles_blocked = copy(tiles)
    tiles_blocked[best_trail.path[cross_idx+1]] = '#'
    trails_blocked = follow_path(init, tiles_blocked)
    filter!(x -> x.score == best_score, trails_blocked)
    if !isempty(trails_blocked)
        append!(alt_trails, trails_blocked)
    end
end
all_trails = vcat(best_trail, alt_trails)
length(unique(reduce(vcat, map(x -> x.path, all_trails))))

# 405 - too low (length best path only)