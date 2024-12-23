lines = readlines("C:/tmp/aoc2024/day21/example.txt")
# lines = readlines("C:/tmp/aoc2024/day21/input.txt")


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

struct Sequence
    moves::Vector{Char}
    pos::CartesianIndex{2}
end

function has_good_sequence(str)
    return !any(occursin.([">^>", "<^<", ">v>", "<v<", "^<<^", "v<<v", "^>>^", "v>>v", "<^^<", ">vv>", "<^^^<", ">vvv>"], str))
end

function seq_from_pos_num(pos, target_pos)
    sequences = Vector{Sequence}()
    queue = [Sequence([], pos)]
    max_moves = 6
    while !isempty(queue)
        cur = popfirst!(queue)

        if cur.pos == target_pos
            max_moves = length(cur.moves)
            push!(cur.moves, 'A')
            push!(sequences, cur)
        end

        # Add new positions
        push!(queue, Sequence(vcat(cur.moves, '>'), cur.pos + CartesianIndex(0, 1)))
        push!(queue, Sequence(vcat(cur.moves, '<'), cur.pos + CartesianIndex(0, -1)))
        push!(queue, Sequence(vcat(cur.moves, 'v'), cur.pos + CartesianIndex(1, 0)))
        push!(queue, Sequence(vcat(cur.moves, '^'), cur.pos + CartesianIndex(-1, 0)))

        # Filter queue for valid positions and maximum lenght
        filter!(x -> x.pos ∈ values(pos_numpad), queue)
        filter!(x -> length(x.moves) ≤ max_moves, queue)
    end

    result = map(x -> prod(x.moves), sequences)
    filter!(x -> has_good_sequence(x), result)
    return result
end

function seq_from_pos_dir(pos, target_pos)
    sequences = Vector{Sequence}()
    queue = [Sequence([], pos)]
    max_moves = 6
    while !isempty(queue)
        cur = popfirst!(queue)

        if cur.pos == target_pos
            max_moves = length(cur.moves)
            push!(cur.moves, 'A')
            push!(sequences, cur)
        end

        # Add new positions
        push!(queue, Sequence(vcat(cur.moves, '>'), cur.pos + CartesianIndex(0, 1)))
        push!(queue, Sequence(vcat(cur.moves, '<'), cur.pos + CartesianIndex(0, -1)))
        push!(queue, Sequence(vcat(cur.moves, 'v'), cur.pos + CartesianIndex(1, 0)))
        push!(queue, Sequence(vcat(cur.moves, '^'), cur.pos + CartesianIndex(-1, 0)))

        # Filter queue for valid positions and maximum lenght
        filter!(x -> x.pos ∈ values(pos_dirpad), queue)
        filter!(x -> length(x.moves) ≤ max_moves, queue)
    end
    result = map(x -> prod(x.moves), sequences)
    filter!(x -> has_good_sequence(x), result)
    return result
end

function get_dir_seq(seq)
    seq = [i for i in seq]
    pos = pos_dirpad['A']
    sequences = Vector{Vector{String}}()
    while !isempty(seq)
        next = popfirst!(seq)
        target_pos = pos_dirpad[next]
        sequence = seq_from_pos_dir(pos, target_pos)
        push!(sequences, sequence)
        pos = target_pos
    end
    full_seq = get_full_sequences(sequences)
    shortest = reduce(min, map(x -> length(x), full_seq))
    filter!(x -> length(x) == shortest, full_seq)
    return full_seq[1:1]
end

function get_num_seq(seq)
    seq = [i for i in seq]
    pos = pos_numpad['A']
    # sequences = Vector{String}()
    len = 0
    while !isempty(seq)
        next = popfirst!(seq)
        target_pos = pos_numpad[next]
        sequences_1 = seq_from_pos_num(pos, target_pos)
        sequences_2 = reduce(vcat, map(x -> get_dir_seq(x), sequences_1))
        sequences_3 = reduce(vcat, map(x -> get_dir_seq(x), sequences_2))
        shortest = reduce(min, map(x -> length(x), sequences_3))
        longest = reduce(max, map(x -> length(x), sequences_3))
        display(shortest)
        display(longest)
        display(sequences_1)
        display(sequences_2)
        display(sequences_3)
        len += shortest
        # push!(sequences, sequences_3[findfirst(x->length(x)==shortest, sequences_3)])
        pos = target_pos
    end
    return len
end

function get_full_sequences(seqseq)
    if all(map(x -> length(x) == 1, seqseq))
        return [prod(reduce(vcat, seqseq))]
    else
        return map(x -> prod(x), reduce(vcat, Iterators.product(seqseq...)))
    end
end

function get_score(seq)
    val = parse(Int, rstrip(seq, 'A'))
    len = get_num_seq(seq)
    return val * len
end

map(x -> get_score(x), lines)

# function get_score(sequence)
#     len = 0
#     for i in sequence
#     end
#     return len
# end

# get_score(lines[1])