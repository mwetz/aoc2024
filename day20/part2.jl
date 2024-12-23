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

directions_self = [
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(0, 0)
]

function distance(a, b)
    return sum(abs.((b - a).I))
end

# function get_valid_cheat_pos(pos, tiles, duration)
#     init = [pos]
#     allpos = init
#     for i in 1:duration-1
#         allpos = reduce(vcat, map(x -> directions_self .+ x, allpos))
#         unique!(filter!(x -> is_in_bounds(x) && tiles[x] == '#', allpos))
#     end
#     allpos = reduce(vcat, map(x -> directions_self .+ x, allpos))
#     setdiff!(unique!(filter!(x -> is_in_bounds(x) && tiles[x] != '#', allpos)), init)
#     return allpos
# end

function get_valid_cheat_pos(pos, tiles, duration)
    filter(x -> 1 ≤ sum(abs.((x - pos).I)) ≤ duration, findall(x -> x != '#', tiles))
end

function get_all_cheat_paths(tiles, start, finish, savings=0)
    cfs = fill_cost_from_x(tiles, start)
    ctf = fill_cost_from_x(tiles, finish)
    cheat_paths = Dict{Tuple{CartesianIndex{2},CartesianIndex{2}},Int}()
    for cheat_start in keys(cfs)
        cheat_ends = get_valid_cheat_pos(cheat_start, tiles, 20)
        for cheat_end in cheat_ends
            if (cheat_start, cheat_end) ∉ keys(cheat_paths)
                dist = sum(abs.((cheat_start - cheat_end).I))
                cheat_paths[(cheat_start, cheat_end)] = cfs[cheat_start] + ctf[cheat_end] + dist
            end
        end
    end
    length(filter!(((k, v),) -> v ≤ cfs[start] + ctf[start] - savings, cheat_paths))
    return cheat_paths
end

function fill_cost_from_x(tiles, finish)
    cte = Dict{CartesianIndex{2},Int}()
    cte[finish] = 0
    allpos = [finish]
    i = 0
    while !isempty(allpos)
        i += 1
        allpos = reduce(vcat, map(x -> directions_self .+ x, allpos))
        unique!(filter!(x -> x ∉ keys(cte) && tiles[x] != '#', allpos))
        merge!(cte, Dict(j => i for j in allpos))
    end
    return cte
end

cheat_paths = get_all_cheat_paths(tiles, start, finish, 100)

#  544900 answer too low
# 1008040
# 1257781 answer too high