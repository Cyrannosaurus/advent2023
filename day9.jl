function ParseInput(input)
    ret = Vector{Vector{Int}}()
    s = split.(input)
    for line in s
        push!(ret, parse.(Int, String.(line)))
    end
    return ret
end

function PredictNextNumber!(input::Vector{Vector{Int}})::Int
    # Subtract
    while any(x->x!=0, input[end])
        row = input[end]
        v = Vector{Int}()
        for i in 1:lastindex(row)-1
            push!(v, row[i+1]-row[i])
        end
        push!(input, v)
    end
    i = lastindex(input)
    while i != 0
        if i == lastindex(input)
            push!(input[i], 0)
        else
            push!(input[i], input[i][end] + input[i+1][end])
        end
        i-=1
    end
    return input[1][end]
end

function SolveDayPart1!(input::Vector{Vector{Int}})::Int
    acc = 0
    for row in input
        acc += PredictNextNumber!([row])
    end
    return acc
end

function SolveDayPart2!(input::Vector{Vector{Int}})::Int
    acc = 0
    for row in input
        acc += PredictNextNumber!([reverse!(row)])
    end
    return acc
end

input = readlines(joinpath(@__DIR__, "input", "9.txt"))
clean_input = ParseInput(input)
println("Solution to part 1: ", SolveDayPart1!(clean_input))
clean_input = ParseInput(input) # I mutated the input and am too lazy to not do that just cause a part 2 exists
println("Solution to part 2: ", SolveDayPart2!(clean_input))