# lines = readlines("C:/tmp/aoc2024/day15/example.txt")
lines = readlines("C:/tmp/aoc2024/day15/input.txt")

splitat = findfirst(x -> x == "", lines)
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines[1:splitat-1]]))
instructions = prod(lines[splitat+1:end])

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

function get_pushlength(tilevec)
    first_space = findfirst(x -> x == '.', tilevec)
    first_wall = findfirst(x -> x == '#', tilevec)
    if first_space !== nothing && first_space < first_wall
        return first_space
    end
end

function update_tiles(tiles, move)
    tiles_new = copy(tiles)
    robot = findall(x -> x == '@', tiles)[1]
    if move == '^'
        empty = get_pushlength(reverse(tiles[1:robot[1]-1, robot[2]]))
        if empty !== nothing
            tiles_new[robot[1]-empty:robot[1]-1, robot[2]] = tiles_new[robot[1]-empty+1:robot[1], robot[2]]
            tiles_new[robot] = '.'
        end
    elseif move == '>'
        empty = get_pushlength(tiles[robot[1], robot[2]+1:end])
        if empty !== nothing
            tiles_new[robot[1], robot[2]+1:robot[2]+empty] = tiles_new[robot[1], robot[2]:robot[2]+empty-1]
            tiles_new[robot] = '.'
        end
    elseif move == 'v'
        empty = get_pushlength(tiles[robot[1]+1:end, robot[2]])
        if empty !== nothing
            tiles_new[robot[1]+1:robot[1]+empty, robot[2]] = tiles_new[robot[1]:robot[1]+empty-1, robot[2]]
            tiles_new[robot] = '.'
        end
    elseif move == '<'
        empty = get_pushlength(reverse(tiles[robot[1], 1:robot[2]-1]))
        if empty !== nothing
            tiles_new[robot[1], robot[2]-empty:robot[2]-1] = tiles_new[robot[1], robot[2]-empty+1:robot[2]]
            tiles_new[robot] = '.'
        end
    end
    return tiles_new
end

display(tiles)
for c in instructions
    global tiles = update_tiles(tiles, c)
end
tiles

sum(map(x -> (x[1] - 1) * 100 + (x[2] - 1), findall(x -> x == 'O', tiles)))