struct Race
    duration::Int
    record_distance::Int
end

function ParseRaces(file::String)::Vector{Race}
    lines = readlines(joinpath(@__DIR__, "input", file))
    times, distances = split.(lines)
    times = parse.(Int, String.(times[2:end]))
    distances = parse.(Int, String.(distances[2:end]))
    Race.(times, distances)
end
function ParseRacePartTwo(file::String)::Race
    lines = readlines(joinpath(@__DIR__, "input", file))
    times, distances = split.(lines)
    duration = parse(Int, replace(join(times[2:end]), " "=>""))
    distance = parse(Int, replace(join(distances[2:end]), " "=>""))
    Race(duration, distance)
end

function NumberOfWaysToWin(race::Race)::Int
    acc = 0
    for hold_time in 1:race.duration
        # The hold time is equal to our speed
        # So speed * time = (time - hold time) * hold time
        distance = (race.duration - hold_time) * hold_time
        if distance > race.record_distance
            acc += 1
        end
    end
    return acc
end

# part 1
races = ParseRaces("6.txt")
ways_to_win = NumberOfWaysToWin.(races)
println(reduce(*, ways_to_win))

# part 2
big_race = ParseRacePartTwo("6.txt")
t1 = time()
println(NumberOfWaysToWin(big_race))
println("Part Two took ", time() - t1, " seconds to complete")