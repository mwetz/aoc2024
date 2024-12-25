# lines = readlines("C:/work/tmp/aoc2024/day24/example.txt")
lines = readlines("C:/work/tmp/aoc2024/day24/input.txt")

sep = findfirst(x -> x == "", lines)

struct Calc
	key::String
	a::String
	b::String
	op::String
end

function and(a, b)
	return a && b
end

function or(a, b)
	return a || b
end

ops_dict = Dict(
	"OR" => or,
	"XOR" => xor,
	"AND" => and,
)

state = Dict{String, Bool}()
for st in lines[1:sep-1]
	(i, j) = split(st, ": ")
	state[i] = Bool(parse(Int, j))
end
state

instrs = Vector{Calc}()
for instr in lines[sep+1:end]
	calc, key = split(instr, " -> ")
	(a, op, b) = split(calc, " ")
	push!(instrs, Calc(key, a, b, op))
end

function update_state(instrs, state)
	while !isempty(instrs)
		instr = popfirst!(instrs)
		if instr.a ∈ keys(state) && instr.b ∈ keys(state)
			state[instr.key] = ops_dict[instr.op](state[instr.a], state[instr.b])
		else
			push!(instrs, instr)
		end
	end
end
update_state(instrs, state)
bitstr = join(map(x -> Int(state[x]), sort(collect(filter(x -> startswith(x, "z"), keys(state))), rev = true)), "")
parse(Int, bitstr; base = 2)
