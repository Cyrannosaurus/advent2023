using DataStructures: DefaultDict
# Read input
# Sort hands by rank
# Multiply bid by rank
# Sum them all up

struct Card
    value::Int
end

struct Hand
    cards::Vector{Card}
    bid::Int
end


Base.parse(::Type{Card}, character::Union{AbstractString, AbstractChar})::Card = begin
    char = Char(character)
    if char == 'A'
        return Card(14)
    elseif char == 'K'
        return Card(13)
    elseif char == 'Q'
        return Card(12)
    elseif char == 'J'
        return Card(1)
    elseif char == 'T'
        return Card(10)
    else
        return Card(parse(Int, char))
    end
end

Base.isless(card₁::Card, card₂::Card)::Bool = begin
    return card₁.value < card₂.value
end


Base.parse(::typeof(Hand), hand::String)::Hand = begin
    cards = Vector{Card}()
    hand₁, bid = split(hand)
    for char in hand₁
        push!(cards, parse(Card, char))
    end
    return Hand(cards, parse(Int, bid))
end

value(hand::Hand)::Int = begin
    d = DefaultDict{Int, Int}(0)
    for c in hand.cards
        d[c.value] += 1
    end
    total = 0
    joker_count = d[1]
    if joker_count == 5
        return 6
    end
    mode = argmax(delete!(d, 1))
    for (key, count) in d
        if key == mode
            count += joker_count
        end
        if count == 2
            total += 1
        elseif count == 3
            total += 3
        elseif count == 4
            total += 5
        elseif count == 5
            total += 6
        end
    end
    return total
end

Base.isless(hand₁::Hand, hand₂::Hand)::Bool = begin
    value₁ = value(hand₁)
    value₂ = value(hand₂)
    if value₁ < value₂
        return true
    elseif value₁ > value₂
        return false
    else
        for (card₁, card₂) in zip(hand₁.cards, hand₂.cards)
            if card₁ < card₂
                return true
            elseif card₁ > card₂
                return false
            end
        end
    end
    return false
end

input = readlines(joinpath(@__DIR__, "input", "7.txt"))
hands = parse.(Hand, input)
sort!(hands)
# Sum the winnings
acc = 0
for (rank, hand) in enumerate(hands)
    global acc += hand.bid * rank
end
println(acc)