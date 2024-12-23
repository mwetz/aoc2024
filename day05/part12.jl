# lines = readlines("C:/tmp/factorio/julia/day05/example.txt")
lines = readlines("C:/tmp/factorio/julia/day05/input.txt")

splitidx = findall(x->x=="", lines)[1]

ordering = lines[1:splitidx-1]
ordering = [parse.(Int, split(o, "|")) for o in ordering]

pages = lines[splitidx+1:end]
pages = [parse.(Int, split(p, ",")) for p in pages]


function is_correct_ordering(ordering, pages)
    findall(x->x==ordering[1], pages)[1] < findall(x->x==ordering[2], pages)[1]
end

function reorder_pages(ordering, pages)
    if findall(x->x==ordering[1], pages)[1] < findall(x->x==ordering[2], pages)[1]
        return pages
    else
        new_pages = pages
        new_pages[new_pages .== ordering[1]] .= -1
        new_pages[new_pages .== ordering[2]] .= ordering[1]
        new_pages[new_pages .== -1] .= ordering[2]
        return new_pages
    end
end

pagesum = 0
for p in pages
    order_active = [o for o in ordering if all(o .∈ [p])]
    # println(order_active)
    check = all([is_correct_ordering(o, p) for o in order_active])
    # println(check)
    if check
        global pagesum += p[convert(Int, ceil(length(p)/2))]
    end
end
println(pagesum)


pagesum = 0
for p in pages
    order_active = [o for o in ordering if all(o .∈ [p])]
    # println(order_active)
    check = all([is_correct_ordering(o, p) for o in order_active])
    # println(check)
    if ~check
        pn = p
        while ~all([is_correct_ordering(o, pn) for o in order_active])
            for o in order_active
                pn = reorder_pages(o,pn)
            end
        end
        global pagesum += pn[convert(Int, ceil(length(pn)/2))]
    end
end
println(pagesum)