# Annoying shit
Base.findlast(r::Regex, s::AbstractString) = findprev(r,s,lastindex(s))
Base.findprev(re::Regex, str::Union{String,SubString}, idx::Integer) = begin
    if idx > nextind(str,lastindex(str)) || idx < prevind(str,firstindex(str))
        throw(BoundsError())
    end
    cur_ind = idx
    ans = nothing 
    while ans === nothing && cur_ind > firstindex(str)
        ans = findnext(re,str,cur_ind)
        cur_ind -= 1
    end
    return ans
end
# ------------------------------------------------------------------------------------
# Read input
lines = readlines(joinpath(@__DIR__, "input", "1.txt"))

# Get indices of the ascii digits
first_digit_index = findfirst.(Ref(isdigit), lines)
last_digit_index = findlast.(Ref(isdigit), lines)

# Get indices of the spelled out english numbers
number_regex = r"one|two|three|four|five|six|seven|eight|nine"
first_number_index = findfirst.(Ref(number_regex), lines)
last_number_index = findlast.(Ref(number_regex), lines)

function MergeData(fdi::Union{Nothing, Int}, ldi::Union{Nothing, Int}, fni::Union{Nothing, UnitRange}, lni::Union{Nothing, UnitRange})::Tuple{Union{UnitRange, Int}, Union{UnitRange, Int}}
    # Check that something was found
    if fdi === nothing && fni === nothing
        return 0
    end

    # Find the first match
    if fdi === nothing
        f = fni
    elseif fni === nothing
        f = fdi
    elseif fni[1] > fdi
        f = fdi
    else
        f = fni
    end

    # Find the last match
    if ldi === nothing
        l = lni
    elseif lni === nothing
        l = ldi
    elseif lni[1] < ldi
        l = ldi
    else
        l = lni
    end
    return (f, l)
end

function MapWordToNumber(word::Union{SubString, String})::Char
    return Dict("one"=>'1', "two"=>'2', "three"=>'3', "four"=>'4', "five"=>'5', "six"=>'6', "seven"=>'7', "eight"=>'8', "nine"=>'9')[word]
end

data = MergeData.(first_digit_index, last_digit_index, first_number_index, last_number_index)
for d in data
    println(d)
end
acc = 0
for (datum, line) in zip(data, lines)
    f, l = datum
    if typeof(f) <: Int
        rf = line[f]
    else
        rf = MapWordToNumber(line[f])
    end
    if typeof(l) <: Int
        rl = line[l]
    else
        rl = MapWordToNumber(line[l])
    end
    println(parse(Int, rf*rl))
    global acc += parse(Int, rf*rl)
end
println(acc)



