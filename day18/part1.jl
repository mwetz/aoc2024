# lines = readlines("C:/tmp/aoc2024/day18/example.txt")
# tilesize = 7
lines = readlines("C:/tmp/aoc2024/day18/input.txt")
tilesize = 71
memblocks = map(((x, y),) -> CartesianIndex(y + 1, x + 1), map(x -> parse.(Int, split(x, ',')), lines))

tiles = Array{Char}(undef, tilesize, tilesize)
tiles[:, :] .= '.'
start = CartesianIndex(1, 1)
finish = CartesianIndex(tilesize, tilesize)

function simulate_corruption(tiles, memblocks, nanoseconds)
    for mem in memblocks[1:nanoseconds]
        tiles[mem] = '#'
    end
    return tiles
end

function is_in_bounds(position)
    return position[1] ≥ 1 && position[1] ≤ size(tiles)[1] && position[2] ≥ 1 && position[2] ≤ size(tiles)[2]
end

struct Trail
    path::Vector{CartesianIndex{2}}
    pos::CartesianIndex{2}
    score::Int
end

directions = [
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1)
]

function valid_moves(pos, tiles)
    moves = Vector{CartesianIndex{2}}()
    for dir in directions
        if is_in_bounds(pos + dir) && tiles[pos+dir] != '#'
            push!(moves, dir)
        end
    end
    return moves
end

function distance(a, b)
    return sum(abs.((b - a).I))
end

function follow_path(trail_init, tiles)
    queue = [trail_init]
    best_states = Dict{CartesianIndex{2},Int}()
    completed = Vector{Trail}()
    while !isempty(queue)
        trail = popfirst!(queue)

        # Check if we are the least cost path otherwise, we found a better option already
        best_state = get(best_states, trail.pos, Inf)
        if trail.score < best_state
            best_states[trail.pos] = trail.score
        else
            continue
        end

        # Return score if we reach the end
        if trail.pos == finish
            display(trail.score)
            push!(completed, trail)
        end

        adjacent = valid_moves(trail.pos, tiles)
        for new_dir in adjacent
            new_trail = Trail(vcat(trail.path, trail.pos + new_dir), trail.pos + new_dir, trail.score + 1)
            pushfirst!(queue, new_trail)
        end

        # Sort queue to continue with best position
        sort!(queue, by=x -> x.score + distance(x.pos, finish))
    end
    return completed
end

follow_path(Trail([start], start, 0), simulate_corruption(tiles, memblocks, 1024))