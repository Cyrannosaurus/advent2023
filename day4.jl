struct Card
    winning_numbers::Vector{Int}
    card_numbers::Vector{Int}
end

Base.parse(::Type{Card}, card::String)::Card = begin
    _, card₁ = split(card, ':')
    numbers = String.(strip.(split(card₁, '|')))
    winning_numbers, card_numbers = split.(numbers)
    Card(parse.(Int, String.(winning_numbers)), parse.(Int, String.(card_numbers)))
end

value(card::Card)::Int = begin
    i = intersect(card.winning_numbers, card.card_numbers)
    2^(max(0, length(i)-1)) * (length(i) != 0)
end

input = readlines(joinpath(@__DIR__, "input", "4.txt"))


cards = parse.(Card, input)
println("Part One: ", sum(value.(cards)))

# Part 2
matches(card::Card)::Int = begin
    length(intersect(card.winning_numbers, card.card_numbers))
end

function SetUpPartTwo(cards::Vector{Card})::Vector{Vector{Card}}
    infinite_cards = Vector{Vector{Card}}()
    for card in cards
        push!(infinite_cards, push!(Vector{Card}(), card))
    end
    return infinite_cards
end

function MakeCopies!(cards::Vector{Vector{Card}})
    for (i, copies) in enumerate(cards)
        for card in copies
            for m in 1:matches(card)
                # Create a copy
                push!(cards[i+m], cards[i+m][1])
            end
        end
    end
    return cards
end

function CountCards(cards::Vector{Vector{Card}})::Int
    acc = 0
    for copies in cards
        acc += length(copies)
    end
    return acc
end

cards₂ = SetUpPartTwo(cards)
MakeCopies!(cards₂)
println("Part Two: ", CountCards(cards₂))