# lines = readlines("C:/tmp/aoc2024/day21/example.txt")
lines = readlines("C:/tmp/aoc2024/day21/input.txt")

#    <vA<AA>>^AvAA<^A>A v<<A>>^AvA^A <vA>^Av<<A>^A>AAvA^A v<<A>A>^AAAvA<^A>A
#    <vA<AA>>^AvAA<^A>A <v<A>>^AvA^A <vA>^A<v<A>^A>AAvA^A <v<A>A>^AAAvA<^A>A
# R4 <vA<AA>>^AvAA<^A>A <v<A>>^AvA^A <vA>^A<v<A>^A>AAvA^A <v<A>A>^AAAvA<^A>A
# R3   v <<   A >>  ^ A    <   A > A   v  A   <  ^ AA > A    < v  AAA >  ^ A
# R2          <       A        ^   A      >        ^^   A         vvv      A
# R1                  0            2                    9                  A

pos_numpad = Dict(
    '7' => CartesianIndex(1, 1),
    '8' => CartesianIndex(1, 2),
    '9' => CartesianIndex(1, 3),
    '4' => CartesianIndex(2, 1),
    '5' => CartesianIndex(2, 2),
    '6' => CartesianIndex(2, 3),
    '1' => CartesianIndex(3, 1),
    '2' => CartesianIndex(3, 2),
    '3' => CartesianIndex(3, 3),
    '0' => CartesianIndex(4, 2),
    'A' => CartesianIndex(4, 3),
)

pos_dirpad = Dict(
    '^' => CartesianIndex(1, 2),
    'A' => CartesianIndex(1, 3),
    '<' => CartesianIndex(2, 1),
    'v' => CartesianIndex(2, 2),
    '>' => CartesianIndex(2, 3),
)

struct Movements
    moves::String
    pos::CartesianIndex{2}
end

struct Sequence
    seq::Vector{String}
    remaining::Int
end

priolist = ["v>A", "v>>A", "v>>>A", "vv>A", "vv>>A", "vv>>>A", "vvv>A", "vvv>>A", "vvv>>>A", "^^>>A"]

function seq_from_pos_num(pos, target_pos)
    moves = Vector{Movements}()
    queue = [Movements("", pos)]
    max_moves = 6
    while !isempty(queue)
        cur = popfirst!(queue)

        if cur.pos == target_pos
            max_moves = length(cur.moves)
            new_move = Movements(cur.moves * "A", cur.pos)
            push!(moves, new_move)
        end

        diff = target_pos - cur.pos
        if diff[2] != 0
            if diff[2] > 0
                new_str = repeat('>', abs(diff[2]))
                new_pos = cur.pos + abs(diff[2]) * CartesianIndex(0, 1)
            else
                new_str = repeat('<', abs(diff[2]))
                new_pos = cur.pos + abs(diff[2]) * CartesianIndex(0, -1)
            end
            push!(queue, Movements(prod([cur.moves, new_str]), new_pos))
        end
        if diff[1] != 0
            if diff[1] > 0
                new_str = repeat('v', abs(diff[1]))
                new_pos = cur.pos + abs(diff[1]) * CartesianIndex(1, 0)
            else
                new_str = repeat('^', abs(diff[1]))
                new_pos = cur.pos + abs(diff[1]) * CartesianIndex(-1, 0)
            end
            push!(queue, Movements(prod([cur.moves, new_str]), new_pos))
        end

        # Filter queue for valid positions and maximum lenght
        filter!(x -> x.pos ∈ values(pos_numpad), queue)
        filter!(x -> length(x.moves) ≤ max_moves, queue)
    end
    result = map(x -> prod(x.moves), moves)
    if length(result) > 1
        if any(map(x -> x ∈ priolist, result))
            filter!(x -> x ∈ priolist, result)
        else
            filter!(x -> startswith(x, "<") || startswith(x, ">"), result)
        end
    end
    return result[1]
end


