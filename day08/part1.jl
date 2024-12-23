# lines = readlines("C:/tmp/factorio/julia/day08/example.txt")
lines = readlines("C:/tmp/factorio/julia/day08/input.txt")

tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))

function is_in_bounds(position, tile_size)
    return position[1] ≥ 1 && position[1] ≤ tile_size[1] && position[2] ≥ 1 && position[2] ≤ tile_size[2]
end

function get_antennas(tiles, frequency)
    return findall(x -> x == frequency, tiles)
end

function get_antinodes(tiles, antennas)
    nodes = antennas .+ -2 * (antennas .- permutedims(antennas))
    offdiag = nodes[Diagonal(ones(length(antennas))).!=1]
    antinodes = filter(x -> is_in_bounds(x, size(tiles)), offdiag)
    display(antinodes)
    return antinodes
end

function find_antinodes(tiles)
    antinodes = Vector{CartesianIndex{2}}()

    frequencies = setdiff(unique(tiles), '.')
    for f in frequencies
        antennas = get_antennas(tiles, f)
        append!(antinodes, get_antinodes(tiles, antennas))
    end
    return antinodes
end

println(length(Set(find_antinodes(tiles))))

# 16898 too high