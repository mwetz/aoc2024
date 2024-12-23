using Images
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
    if length(filter(x -> x[2] < 10, pos_new)) < 30
        mat = Array{Float64}(undef, space[1], space[2])
        mat[:, :] .= 1
        for pos in pos_new
            mat[pos+CartesianIndex(1, 1)] = 0
        end
        # save("imgs/" * lpad(iteration, 6, "0") * ".png", colorview(Gray, mat))
        save("imgs/" * string(iteration) * ".png", colorview(Gray, mat))
    end
end

[compute_safety(robots, i, space) for i in 1:20_000]