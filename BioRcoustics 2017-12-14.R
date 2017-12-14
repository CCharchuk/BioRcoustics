library(seewave)
library(tuneR)
setwd("C:/Users/Richard Hedley/Desktop")
  
  ##############  
#Object types

#Vector

g=c(1,10,5,4,6)

#The function c means concatenate.
g

#Multiplying vectors by vectors

sum(g)

#Elementwise:
g*g
g^2
x=g*g
x <- g*g

#Dot product
g%*%g

#You can name the elements of vectors.
names(g) = c('Frank', 'Cindy', 'Brian', 'Georgia', 'Beelzebub')
names(g) = c('Frank', 'Cindy', 'Brian', 'Georgia', 'Beelzebub')

#That allows you to access data using these names.
g['Beelzebub']

#Data Frame stores a set of vectors (vertically)

h=data.frame(ID=c(1:10), Value=c(21:30))

#Subsetting data frames

#In general, row i and column j are represented by [i,j] after object name.

#By column name

h$ID

#another way using column name
h[,'ID']

#By column number

h[,1]
#Beware column numbers are fluid! Names, not as much.

#What if rows are named too?

row.names(h)=letters[1:10]

#By row name?
h$a #Doesn't work
h['a',] #Works!
h[1,] #Works!


#######
#Matrices

#Notice this function has multiple arguments.
M=matrix(c(1,2,3,4,5,6,7,8,9), nrow=3)
M

#How do you know what the arguments are? Look at documentation with ?
?matrix

#notice there are several arguments
N=matrix(c(1:9), nrow=3, byrow=T)
N==M

#Can name matrix rows and columns too.
dimnames(M)=list(c(letters[1:3]), c(letters[4:6]))
M

#Subsetting Matrices

M$d #Doesn't work.
M[,'d'] #Works
M[,1] #Works

#What's the difference between a matrix and a data frame?


#Subsetting by values

which(N>3) #Gives INDEX of which elements of N are greater than 3
N[which(N>3)] #Gives values of N which are greater than 3
N>3  #Shows you which elements are >3
N[N>3] #Same as 2 rows above.

#Multiple criteria with & sign.
#This means "tell me the values of N are greater than 2, less than or equal
#to 8, and are odd.
N[N>2 & N<=8 & N%%2==1]

#This means "tell me the values of N that are less than 3 or greater than 5
N[N<3 | N>5] 


#####
#Lists

#List is a set of, well, anything you want. Can be a set of vectors, set of dataframes, etc.

MyList <- list(M, N, x, y)

#Subsetting lists
MyList$M #Doesn't work because elements of the list are not named.

names(MyList)=c('M', 'N', 'x', 'y')
MyList$M #Now it works.
MyList[1] #This works
MyList[[1]] #So does this. Usually you want to do this.

#Multi-level subsetting of lists

MyList[[1]][1,3]

#Example of how this can save lots of time.
#Say I want to measure the length of a sound. Read in the sound file,
#then calculate the number of samples, then divide by the sample rate. 3 steps.

x=proc.time()

sound=readWave('Sound1.wav')
SR=sound@samp.rate
Samples=length(sound@left)
Length=Samples/SR

proc.time()-x

#Compare with this:

x=proc.time()

Length=length(readWave('Sound1.wav', header=T)$samples)/readWave('Sound1.wav', header=T)$samp.rate

proc.time()-x

#Problem: Calculate the Shannon index of the following set of numbers

Set=c(1,5,12,14,18,20,4,3,2)

#Shannon index is calculated as follows:
#for each element, convert to proportion.
#for each proportion, multiply that proportion by the natural logarithm.
#Sum them
#Take the negative value.







#Data types

#Data comes in many different types.
Species=c('BCCH', 'CAVI', 'HOWR')
#Use the class function to figure out what type it is.
class(Species)

Species=as.factor(c('BCCH', 'CAVI', 'HOWR'))
class(Species)


Species=c(1, 2, 3)
class(Species)

Species=c(TRUE, TRUE, FALSE)
class(Species)


Species=data(tico)
class(Species)

#Data type determines what you can do with the data.

Species=c(1:3)
sum(Species)

Species=c('BCCH', 'CAVI', 'HOWR')
sum(Species)
is.numeric(Species)
is.character(Species)

#errors are FREQUENTLY a result of this.











