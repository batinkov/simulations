using ArgParse

include("lib/Cards.jl")
using .Cards

function arg_parse()
    settings = ArgParseSettings()
    @add_arg_table! settings begin
        "--experiments", "-e"
            help = "the number of experiments to perform"
            arg_type = Int64
            default = 1
        "--deals", "-d"
            help = "how many deals to perform as part of a single experiment"
            arg_type = Int64
            default = 1_000_000
    end
    return parse_args(settings)
end

function conductAnExperiment(deals, deck, triggerCards, desiredCards)
    frequencies = Dict()
    for card in desiredCards
        frequencies[card] = 0
    end

    for _ in 1:deals
        shuffleDeck!(deck)

        for deckIndex in 1:length(deck)-1
            if deck[deckIndex] in triggerCards
                nextCard = deck[deckIndex+1]

                if nextCard in desiredCards
                    frequencies[nextCard] += 1
                end

                break
            end
        end
    end

    return frequencies
end

function main()
    @show args = arg_parse()
    println()

    experiments = args["experiments"] # how many experiments to perform
    deals = args["deals"] # how many deals to perform as part of a single experiment
    deck = orderedDeck() # a deck of cards to play with

    # the trigger cards
    trigger_cards = [Card(Cards.ace, Cards.clubs),
                     Card(Cards.ace, Cards.diamonds),
                     Card(Cards.ace, Cards.hearts),
                     Card(Cards.ace, Cards.spades),
                    ]

    # cards to check for after the first trigger card is encountered
    desired_cards = [Card(Cards.ace, Cards.spades),
                     Card(Cards.two, Cards.clubs),
                    ]

    for experiment in 1:experiments
        println("Experiment #$experiment")
        result = conductAnExperiment(deals, deck, trigger_cards, desired_cards)
        for card in desired_cards
            print("\t")
            println("$(card) hits: $(result[card])")
        end
        println()
    end
end

main()
