module Cards
    using Random

    export Suit, Rank, Card
    export orderedDeck, shuffleDeck!

    "Represents the 4 suits in a standard deck of cards"
    @enum Suit clubs = 0 diamonds hearts spades

    "Represents the 13 ranks in a standard deck of cards"
    @enum Rank two = 0 three four five six seven eight nine ten jack queen king ace

    "Represents a card as a small integer"
    const Card = Int8

    "Creates a card and checks for the correct range of values. The Card type is just an integer in a range"
    function Card(n::Card)::Card
        if (n < 0) || (n >= 52)
            error("The number of a card must be in the range [0, 52)! Got $n")
        end

        return n
    end

    "Creates a card but not from an integer but from it's rank and suit"
    function Card(rank::Rank, suit::Suit)::Card
        return 13*Card(suit) + Card(rank)
    end

    "Overload of the the show function. When a Card is displayed its human readable form is used and not the integer representing it"
    function Base.show(io::IO, card::Card)
        rank = Rank(card % 13)
        suit = Suit(div(card, 13))

        print(io, "$(rank) of $(suit)")
    end

    "Returns a standard deck of 52 ordered Cards"
    function orderedDeck()::Array{Card, 1}
        return collect(Card, 0:1:51)
    end

    "Shuffles the deck of cards passed to the function"
    function shuffleDeck!(deck::Array{Card, 1})
        shuffle!(deck) # TODO: maybe we need to use different algorithm to shuffle the array
    end
end
