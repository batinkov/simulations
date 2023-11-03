#!/usr/bin/env python3

from numpy import zeros,array,arange,savetxt,arange,linspace
from random import seed, randint, sample
from pylab import plot, show, xlabel, ylabel, title, grid, legend, xlim, ylim, yscale, figure, xscale, minorticks_on, tick_params, hist

### factorial function
def fact(n):
 if (n>1): return n*fact(n-1)
 if (n==1): return 1

ne=1000000		# number of experiments
nd=52			# number of cards (aces are numbered from 0 with increment 13)
deck=zeros(nd,int)	# numerated deck (spades, hearts, diamonds, clubs)
npos=zeros(ne,int)	# First position of ace (0, 13, 26, 39)
ace1=zeros(nd-4,float)	# permutations for ace in each position of the deck

iA=0			# counter for ace of spades occurrence
i2=0			# counter for 2 of clubs occurrence
iA2=0			# counter for ace of spades followed by 2 of clubs

### Monte-Carlo simulation
for i in range(ne):				# loop for each MC experiment
 seed()						# init the seed
 deck=sample(range(nd),k=nd)			# random seed the deck
 for j in range(nd):				# start revealing the cards from the deck
  if (deck[j]%13==0):				# stop when first ace appears
   npos[i]=j  					# save position in array
   break					# get out of loop
 if deck[j+1]==0:  iA=iA+1			# increment if next card is ace of spades
 if deck[j]==0 and deck[j+1]==40: iA2=iA2+1	# increment if trigger is ace of spades and next card is 2 of clubs
 if deck[j]!=0 and deck[j+1]==40: i2=i2+1	# increment if next card is 2 of clubs
 #print(deck)
#print(npos) 

### Console print the MC results
print('Results for',ne,'MC experiments.')
print('Ace of spades after another ace =',iA)
print('2 of clubs after ace besides ace of spades =',i2)
print('2 of clubs after ace of spades =',iA2)
idiff=iA-i2-iA2
print('Overall difference =',idiff,'and difference per experiment =',idiff/ne*1.e+02,'%')

### Analytic solution
pall=fact(nd)				# All possible permutations of a deck of nd cards
### Now realized with loops
# permutations for 2 of clubs
n3=3					# remaining 3 aces
nc=nd-5					# remaining uninteresting cards (47)
p2=fact(nd-2)				# permutation with ace on 1-st position
for i in range(nd-3,n3-1,-1):		# start from ace on 2-nd position down
 ptemp=fact(i)				# factorial for i-th position to 49 (nd-3)
 m=i-n3					# lower limit: from nc to i-th position
 for j in range(nc,m,-1):		# start from remaining nc down to 1st ace
  ptemp=ptemp*j				# calculate the permutation up to the factorial
 p2=p2+ptemp				# add this permutation to the overall result

# multiply by 4 for 4 trigger aces and divide by all permutations --> the probability
p2=4*p2/pall					

# permutations for ace of spades
n2=2					# remaining 2 aces
nc=nd-4					# remaining uninteresting cards (non-aces, 48)
pA=fact(nd-2)				# permutation with ace on 1-st position
for i in range(nd-3,n2-1,-1):		# start from ace on 2-nd position down
 ptemp=fact(i)				# factorial for i-th position to 50 (nd-2)
 m=i-n2					# lower limit: from nc to i-th position
 for j in range(nc,m,-1):		# start from remaining nc down to 1-st ace
  ptemp=ptemp*j				# calculate the permutation up to the factorial
 pA=pA+ptemp				# add this permutation to the overall result
 
# multiply by 3 for 3 trigger aces and divide by all permutations --> the probability
pA=3*pA/pall					

### Console print the MC results together with the analytic ones
i2=i2+iA2				# total 2 of clubs apperance
print('Calculated probabilities compared to MC experiments:')
print('Ace of spades after another ace: MC =',iA/ne,' \t analytic =',pA,"\t diff =",(iA/ne)/pA)
print('2 of clubs after any ace: MC =',i2/ne,' \t analytic =',p2,"\t diff =",(i2/ne)/p2)  

### Now let's create the distribution of for the 1-st ace appearance
n4=4				# number of aces
nr=nd-n4			# number of remaining other cards
for i in range(nr):		# start from 0 to nr
 ip=nd-i-1			# invert the position for factorial, start from ace in 1st
 ace1[i]=n4*fact(ip)		# factorial for remaining permutations
 for j in range(nr,nr-i,-1):	# loop for positions before 1-st ace of remaining cards
  ace1[i]=ace1[i]*j		# calculate the permutation up to the factorial
 ace1[i]=ace1[i]/pall		# divide by all permutations --> the probabilities

### Finally plot the distribution, histogram for MC and line plot for analytic solution
xlabel('$i$ 1-st ace reveal position',fontsize='x-large')
ylabel(r'$N_i/N$',fontsize='x-large')
hist(npos, bins=nd-4, color="lightgray",edgecolor='k',density=True)
plot(arange(0.0+0.5,float(nr)+0.5,1.0),ace1,"k-")
show()
