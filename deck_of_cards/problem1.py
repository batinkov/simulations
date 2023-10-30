#!/usr/bin/env python3

from enum import Enum
from collections import namedtuple
import random

class Suit(Enum):
    ''' represents the four suits in a standard deck of cards '''
    CLUBS, DIAMONDS, HEARTS, SPADES = range(4)

class Rank(Enum):
    ''' represents the 13 ranks in a standard deck of cards '''
    TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE = range(13)
    
class Card(namedtuple('Card', ['rank', 'suit'])):
    ''' named tuple class that represents a Card with its suit and rank '''
    def __str__(self):
        return f'{Rank(self.rank).name} of {Suit(self.suit).name}'

def card2num(card):
    ''' converts the Card tuple to unique number in the range [0, 52) '''
    return 13*card.suit.value + card.rank.value

def num2card(num):
    ''' converts a number from the range [0, 52) to a unique Card tuple '''
    if (num < 0) or (num >= 52):
        assert False, f'The number of a card must be in the range [0, 52)! Got {num}'

    suit = num // 13
    rank = num % 13
    
    return Card(rank, suit)

if __name__  == '__main__':
    max_iterations = 1_000_000 # how many times to perform the experiment

    desired_card1_num = card2num(Card(rank = Rank.ACE, suit = Suit.SPADES)) # the numeric representation of desired card 1
    desired_card1_count = 0 # how many times desired card 1 was found right after the trigger card

    desired_card2_num = card2num(Card(rank = Rank.TWO, suit = Suit.CLUBS)) # the numeric representation of desired card 2
    desired_card2_count = 0 # how many times desired card 2 was found right after the trigger card

    # the cards that trigger to check if the next in the deck is any of the desired cards
    trigger_cards_num = [card2num(Card(Rank.ACE, Suit.CLUBS)),
                         card2num(Card(Rank.ACE, Suit.DIAMONDS)),
                         card2num(Card(Rank.ACE, Suit.HEARTS)),
                         card2num(Card(Rank.ACE, Suit.SPADES)),
                        ]

    deck_cards_num = list(range(52)) # the deck of cards represented as numbers and ordered
    
    # perform the experiments many times
    for iteration in range(max_iterations):
        random.shuffle(deck_cards_num) # shuffle the deck
    
        # start iterating over the shuffled deck
        for index in range(len(deck_cards_num) - 1): # iterate over the deck but don't go to the last card
            if deck_cards_num[index] in trigger_cards_num: # check for trigger card
                if deck_cards_num[index+1] == desired_card1_num: # the position index+1 is guaranteed to be inside the deck
                    desired_card1_count += 1
    
                if deck_cards_num[index+1] == desired_card2_num: # the position index+1 is guaranteed to be inside the deck
                    desired_card2_count += 1
    
                break # the trigger card has been found so stop iterating and perform new iteration of the experiment
    
    print(f'iterations: {max_iterations}')
    print(f'"{num2card(desired_card1_num)}" hits: {desired_card1_count}')
    print(f'"{num2card(desired_card2_num)}" hits: {desired_card2_count}')
