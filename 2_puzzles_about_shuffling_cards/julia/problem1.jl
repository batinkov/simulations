using ArgParse
using Statistics

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
            default = 10_000
    end

    return parse_args(settings)
end

function conductAnExperiment(deals, deck, triggerCards, desiredCards)
    frequencies = Dict{Card, Float64}()
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
    
    for card in desiredCards
        frequencies[card] /= deals
    end

    return frequencies
end

function performZTest(sample1, sample2)
    m1 = mean(sample1)
    v1 = var(sample1)
    n1 = length(sample1)
    
    m2 = mean(sample2)
    v2 = var(sample2)
    n2 = length(sample2)

    z_score = (m1 - m2) / sqrt(v1/n1 + v2/n2)
    
    return z_score, m1, v1, m2, v2
end

function main()
    args = arg_parse() # collect the command line arguments
    for arg_key in keys(args)
        println("$(arg_key) -> $(args[arg_key])") # display the simulation parameters to the user
    end
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
    
    # keep the frequencies of the desired cards after all the experiments have been conducted
    frequencies = Dict{Card, Vector{Float64}}()
    for card in desired_cards
        frequencies[card] = Float64[]
    end

    open("problem1.log", "w") do file
        for experiment in 1:experiments
            println(file, "Experiment #$experiment - deals: $deals")

            result = conductAnExperiment(deals, deck, trigger_cards, desired_cards)
            for card in desired_cards
                push!(frequencies[card], result[card])

                println(file, "\t $(card) frequencies: $(result[card])")
            end
            println(file)
        end
    end
    
    # perform z-test only if you have more than 30 samples/experiments
    if experiments > 30
        s1 = frequencies[Card(Cards.ace, Cards.spades)]
        s2 = frequencies[Card(Cards.two, Cards.clubs)]

        z_score, m1, v1, m2, v2 = performZTest(s1, s2)

        println("The mean of 'ace of spades frequencies' is $m1")
        println("The variance of 'ace of spades frequencies' is $v1")
        println("The number of elements in 'ace of spades frequencies' is $(length(s1))")
        println()
        println("The mean of 'two of clubs frequencies' is $m2")
        println("The variance of 'two of clubs frequencies' is $v2")
        println("The number of elements in 'two of clubs frequencies' is $(length(s2))")
        println()
        println("The z-score is $z_score")
    end
end

main()
