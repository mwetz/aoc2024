# lines = readlines("C:/work/tmp/aoc2024/day25/example.txt")
lines = readlines("C:/work/tmp/aoc2024/day25/input.txt")

function parse_input(lines)
	line_coll = []
	alllocks = Vector{Vector{Int}}()
	allkeys = Vector{Vector{Int}}()
	for (i, line) in enumerate(lines)
		if i % 8 == 0
			mat = reduce(hcat, [[i for i in line] for line in line_coll])
			nums = reduce(vcat, count(x -> x == '#', mat, dims = 2))
			if mat[1, 1] == '#'
				push!(alllocks, nums)
			else
				push!(allkeys, nums)
			end
			line_coll = []
		else
			push!(line_coll, line)
		end
	end
	return alllocks, allkeys
end
alllocks, allkeys = parse_input(lines)

function check_lock(lock)
	sel_keys = copy(allkeys)
	filter!(x -> all(lock + x .≤ 7), sel_keys)
	return length(sel_keys)
end

sum(check_lock.(alllocks))
