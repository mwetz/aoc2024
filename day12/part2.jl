# lines = readlines("C:/tmp/factorio/julia/day12/example.txt")
lines = readlines("C:/tmp/factorio/julia/day12/input.txt")
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))

function is_in_bounds(position, tile_size)
    return position[1] ≥ 1 && position[1] ≤ tile_size[1] && position[2] ≥ 1 && position[2] ≤ tile_size[2]
end

directions = [
    CartesianIndex(0, 0),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
]

struct Region
    tiles::Vector{CartesianIndex{2}}
    type::Char
end

function expand_region(pos)
    type = tiles[pos]
    region = [pos]
    new_region = [pos]
    region_pre = length(region)
    region_post = 2
    while region_pre < region_post
        new_region = unique(reduce(vcat, [region .+ dir for dir in directions]))
        filter!(x -> is_in_bounds(x, size(tiles)), new_region)
        filter!(x -> tiles[x] == type, new_region)
        region_pre = length(region)
        region_post = length(new_region)
        region = new_region
    end
    return new_region
end

function get_regions(tiles)
    regions = Vector{Vector{CartesianIndex{2}}}()
    checked_pos = Vector{CartesianIndex{2}}()
    for i in 1:size(tiles)[1]
        for j in 1:size(tiles)[2]
            pos = CartesianIndex(i, j)
            if pos ∉ checked_pos
                region = expand_region(pos)
                append!(checked_pos, region)
                push!(regions, region)
            end
        end
    end
    return regions
end

function count_sides(region)
    sides = 0
    sides += length(group_neighbours(setdiff(region .+ CartesianIndex(1, 0), region)))
    sides += length(group_neighbours(setdiff(region .+ CartesianIndex(-1, 0), region)))
    sides += length(group_neighbours(setdiff(region .+ CartesianIndex(0, 1), region)))
    sides += length(group_neighbours(setdiff(region .+ CartesianIndex(0, -1), region)))
    return sides
end

function group_neighbours(neighbours)
    ngroups = []
    for n in neighbours
        if n ∉ reduce(vcat, ngroups, init=[])
            ngroup = [n]
            ngroup_new = []
            ngroup_pre = length(ngroup)
            ngroup_post = 2
            while ngroup_pre < ngroup_post
                ngroup_new = unique(reduce(vcat, [ngroup .+ dir for dir in directions]))
                filter!(x -> x ∈ neighbours, ngroup_new)
                ngroup_pre = length(ngroup)
                ngroup_post = length(ngroup_new)
                ngroup = ngroup_new
            end
            push!(ngroups, ngroup_new)
        end
    end
    return ngroups
end

regions = get_regions(tiles)
total_cost = 0
for reg in regions
    cost = length(reg) * count_sides(reg)
    global total_cost += cost
end
total_cost

