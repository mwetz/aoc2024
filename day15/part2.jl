# lines = readlines("C:/tmp/aoc2024/day15/example.txt")
lines = readlines("C:/tmp/aoc2024/day15/input.txt")

splitat = findfirst(x -> x == "", lines)
tiles = permutedims(reduce(hcat, [[i for i in line] for line in lines[1:splitat-1]]))
instructions = prod(lines[splitat+1:end])

struct Entity
    pos::CartesianIndex{2}
    type::Char
end

dir_map = Dict(
    '^' => CartesianIndex(-1, 0),
    '>' => CartesianIndex(0, 1),
    'v' => CartesianIndex(1, 0),
    '<' => CartesianIndex(0, -1),
)

tile_map = Dict(
    '#' => ['#' '#'],
    'O' => ['[' ']'],
    '.' => ['.' '.'],
    '@' => ['@' '.'],
)

tiles_wide = reduce(vcat, [reduce(hcat, map(x -> tile_map[x], i)) for i in eachrow(tiles)])
instructions_dir = map(x -> dir_map[x], i for i in instructions)

entities = Vector{Entity}()
append!(entities, map(x -> Entity(x, '#'), findall(x -> x == '#', tiles_wide)))
append!(entities, map(x -> Entity(x, '['), findall(x -> x == '[', tiles_wide)))
append!(entities, map(x -> Entity(x, ']'), findall(x -> x == ']', tiles_wide)))
append!(entities, map(x -> Entity(x, '@'), findall(x -> x == '@', tiles_wide)))
entities

function update_state(entities, instruction)
    # Store list of components that get moved together
    components = filter(x -> x.type == '@', entities)

    # Create list of components that still need to be checked
    check_components = components
    while length(check_components) > 0
        # Get next position of components to be checked
        next_components = filter(x -> x.pos ∈ map(x -> x.pos + instruction, check_components), entities)

        # If next positions contain a wall, do nothing and return current entity state
        if length(filter(x -> x.type == '#', next_components)) > 0
            return entities
        end

        # Otherwise go through next components that need to be checked
        check_components = Vector{Entity}()
        for c in next_components
            push!(components, c)
            push!(check_components, c)
            # Add next component to the list of all movable components
            if instruction ∈ [CartesianIndex(1, 0), CartesianIndex(-1, 0)]
                if c.type == '['
                    adjecent = filter(x -> x.pos == c.pos + CartesianIndex(0, 1), entities)[1]
                elseif c.type == ']'
                    adjecent = filter(x -> x.pos == c.pos + CartesianIndex(0, -1), entities)[1]
                end
                push!(components, adjecent)
                push!(check_components, adjecent)
            end
        end
    end
    unique!(components)
    # Move all components by the direction and return all entities
    entities_fixed = filter(x -> x ∉ components, entities)
    # display(entities_fixed)
    entities_moved = map(x->Entity(x.pos + instruction, x.type), components)
    # display(entities_moved)
    return vcat(entities_fixed, entities_moved)
end


function display_state(entities)
    tiles = copy(tiles_wide)
    tiles .= '.'
    for e in entities
        tiles[e.pos] = e.type
    end
    display(tiles)
end

for (i, dir) in enumerate(instructions_dir)
    # display(i)
    # display(dir)
    # display_state(entities)
    global entities = update_state(entities, dir)
    # display_state(entities)
end

sum(map(x-> (x.pos[1]-1) * 100 + x.pos[2]-1, filter(x->x.type=='[', entities)))
