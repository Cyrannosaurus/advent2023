# Read into a 2d matrix of characters
# Do a 7column*3row convolution
# if issymbol(center position):
#   then read the row above, parsing any numbers
#        read the center row, parsing any numbers
#        read the bottom row, parsing any numbers

function To2DMatrix(game_input::Vector{String})::Matrix{Char}
    y = length(game_input)
    x = length(game_input[1])
    m = Matrix{Char}(undef, x, y)
    for (i, line) in enumerate(game_input)
        for (j, char) in enumerate(line)
            m[j, i] = char
        end
    end
    return m
end

function issymbol(char::Char)::Bool
    !(isdigit(char) || char == '.')
end

function isgear(char::Char)::Bool
    return char == '*'
end

function ThereAreNearbySymbols(x::UnitRange, y::Integer, symbols::BitMatrix)::Bool
    for i in max(y-1, 1):min(y+1, size(symbols)[1])
        for j in max(x[1]-1, 1):min(x[end]+1, size(symbols)[1])
            if symbols[j, i]
                return true
            end
        end
    end
    return false
end

function FindPartNumbers(matrix::Matrix{Char}, digits::BitMatrix, symbols::BitMatrix)
    # Pointers to the beginning and end of the current number
    part_numbers = Vector{Int}()

    for (i, col) in enumerate(eachcol(digits))
        start = 1
        is_number = false
        for (j, position_is_digit) in enumerate(col)
            # println("Position is (", j, ", ", i, ")")
            if position_is_digit
                is_number = true
                # Parse any numbers that go up until the end of the row
                if lastindex(col) == j
                    if ThereAreNearbySymbols(start:j, i, symbols)
                        push!(part_numbers, parse(Int, String(matrix[start:j, i])))
                    end
                end
            elseif is_number
                # We know the bounds of the part number
                # Look for any symbols around it
                # println("Matrix is $(matrix[start:j-1, i])")
                if ThereAreNearbySymbols(start:j-1, i, symbols)
                    push!(part_numbers, parse(Int, String(matrix[start:j-1, i])))
                end
                # Update the start
                start = j + 1
                # The number has passed, we aren't looking at one anymore
                is_number = false
            else
                start = j + 1
            end
        end
    end
    return part_numbers
end



games = readlines(joinpath(@__DIR__, "input", "3.txt"))
matrix = To2DMatrix(games)
digits = isdigit.(matrix)
symbols = issymbol.(matrix)
p1 = sum(FindPartNumbers(matrix, digits, symbols))
println("The solution to Part 1 is: ", p1)

#!!!!!!!!!! PT2 below !!!!!!!!!!
function isgear(char::Char)::Bool
    return char == '*'
end

function NearbyGears(x::UnitRange, y::Integer, gears::BitMatrix)::Union{Vector{Tuple{Int, Int}}, Nothing}
    found_gears = Vector{Tuple{Int, Int}}()
    for i in max(y-1, 1):min(y+1, size(symbols)[1])
        for j in max(x[1]-1, 1):min(x[end]+1, size(symbols)[1])
            if gears[j, i]
                push!(found_gears, (j, i))
            end
        end
    end
    if length(found_gears) == 0
        return nothing
    end
    return found_gears
end

function FindGearRatios(matrix::Matrix{Char}, digits::BitMatrix, gear_matrix::BitMatrix)
    # Pointers to the beginning and end of the current number
    gears = Dict{Tuple{Int, Int}, Vector{Int}}()

    for (i, col) in enumerate(eachcol(digits))
        start = 1
        is_number = false
        for (j, position_is_digit) in enumerate(col)
            # println("Position is (", j, ", ", i, ")")
            if position_is_digit
                is_number = true
                # Parse any numbers that go up until the end of the row
                if lastindex(col) == j
                    # println("At last index")
                    gear_positions = NearbyGears(start:j, i, gear_matrix)
                    if gear_positions !== nothing
                        for gear in gear_positions
                            push!(gears, gear=>parse(Int, String(matrix[start:j, i])))
                        end
                    end
                end
            elseif is_number
                # We know the bounds of the part number
                # Look for any symbols around it
                # println("Matrix is $(matrix[start:j-1, i])")
                # println("At end of number $(String(matrix[start:j-1, i]))")
                gear_positions = NearbyGears(start:j-1, i, gear_matrix)
                if gear_positions !== nothing
                    for gear in gear_positions
                        if gear in keys(gears)
                            push!(gears[gear], parse(Int, String(matrix[start:j-1, i])))
                        else
                            push!(gears, gear=>[parse(Int, String(matrix[start:j-1, i]))])
                        end
                    end
                end
                # Update the start
                start = j + 1
                # The number has passed, we aren't looking at one anymore
                is_number = false
            else
                start = j + 1
            end
        end
    end
    return gears
end

gears = isgear.(matrix)
println("The solution to Part 2 is: ", sum(x->length(x[2]) == 2 ? x[2][1] * x[2][2] : 0, FindGearRatios(matrix, digits, gears)))