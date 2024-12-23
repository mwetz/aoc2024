re = r"(don\'t\(\)|do\(\)|mul\((?<d1>\d+)?,(?<d2>\d+)\))"
memstring = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
memstring = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
f = open("C:/tmp/factorio/julia/input.txt", "r")
memstring = read(f, String)

m = eachmatch(re, memstring)

# sum([parse(Int, i[1]) * parse(Int, i[2]) for i in m])

active = true
mults = []
for i in m
    if startswith(i.match, "don't")
        global active = false
    elseif startswith(i.match, "do")
        global active = true
    elseif active && startswith(i.match, "mul")
        num = parse(Int, i["d1"]) * parse(Int, i["d2"])
        push!(mults, num)
    end
end
sum(mults)