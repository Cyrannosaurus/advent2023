@enum Action::Int8 Left Right

mutable struct Map
    const instructions::Vector{Action} 
    instr_pointer::Int
    const nodes::Dict{String, Tuple{String, String}}
end

Base.parse(::Type{Action}, c::Char)::Action = begin
    return Action(1 & (c == 'R'))
end

Base.parse(::Type{Map}, s::String)::Map = begin
    lines = split(s, '\n')
    instructions = [parse(Action, char) for char in lines[1]]
    nodes = Dict{String, Tuple{String, String}}()
    for line in lines[3:end]
        source, destinations = split(line, " = ")
        push!(nodes, source=>(String(destinations[2:4]), String(destinations[7:9])))
    end
    return Map(instructions, 1, nodes)
end

next_action(map::Map)::Action = begin
    na = map.instructions[map.instr_pointer]
    map.instr_pointer += 1
    if map.instr_pointer > length(map.instructions)
        map.instr_pointer = 1
    end
    return na
end

neighbors(map::Map, pos::String)::Tuple{String, String} = begin
    return map.nodes[pos]
end

""" Returns the starting positions of the map"""
get_starting(map::Map)::Vector{String} = begin
    starting = Vector{String}()
    for node in keys(map.nodes)
        if node[end] == 'A'
            push!(starting, node)
        end
    end
    return starting
end

# Get to the end of the maze
follow(map::Map)::Int = begin
    positions = get_starting(map)
    println("Number of positions to track: ", length(positions))
    steps = 0
    t1 = time()
    steps_for_path = [0 for _ in 1:lastindex(positions)]
    while !all(p->p[end] == 'Z', positions)
        action = next_action(map)
        # Through manual inspection I have found that each path only has one end
        # and reaches it in a static loop.

        Threads.@threads for i in 1:lastindex(positions)
            if steps_for_path[i] == 0
                n = neighbors(map, positions[i])
                positions[i] = n[Integer(action)+1]
            end
        end
        steps += 1
        for i in 1:lastindex(positions)
            if positions[i][end] == 'Z' && steps_for_path[i] == 0
                steps_for_path[i] = steps
            end
        end
    end
    println("Steps to reach goals: ", steps_for_path)
    println("Took $(time() - t1) seconds to solve")
    return lcm(steps_for_path)
end

# Parse input
input = read(joinpath(@__DIR__, "input", "8.txt"), String)
map = parse(Map, input)

steps = follow(map)
println("Took $steps steps to reach the goal")