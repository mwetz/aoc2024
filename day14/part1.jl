# lines = readlines("C:/tmp/aoc2024/day14/example.txt")
# space=CartesianIndex(11, 7)
lines = readlines("C:/tmp/aoc2024/day14/input.txt")
space = CartesianIndex(101, 103)

struct Robot
    pos::CartesianIndex{2}
    veloc::CartesianIndex{2}
end

robots = Vector{Robot}()
for line in lines
    m = match(r"p\=(-?\d+),(-?\d+) v\=(-?\d+),(-?\d+)", line)
    m = parse.(Int, m)
    push!(robots, Robot(CartesianIndex(m[1], m[2]), CartesianIndex(m[3], m[4])))
end
robots

function compute_safety(robots, iteration, space)
    pos_new = map(x -> x.pos + iteration * x.veloc, robots) .+ iteration * space
    pos_new = map(x -> CartesianIndex(x[1] % space[1], x[2] % space[2]), pos_new)
    display(pos_new)
    q1 = length(filter(x -> x[1] < (space[1] - 1) / 2 && x[2] < (space[2] - 1) / 2, pos_new))
    q2 = length(filter(x -> x[1] > (space[1] - 1) / 2 && x[2] < (space[2] - 1) / 2, pos_new))
    q3 = length(filter(x -> x[1] < (space[1] - 1) / 2 && x[2] > (space[2] - 1) / 2, pos_new))
    q4 = length(filter(x -> x[1] > (space[1] - 1) / 2 && x[2] > (space[2] - 1) / 2, pos_new))
    display(q1)
    display(q2)
    display(q3)
    display(q4)
    return q1 * q2 * q3 * q4
end

compute_safety(robots, 100, space)
# [compute_safety(robots, i, space) for i in 1:100]