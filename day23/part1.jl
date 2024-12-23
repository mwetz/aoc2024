# lines = readlines("C:/tmp/aoc2024/day23/example.txt")
lines = readlines("C:/tmp/aoc2024/day23/input.txt")

network = split.(lines, '-')
nodes = unique(reduce(vcat, split.(lines, '-')))

struct Network
    path::Vector{String}
    node::String
end

function get_neighbours(node)
    setdiff(unique(reduce(vcat, filter(x -> node in x, network))), [node])
end

function get_subnets(netw)
    if length(netw.path) > 3
        return []
    end

    res = Vector{Network}()
    neighbours = get_neighbours(netw.node)
    for neigh in neighbours
        if length(netw.path) == 3 && netw.path[1] == neigh
            return [netw]
        end

        if neigh ∉ netw.path
            append!(res, get_subnets(Network(vcat(netw.path, neigh), neigh)))
        end
    end
    return res
end

netws = reduce(vcat, map(x -> get_subnets(Network([], x)), filter(x -> startswith(x, 't'), nodes)))
netws_unique = unique(map(x -> sort(x.path), netws))
netws_t = filter(x -> any(startswith.(x, 't')), netws_unique)
length(netws_t)