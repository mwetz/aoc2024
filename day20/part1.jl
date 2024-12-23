# lines = readlines("C:/tmp/aoc2024/day20/example.txt")
lines = readlines("C:/tmp/aoc2024/day20/input.txt")
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))

start = findfirst(x -> x == 'S', tiles)
finish = findfirst(x -> x == 'E', tiles)

function is_in_bounds(position)
    return position[1] ≥ 1 && position[1] ≤ size(tiles)[1] && position[2] ≥ 1 && position[2] ≤ size(tiles)[2]
end

struct Trail
    path::Vector{CartesianIndex{2}}
    pos::CartesianIndex{2}
    cheat::Vector{CartesianIndex{2}}
    score::Int
end

directions = [
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1)
]

function valid_moves(trail, tiles)
    moves = Vector{CartesianIndex{2}}()
    for dir in directions
        if is_in_bounds(trail.pos + dir) && tiles[trail.pos+dir] != '#'
            push!(moves, dir)
        end
        if isempty(trail.cheat) && tiles[trail.pos+dir] == '#' && is_in_bounds(trail.pos + 2 * dir) && tiles[trail.pos+2*dir] != '#'
            push!(moves, 2 * dir)
        end
    end
    return moves
end

function distance(a, b)
    return sum(abs.((b - a).I))
end

function follow_path(trail_init, tiles, maxscore=Inf, cost_to_end=Dict{CartesianIndex{2},Int}())
    queue = [trail_init]

    best_states = Dict{Tuple{CartesianIndex{2},Vector{CartesianIndex{2}}},Int}()


    completed = Vector{Trail}()
    completed_cheats = Vector{Vector{CartesianIndex{2}}}()

    while !isempty(queue)
        trail = popfirst!(queue)
        # Check if we are the least cost path otherwise, we found a better option already
        best_state = get(best_states, (trail.pos, trail.cheat), maxscore)
        if trail.score < best_state
            best_states[(trail.pos, trail.cheat)] = trail.score
        else
            continue
        end

        cte = get(cost_to_end, trail.pos, 0)
        if !isempty(trail.cheat) && cte > 0
            shortcut = Trail(trail.path, trail.pos, trail.cheat, trail.score + cte)
            push!(completed, shortcut)
            push!(completed_cheats, trail.cheat)
            continue
        end
        
        # Return score if we reach the end
        if trail.pos == finish
            display(trail.score)
            push!(completed, trail)
            push!(completed_cheats, trail.cheat)
            continue
        end

        moves = valid_moves(trail, tiles)
        for m in moves
            if sum(abs.(m.I)) == 2
                new_cheat = [trail.pos, trail.pos + m]
                new_score = trail.score + 2
            else
                new_cheat = trail.cheat
                new_score = trail.score + 1
            end
            new_trail = Trail(vcat(trail.path, trail.pos + m), trail.pos + m, new_cheat, new_score)
            push!(queue, new_trail)
        end

        # Sort queue to continue with best position
        filter!(x -> x.cheat ∉ completed_cheats, queue)
        sort!(queue, by=x -> x.score + distance(x.pos, finish))
    end
    return completed
end

println("fastest")
fastest = follow_path(Trail([start], start, [start, start], 0), tiles)[1]
cte = Dict(pos => fastest.score - i + 1 for (i, pos) in enumerate(fastest.path))
println("cheat_trails")
cheat_trails = follow_path(Trail([start], start, [], 0), tiles, fastest.score - 100, cte)
filter!(x->x.score ≤ fastest.score - 100, cheat_trails)
unique(x -> x.cheat, cheat_trails)
count(x -> !isempty(x.cheat), unique(x -> x.cheat, cheat_trails))

# 13799 answer too high