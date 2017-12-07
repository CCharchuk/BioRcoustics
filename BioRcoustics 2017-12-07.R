#Intro to R.

#Adding

1+2

#Subtracting

1-2

#Multiplication

1*2

#Division

1/2

#Exponentials

3^2

#Multiple calculations per line

1-2;1+2

#Order of operations

1-2*4

#BEDMASS

(1-2)*4

#Complex numbers

3.5-8i

#Defining an object.

z=3.5-8i

#Functions involve a word or set of letters followed directly by parentheses.
#Filled with arguments.

Re(z)


#Functions return a value or multiple values. That value can be stored as another object.

y=Re(z)

x=Re(3.5-8i)

#Objects are treated exactly like their elements

y == x

#Some basic functions are obvious

log(x)
sum(x,y)
round(x)
cos(x)
tan(x)
sin(x)

#Some other useful simple functions

floor(x)
ceiling(x)
exp(x)

#Other useful operators

y==x #test for equivalence
#Integer part
65 %/% 8 
#There's many ways to skin a pig
floor(65/8) == 65 %/% 8

#Modulo
65 %% 8

#plus, minus, times, divide, integer quotient, modulo, power
+ - * / %/% %% ^ 
  
#greater than, greater than or equals, less than, less than or equals, equals, not equals 
>= < <= == != 
  
#not, and, or
! & | 
  
#model formulae ('is modelled as a function of')
~ 
  
#assignment (gets)
<- -> 
  
#list indexing (the 'element name' operator)
$ 

#create a sequence
: 
  
  
##############  
#Object types

#Vector

g=c(1,10,5,4,6)

#The function c means concatenate.
g

#Multiplying vectors by vectors

#Elementwise:
g*g

#Dot product
g%*%g

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

#Problem: Calculate the Shannon index of the following set of numbers

Set=c(1,5,12,14,18,20,4,3,2)

#Shannon index is calculated as follows:
#for each element, convert to proportion.
#for each proportion, multiply that proportion by the natural logarithm.
#Sum them
#Take the negative value.














