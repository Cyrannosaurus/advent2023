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

# Get to the end of the maze
follow(map::Map)::Int = begin
    pos = "AAA"
    steps = 0
    while pos != "ZZZ"
        n = neighbors(map, pos)
        action = next_action(map)
        pos = n[Integer(action)+1]
        steps += 1
    end
    return steps
end

# Parse input
input = read(joinpath(@__DIR__, "input", "8.txt"), String)
map = parse(Map, input)

steps = follow(map)
println("Took $steps steps to reach the goal")