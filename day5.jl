# Get unit ranges between divisions to represent the lines where the map data lives
function GetRanges(divisions::Vector{Bool})::Vector{UnitRange}
    data_locations = Vector{UnitRange}()
    start_of_data = 1
    for (i, divider) in enumerate(divisions)
        if divider == 1
            push!(data_locations, start_of_data:i-1)
            start_of_data = i+2
            continue
        end
        if i == lastindex(divisions)
            push!(data_locations, start_of_data:i)
        end
    end
    return data_locations
end

struct MapItem
    output::Int
    input::Int
    length::Int
end

struct Map
    items::Vector{MapItem}
end

Base.getindex(m::Map, index::Int) = begin
    for item in m.items
        if index in item.input:item.input+item.length
            return item.output - item.input + index
        end
    end
    return index
end

# a list of maps represents each 

function CreateMap(data_range::UnitRange, data::Vector{String})::Map
    # Read data at the given ranges
    # Parse into a struct
    Map(ParseLine.(data[data_range]))
end

function ParseLine(line::String)::MapItem
    MapItem(parse.(Int, String.(split(line)))...)
end
# Big boy line look out 😳
# seeds, seed_to_soil, soil_to_fertilizer, fertilizer_to_water, water_to_light, light_to_temp, temp_to_humidity, humidity_to_location = GetRanges(divisions)
lines = readlines(joinpath(@__DIR__, "input", "5.txt"))

seeds = parse.(Int, strip.(String.(split(String.(split(lines[1], ':')[2])))))
divisions = map(line -> line == "", lines)

ranges = GetRanges(divisions)

maps = CreateMap.(ranges[2:end], Ref(lines))

# Part 1
function PartOne(seeds::Vector{Int}, maps::Vector{Map})
    lowest = typemax(Int)
    for seed in seeds
        value = seed
        for map in maps
            value = map[value]
        end
        lowest = min(value, lowest)
    end
    return lowest
end
println(PartOne(seeds, maps))

function PartTwo(seeds::Vector{Int}, maps::Vector{Map})::Int
    lowest = typemax(Int)
    for ind in 1:2:length(seeds)
        values = seeds[ind]:seeds[ind] + seeds[ind+1] - 1
        for value in values
            for map in maps
                value = map[value]
            end
            lowest = min(value, lowest)
        end
    end
    return lowest
end

println(PartTwo(seeds, maps))
