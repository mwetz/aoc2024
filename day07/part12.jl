# lines = readlines("C:/tmp/factorio/julia/day07/example.txt")
lines = readlines("C:/tmp/factorio/julia/day07/input.txt")

lines = [split(l, ": ") for l in lines]
lines = [[l[1], split(l[2], " ")] for l in lines]
calibration = Dict((parse(Int, l[1]), parse.(Int, l[2])) for l in lines)

function is_valid_equ(target, state, terms)
    # println("$(target) $(state) $(terms)")
    if length(terms) == 0
        return target == state
    else
        result_add = is_valid_equ(target, state + terms[1], terms[2:end])
        result_mult = is_valid_equ(target, state * terms[1], terms[2:end])
        return any([result_add, result_mult])
    end
end

function get_valid_equations(calibration)
    equs = 0
    for (target, terms) in calibration
        if is_valid_equ(target, terms[1], terms[2:end])
            equs += target
        end
    end
    return equs
end

println(get_valid_equations(calibration))


function concat_int(a, b)
    return parse(Int, string(a) * string(b))
end

function is_valid_equ_2(target, state, terms)
    # println("$(target) $(state) $(terms)")
    if length(terms) == 0
        return target == state
    else
        if state > target
            return false
        end
        result_add = is_valid_equ_2(target, state + terms[1], terms[2:end])
        result_mult = is_valid_equ_2(target, state * terms[1], terms[2:end])
        result_concat = is_valid_equ_2(target, concat_int(state, terms[1]), terms[2:end])
        return any([result_add, result_mult, result_concat])
    end
end

function get_valid_equations_2(calibration)
    equs = 0
    for (target, terms) in calibration
        if is_valid_equ_2(target, terms[1], terms[2:end])
            equs += target 
        end
    end
    return equs
end

println(get_valid_equations_2(calibration))