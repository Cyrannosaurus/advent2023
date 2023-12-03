struct Observation
    red::UInt
    green::UInt
    blue::UInt
end

struct Game
    id::UInt
    observations::Vector{Observation}
end

# These no worky
Base.show(io::IO, ::MIME"text/plain", g::Game) = print(io, "Game ", Int(g.id), ":", length(g.observations), " observations")
Base.display(d::AbstractDisplay, ::MIME"text/plain", g::Game) = print(io, "Game ", Int(g.id), ":", length(g.observations), " observations")

parse_game(line::String)::Game = begin
    gid, rest = split(line, ':')
    id = parse(UInt, gid[6:end])
    trials = split(String(rest), ';')
    obs = parse_obs.(String.(trials))
    return Game(id, obs)
end

parse_obs(obs::String)::Observation = begin
    cubes = strip.(split(obs, ','))
    counts = split.(String.(cubes), ' ')
    blue = red = green = 0
    for (count, color) in counts
        if color == "blue"
            blue = parse(UInt, count)
        elseif color == "red"
            red = parse(UInt, count)
        else
            green = parse(UInt, count)
        end
    end
    return Observation(red, green, blue)
end

games = readlines(joinpath(@__DIR__, "input", "2.txt"))
is_possible(game::Game, obs::Observation)::Bool = begin
    if obs.red < maximum(o -> o.red, game.observations)
        return false
    elseif obs.green < maximum(o -> o.green, game.observations)
        return false
    elseif obs.blue < maximum(o -> o.blue, game.observations)
        return false
    end
    return true
end

power(game::Game)::Int = begin
    return maximum(o -> o.red, game.observations) * maximum(o -> o.green, game.observations) * maximum(o -> o.blue, game.observations)
end

parsed_games = parse_game.(games)
acc = 0
acc₂ = 0
for g in parsed_games
    p = is_possible(g, Observation(12,13,14))
    if p
        global acc += g.id
    end
    global acc₂ += power(g)
end
println("Sum of game ids is ", acc)
println("Sum of game cube set power is ", acc₂)



