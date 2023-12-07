lines = readlines(joinpath(@__DIR__, "input", "5_sample.txt"))
seeds = split(lines[1], ':')[2]
divisions = map(line -> line == "", lines)
# Get unit ranges between divisions to represent the lines where the map data lives
function GetRanges()

end

function CreateMaps()

end
