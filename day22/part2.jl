# lines = readlines("C:/tmp/aoc2024/day22/example.txt")
lines = readlines("C:/tmp/aoc2024/day22/input.txt")

function get_next(secret_number)
    # Step 1 - multipy by 64 and prune
    a = secret_number * 64
    secret_number = xor(secret_number, a)
    secret_number %= 16777216
    # Step 2 - divide by 64 and mix
    b = floor(Int, secret_number / 32)
    secret_number = xor(secret_number, b)
    secret_number %= 16777216
    # Step 3 - multiply with 2048 and prune
    c = secret_number * 2048
    secret_number = xor(secret_number, c)
    secret_number %= 16777216
end

function get_nth_secret_number(secret_number, n)
    prices = Vector{Int}()
    push!(prices, secret_number % 10)
    for i in 1:n
        secret_number = get_next(secret_number)
        push!(prices, secret_number % 10)
    end
    return prices
end

function get_seq_dict(prices)
    changes = prices[2:end] - prices[1:end-1]
    seq_dict = Dict{Vector{Int},Int}()
    for i in 1:length(changes)-3
        if changes[i:i+3] ∉ keys(seq_dict)
            seq_dict[changes[i:i+3]] = prices[i+4]
        end
    end
    return seq_dict
end


alldicts = map(x -> get_seq_dict(get_nth_secret_number(x, 2000)), parse.(Int, lines))
unique_seq = unique(reduce(vcat, map(x -> [i for i in keys(x)], alldicts)))
score = map(y -> sum(map(x -> get(x, y, 0), alldicts)), unique_seq)
max_score = reduce(max, score)
max_idx = findall(x -> x == max_score, score)
display(unique_seq[max_idx])
display(max_score)
