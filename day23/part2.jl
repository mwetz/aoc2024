# lines = readlines("C:/work/tmp/aoc2024/day23/example.txt")
lines = readlines("C:/work/tmp/aoc2024/day23/input.txt")

network = split.(lines, '-')
nodes = unique(reduce(vcat, split.(lines, '-')))

struct Network
	path::Vector{String}
	node::String
end

function get_neighbours(network, node)
	setdiff(unique(reduce(vcat, filter(x -> node in x, network), init = [])), [node])
end

function get_intersect(network, edge)
	length(intersect(get_neighbours(network, edge[1]), get_neighbours(network, edge[2])))
end

network_red = copy(network)
sel = map(x -> x > 10, map(x -> get_intersect(network_red, x), network_red))
network_red = network_red[sel]
nodes_red = unique(reduce(vcat, network_red))
display(nodes_red)

sel = map(x -> length(get_neighbours(network_red, x)) > 10, nodes_red)
nodes_red = nodes_red[sel]
display(join(sort(nodes_red), ','))
setdiff(map(x -> sort(get_neighbours(network_red, x)), nodes_red))
# sort(get_intersect.(network_red))

