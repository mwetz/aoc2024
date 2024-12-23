# lines = readlines("C:/tmp/factorio/julia/day06/example.txt")
lines = readlines("C:/tmp/factorio/julia/day06/input.txt")

tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines]))

# Get initial position and direction
position = findall(x -> x == '^', tiles)[1]
direction = CartesianIndex(-1, 0)
initial_pos = (position, direction)

function is_out_of_bounds(position, tile_size)
    return position[1] < 1 || position[1] > tile_size[1] || position[2] < 1 || position[2] > tile_size[2]
end

# Get next direction
next_direction = Dict(
    CartesianIndex(-1, 0) => CartesianIndex(0, 1),
    CartesianIndex(0, 1) => CartesianIndex(1, 0),
    CartesianIndex(1, 0) => CartesianIndex(0, -1),
    CartesianIndex(0, -1) => CartesianIndex(-1, 0))

# Get next position and direction
function get_next_position(tiles, position, direction)
    next_pos = (position + direction)
    # Check if new position is out of bounds
    if ~is_out_of_bounds(next_pos, size(tiles))
        # Either walk in direction or turn
        if tiles[next_pos] ∉ ['#', 'O']
            return next_pos, direction
        else
            return position, next_direction[direction]
        end
    else
        return CartesianIndex(0, 0), CartesianIndex(0, 0)
    end
end

# ### Part 1 ###
# Visited position - direction combinations
function find_guard_positions(tiles, initial_pos)
    position, direction = initial_pos
    # visited = Vector{Tuple{CartesianIndex{2},CartesianIndex{2}}}()
    visited = []
    while position != CartesianIndex(0, 0)
        push!(visited, (position, direction))
        position, direction = get_next_position(tiles, position, direction)
    end
    return visited
end

# Get total number of positions
visited = find_guard_positions(tiles, initial_pos)
println(length(Set([v[1] for v in visited])))


# ### Part 2 ###
function find_box_positions(tiles, initial_pos, visited)
    # boxes = Vector{CartesianIndex{2}}()
    boxes = []
    for visit in visited[1:end-1]
        # If next position is a valid box place create new tiles set with box
        box_position = visit[1] + visit[2]
        if tiles[box_position] == '.'
            tiles_box = copy(tiles)
            tiles_box[box_position] = 'O'
            # Run until path terminates or loops with inital position
            position, direction = initial_pos
            # visited_new = Vector{Tuple{CartesianIndex{2},CartesianIndex{2}}}()
            visited_new = []
            while position != CartesianIndex(0, 0) && (position, direction) ∉ visited_new
                push!(visited_new, (position, direction))
                position, direction = get_next_position(tiles_box, position, direction)
            end
            # If path did not terminate add box position to list
            if position != CartesianIndex(0, 0)
                # display(prod(tiles_box,dims=2))
                push!(boxes, box_position)
            end
        end
    end
    boxes
end
# Get total number of box positions
boxes = find_box_positions(tiles, initial_pos, visited)
println(length(Set(boxes)))