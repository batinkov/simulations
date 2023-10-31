// requires to be compiles with ES6 version or higher

// represents the four suits in a standard deck of cards
enum Suit { clubs, diamonds, hearts, spades }

// represents the 13 ranks in a standard deck of cards
enum Rank { two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace }

// type alias that represents a Card with its suit and rank
type Card = {
    rank: Rank
    suit: Suit
}

// converts a number from the range [0, 52) to a Card
function num2card(n: number): Card {
    n = Math.floor(n) // make sure n is integer

    if ((n < 0) || (n >= 52)) {
        throw new Error(`The number of a card must be in the range [0, 52)! Got ${n}`)
    }

    const rank = n % 13;
    const suit = Math.floor(n / 13);

    const card: Card = {rank: rank, suit: suit}
    return card
}

// converts Card to unique number in the range [0, 52)
function card2num(card: Card): number {
    return 13*card.suit + card.rank
}

const max_iterations = 1_000_000 // how many times to perform the experiment

const desired_card1_num = card2num({rank: Rank.ace, suit: Suit.spades}) // the numeric representation of desired card 1
let   desired_card1_count = 0 // how many times desired card 1 was found right after the trigger card

const desired_card2_num = card2num({rank: Rank.two, suit: Suit.clubs}) // the numeric representation of desired card 2
let   desired_card2_count = 0 // how many times desired card 2 was found right after the trigger card

let deck_cards_num = Array.from({length: 52}, (_, x) => x) // the deck of cards represented as numbers and ordered

// the cards that trigger to check if the next in the deck is any of the desired cards
const trigger_cards_num = [card2num({rank: Rank.ace, suit: Suit.clubs}),
                           card2num({rank: Rank.ace, suit: Suit.diamonds}),
                           card2num({rank: Rank.ace, suit: Suit.hearts}),
                           card2num({rank: Rank.ace, suit: Suit.spades}),
                          ]

// perform the experiments many times
for (let i=0; i<max_iterations; ++i) {
    // shuffle the deck
    deck_cards_num.sort(() => {
        return Math.random() - 0.5
    })

    // iterate over the deck but don't go to the last card
    for (let index=0; index<deck_cards_num.length-1; ++index) {
        // check for trigger card
        if (deck_cards_num[index] in trigger_cards_num) {
            // the position index+1 is guaranteed to be inside the deck
            if (deck_cards_num[index+1] == desired_card1_num) {
                desired_card1_count += 1
            }
            
            // the position index+1 is guaranteed to be inside the deck
            if (deck_cards_num[index+1] == desired_card2_num) {
                desired_card2_count += 1
            }
            
            break // the trigger card has been found so stop iterating and perform new iteration of the experiment
        }
    }
}

console.log(`iterations: ${max_iterations}`)
console.log(`"${JSON.stringify(num2card(desired_card1_num))}" hits: ${desired_card1_count}`)
console.log(`"${JSON.stringify(num2card(desired_card2_num))}" hits: ${desired_card2_count}`)
