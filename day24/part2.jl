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

swaps = Dict(
	"hdt" => "z05",
	"z05" => "hdt",
	"gbf" => "z09",
	"z09" => "gbf",
	"mht" => "jgt",
	"jgt" => "mht",
	"nbf" => "z30",
	"z30" => "nbf"
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
	key = get(swaps, key, key)
	(a, op, b) = split(calc, " ")
	if a > b
		a, b = b, a
	end
	push!(instrs, Calc(key, a, b, op))
end

function get_inputs(znum)
	wire = "z" * lpad(znum, 2, "0")
	full = Vector{Calc}()
	full = filter(x -> x.key == wire, instrs)
	remaining = ["dummy"]
	while !isempty(remaining)
		inputs = reduce(vcat, map(x -> vcat(x.a, x.b), full))
		outputs = reduce(vcat, map(x -> x.key, full))
		remaining = setdiff(inputs, outputs)
		filter!(x -> !startswith(x, "x") && !startswith(x, "y"), remaining)
		append!(full, filter(x -> x.key ∈ remaining, instrs))
	end
	return sort(sort(full, by = x -> x.a), by = x -> x.op)
end

function get_expected(n)
	full = Vector{Calc}()
	# calculate true for previous levels
	if n > 0
		push!(full, Calc("z" * lpad(n, 2, "0"), "or" * lpad(n - 1, 2, "0"), "xor" * lpad(n, 2, "0"), "XOR"))
		push!(full, Calc("xor" * lpad(n, 2, "0"), "x" * lpad(n, 2, "0"), "y" * lpad(n, 2, "0"), "XOR"))
		push!(full, Calc("and" * lpad(0, 2, "0"), "x" * lpad(0, 2, "0"), "y" * lpad(0, 2, "0"), "AND"))
	else
		push!(full, Calc("z" * lpad(n, 2, "0"), "x" * lpad(n, 2, "0"), "y" * lpad(n, 2, "0"), "XOR"))
	end
	# xor, and for each previous levels
	if n > 1
		for i in 1:n-1
			push!(full, Calc("xor" * lpad(i, 2, "0"), "x" * lpad(i, 2, "0"), "y" * lpad(i, 2, "0"), "XOR"))
			push!(full, Calc("and" * lpad(i, 2, "0"), "x" * lpad(i, 2, "0"), "y" * lpad(i, 2, "0"), "AND"))
		end
	end
	if n > 2
		push!(full, Calc("pre" * lpad(1, 2, "0"), "and" * lpad(0, 2, "0"), "xor" * lpad(1, 2, "0"), "AND"))
		for i in 2:n-2
			push!(full, Calc("or" * lpad(i, 2, "0"), "and" * lpad(i, 2, "0"), "pre" * lpad(i, 2, "0"), "OR"))
			push!(full, Calc("pre" * lpad(i, 2, "0"), "or" * lpad(i - 1, 2, "0"), "xor" * lpad(i, 2, "0"), "AND"))
		end
	end

	return sort(sort(full, by = x -> x.a), by = x -> x.op)
end

function rename_inputs(inputs, renames)
	inputs_rename = Vector{Calc}()
	for inp in inputs
		key = get(renames, inp.key, inp.key)
		a = get(renames, inp.a, inp.a)
		b = get(renames, inp.b, inp.b)
		if a > b
			a, b = b, a
		end
		push!(inputs_rename, Calc(key, a, b, inp.op))
	end
	return inputs_rename
end

function diff_calc(n)
	inputs = get_inputs(n)
	expected = get_expected(n)
	renames = Dict{String, String}()

	for inp in inputs
		if startswith(inp.a, "x") && startswith(inp.b, "y") && !startswith(inp.key, "z")
			renames[inp.key] = lowercase(inp.op) * strip(inp.a, 'x')
		end
	end
	inputs_rename = rename_inputs(inputs, renames)

	inputs_rename_pre = []
	while inputs_rename_pre != inputs_rename
		inputs_rename_pre = inputs_rename
		for inp in inputs_rename
			if startswith(inp.op, "AND") && startswith(inp.a, "and") && startswith(inp.b, "xor") && !startswith(inp.key, "z")
				renames[inp.key] = "pre" * strip(inp.b, ['x', 'o', 'r'])
				inputs_rename = rename_inputs(inputs_rename, renames)
			end
			if startswith(inp.op, "AND") && startswith(inp.a, "or") && startswith(inp.b, "xor") && !startswith(inp.key, "z")
				renames[inp.key] = "pre" * strip(inp.b, ['x', 'o', 'r'])
				inputs_rename = rename_inputs(inputs_rename, renames)
			end
			if startswith(inp.op, "OR") && startswith(inp.a, "and") && startswith(inp.b, "pre") && !startswith(inp.key, "z")
				renames[inp.key] = "or" * strip(inp.b, ['p', 'r', 'e'])
				inputs_rename = rename_inputs(inputs_rename, renames)
			end
		end
		inputs_rename = rename_inputs(inputs_rename, renames)
	end
	diff = setdiff(expected, inputs_rename)
	if !isempty(diff)
		display(expected)
		display(inputs_rename)
		display(setdiff(expected, inputs_rename))
		display(setdiff(inputs_rename, expected))
	end
	return renames
end

# renames_correct = diff_calc(4);
# renames_wrong = diff_calc(5);
# z05 needs to be output of operation or04 xor xor05
# display(filter(((x, y),) -> y == "or04", renames_wrong)) # tsw
# display(filter(((x, y),) -> y == "xor05", renames_wrong)) # wwm
# wwm xor tws -> hdt therefore swap hdt <-> z05

# renames_correct = diff_calc(8);
# renames_wrong = diff_calc(9);
# z09 is output of x09 and y09, which should be and09
# real z09 requires XOR operator for xor09 (wqr) and or08 (vkd) based on and08 (hrv) OR pre08 (wvc)
# swap z09 <-> gbf

# renames_correct = diff_calc(14);
# renames_wrong = diff_calc(15);
# z15 should depend on or14 XOR xor15 (jgt) instead of and15 (mht)
# swap mht <-> mht

# renames_correct = diff_calc(29);
# renames_wrong = diff_calc(30);
# z30 should be a XOR operation with the same operands
# swap z30 <-> nbf

renames_correct = diff_calc(44);
join(sort(collect(keys(swaps))), ",")