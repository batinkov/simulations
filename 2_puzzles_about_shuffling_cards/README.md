### This is a Monte Carlo simulation for the math problems discussed here:
https://www.youtube.com/watch?v=316GRjuKgT0

### Problem 1:
A standard deck of 52 playing cards is shuffled. The cards are turned up one by one until an ace appears. Is the next card - the one following the 1-st ace - more likely to be the ace of spades or the two of clubs?

+ The Python implementation problem1.py runs much faster if you use PyPy instead of the reference CPython implementation
+ The Julia implementation problem1.jl runs faster than the Python implementation even when PyPy is used
+ Surprisingly the TS version runs faster than the Python version (with the CPython implementation)

### TODO:
- not sure if the random number generator used is good enough for simulations like this one?

### Problem 2:
To be added