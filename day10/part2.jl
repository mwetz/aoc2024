# lines = readlines("C:/tmp/factorio/julia/day10/example.txt")
lines = readlines("C:/tmp/factorio/julia/day10/input.txt")
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))
tiles = parse.(Int, tiles)

directions = [
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
]

function is_in_bounds(position, tile_size)
    return position[1] ≥ 1 && position[1] ≤ tile_size[1] && position[2] ≥ 1 && position[2] ≤ tile_size[2]
end


function find_trails(tiles, path, cur_val)
    # Check if we are on the right tile
    if tiles[path[end]] == cur_val
        # Finish if value 9 is reached
        if cur_val == 9
            return [path]
        end

        # Otherwise generate all possible next steps
        cur_trails = []
        for dir in directions
            if is_in_bounds(path[end] + dir, size(tiles))
                new_path = push!(copy(path), path[end] + dir)
                trails = find_trails(tiles, new_path, cur_val + 1)
                push!(cur_trails, trails)
            end
        end
        result = filter(x -> x !== nothing, reduce(vcat, cur_trails))
        if length(result) > 0
            return result
        else
            return nothing
        end
    else
        return nothing
    end
end

function count_trails(trailheads)
    nb_trails = 0
    for trailhead in trailheads
        path = Vector{CartesianIndex{2}}()
        push!(path, trailhead)
        trails = find_trails(tiles, path, 0)
        nb_trails += length(Set(trails))
    end
    return nb_trails
end

trailheads = findall(x -> x == 0, tiles)
trails = count_trails(trailheads)
trails

