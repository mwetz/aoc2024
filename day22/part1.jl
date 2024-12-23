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
    for i in 1:n
        secret_number = get_next(secret_number)
    end
    return secret_number
end

sum(map(x -> get_nth_secret_number(x, 2000), parse.(Int, lines)))

