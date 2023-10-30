using Random

# represents the four suits in a standard deck of cards
@enum Suit begin
    clubs = 0
    diamonds
    hearts
    spades
end

# represents the 13 ranks in a standard deck of cards
@enum Rank begin
    two = 0
    three
    four
    five
    six
    seven
    eight
    nine
    ten
    jack
    queen
    king
    ace
end

# type that represents a Card with its suit and rank
struct Card
    rank:: Rank
    suit:: Suit
end

# converts a number from the range [0, 52) to a Card
function number2card(n::Int8)::Card
    if (0 > n) || (n >= 52)
        error("The number of a card must be in the range [0, 52)! Got $n")
    end

    rank = Rank(n % 13)
    suit = Suit(div(n, 13))

    return Card(rank, suit)
end

# converts Card to unique number in the range [0, 52)
function card2number(card::Card)::Int8
    return 13*Int8(card.suit) + Int8(card.rank)
end

const maxIterations = 1_000_000 # how many times to perform the experiment

const desiredCard1Num = card2number(Card(ace, spades)) # the numeric representation of desired card 1
desiredCard1Count = 0 # how many times desired card 1 was found right after the trigger card

const desiredCard2Num = card2number(Card(two, clubs)) # the numeric representation of desired card 2
desiredCard2Count = 0 # how many times desired card 2 was found right after the trigger card

# the cards that trigger to check if the next in the deck is any of the desired cards
const triggerCardsNum = [card2number(Card(ace, clubs)),
                         card2number(Card(ace, diamonds)),
                         card2number(Card(ace, hearts)),
                         card2number(Card(ace, spades)),
                        ]

cardDeckNum = collect(Int8, 0:1:51) # the deck of cards represented as numbers and ordered

counterIterations = 0
while counterIterations < maxIterations # perform the experiments many times
    global counterIterations, desiredCard1Count, desiredCard2Count

    shuffle!(cardDeckNum) # shuffle the deck

    index = 1
    while index <= length(cardDeckNum) - 1 # iterate over the deck but don't go to the last card
        if cardDeckNum[index] in triggerCardsNum # check for trigger card
            if cardDeckNum[index+1] == desiredCard1Num # the position index+1 is guaranteed to be inside the deck
                desiredCard1Count += 1
            end

            if cardDeckNum[index+1] in desiredCard2Num # the position index+1 is guaranteed to be inside the deck
                desiredCard2Count += 1
            end

            break # the trigger card has been found so stop iterating and perform new iteration of the experiment
        end

        index += 1
    end

    counterIterations += 1
end

println("iterations: $maxIterations")
println("$(number2card(desiredCard1Num)) hits: $desiredCard1Count")
println("$(number2card(desiredCard2Num)) hits: $desiredCard2Count")