function seq_from_pos_dir(pos, target_pos)
    moves = Vector{Movements}()
    queue = [Movements("", pos)]
    max_moves = 6
    while !isempty(queue)
        cur = popfirst!(queue)
        
        if cur.pos == target_pos
            max_moves = length(cur.moves)
            new_move = Movements(cur.moves * "A", cur.pos)
            push!(moves, new_move)
        end
        
        diff = target_pos - cur.pos
        if diff[2] != 0
            if diff[2] > 0
                new_str = repeat('>', abs(diff[2]))
                new_pos = cur.pos + abs(diff[2]) * CartesianIndex(0, 1)
            else
                new_str = repeat('<', abs(diff[2]))
                new_pos = cur.pos + abs(diff[2]) * CartesianIndex(0, -1)
            end
            push!(queue, Movements(prod([cur.moves, new_str]), new_pos))
        end
        if diff[1] != 0
            if diff[1] > 0
                new_str = repeat('v', abs(diff[1]))
                new_pos = cur.pos + abs(diff[1]) * CartesianIndex(1, 0)
            else
                new_str = repeat('^', abs(diff[1]))
                new_pos = cur.pos + abs(diff[1]) * CartesianIndex(-1, 0)
            end
            push!(queue, Movements(prod([cur.moves, new_str]), new_pos))
        end
        
        # Filter queue for valid positions and maximum lenght
        filter!(x -> x.pos ∈ values(pos_dirpad), queue)
        filter!(x -> length(x.moves) ≤ max_moves, queue)
    end
    result = map(x -> prod(x.moves), moves)
    if length(result) > 1
        display(result)
        filter!(x -> x ∈ ["<^A", "^>A", "<vA", "v>A"], result)
    end
    return result[1]
end

cache_dir_seq = Dict{String,Vector{String}}()

function get_full_sequences(seqseq)
    if all(map(x -> length(x) == 1, seqseq))
        return [prod(reduce(vcat, seqseq))]
    else
        return map(x -> prod(x), reduce(vcat, Iterators.product(seqseq...)))
    end
end


subseq_cache = Dict{Tuple{Vector{String},Int},Int}()
movement_cache = Dict{String,Vector{String}}()

function get_dir_sequence(seq)
    # Return cached results
    if (seq.seq, seq.remaining) ∈ keys(subseq_cache)
        return get(subseq_cache, (seq.seq, seq.remaining), 0)
    end

    # Return length of sequence if we are at the last keypad
    if seq.remaining == 0
        return length(seq.seq)
    end

    # Evaluate all upper sequences required to generate the sequence
    upper_seq = Vector{String}()
    for subseq in seq.seq
        if subseq ∈ keys(movement_cache)
            append!(upper_seq, movement_cache[subseq])
        else
            partial_seq = Vector{String}()
            instr = [i for i in subseq]
            pos = pos_dirpad['A']
            while !isempty(instr)
                next = popfirst!(instr)
                target_pos = pos_dirpad[next]
                sequence = seq_from_pos_dir(pos, target_pos)
                push!(partial_seq, sequence)
                pos = target_pos
            end
            movement_cache[subseq] = partial_seq
            append!(upper_seq, partial_seq)
        end
    end

    # Recursively check the subsequences and cache intermediary results
    res = 0
    for subseq in upper_seq
        res_seq = Sequence([subseq], seq.remaining - 1)
        subresult = get_dir_sequence(res_seq)
        subseq_cache[(res_seq.seq, res_seq.remaining)] = subresult
        res += subresult
    end
    return res
end

function get_num_sequence(seq)
    upper_seq = Vector{String}()
    for subseq in seq.seq
        instr = [i for i in subseq]
        pos = pos_numpad['A']
        while !isempty(instr)
            next = popfirst!(instr)
            target_pos = pos_numpad[next]
            sequence = seq_from_pos_num(pos, target_pos)
            push!(upper_seq, sequence)
            pos = target_pos
        end
    end

    new_seq = Sequence(upper_seq, seq.remaining)
    return get_dir_sequence(new_seq)
end

function get_score(seq)
    val = parse(Int, rstrip(seq, 'A'))
    len = get_num_sequence(Sequence([seq], 26))
    return val * len
end

# seq = Sequence(["029A"], 3)
# seq = get_num_sequence(seq)

sum(map(x -> get_score(x), lines))
# 109758

# display(get_dir_sequence(Sequence(["<^A"], 25))) # 12661547417 # 11317884431
# display(get_dir_sequence(Sequence(["^<A"], 25))) # 14084535423 # 12630544843

# display(get_dir_sequence(Sequence([">^A"], 25))) # 11513885507 # 10218188221
# display(get_dir_sequence(Sequence(["^>A"], 25))) # 10778856849 # 9686334009

# display(get_dir_sequence(Sequence(["<vA"], 25))) # 12661547417 # 11104086645
# display(get_dir_sequence(Sequence(["^<A"], 25))) # 14084535423 # 12630544843

# display(get_dir_sequence(Sequence([">vA"], 25))) # 12478390269 # 10874983363
# display(get_dir_sequence(Sequence(["v>A"], 25))) # 10299489409 # 9156556999

# 153242207901942 - too high
# 152655277323312 - too high
# 134341709499296
# 61218766101360 - too low

# Correct solution for inpuit
# 5-element Vector{Int64}:
#  22330
#   5610
#  10296
#  19448
#  52074

# Correct solution for example
# 5-element Vector{Int64}:
#   1972
#  58800
#  12172
#  29184
#  24256