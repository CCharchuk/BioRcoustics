#Functions----
setwd("~/Documents/BioRcoustics")

#Load the datasets package.
#If you don't have it, you will need to install it.
library(datasets) 


#Load the airquality dataset from the dataset package.
data=airquality

#It is a dataframe with 6 variables.

#Always good to plot the data.
plot(data$Month, data$Ozone)

#simple function
mathfun <- function(a,b,c) {
  a*b*c + (a*b) + (a^c)
}
mathfun(2,3,4) #equals 2*3*4 + (2*3) + (2^4)

#We see that ozone looks higher in month 7 and 8. However, we are ignoring
#the day within each month. It'd be ideal to have that! But it's given as 
#day within each month, which is useless.
# We could probably get better
#visualization of our data 
#if we converted things to julian date. Let's write a function!

Convert.to.Julian = function(month, day) {  #Curly brackets define the start/end of a function.
  May1=121  #From the internet, I found out that May 1 is julian date 121.
            #Since that is the first day of our dataset, I'll store it.
  if(month == 5) {
    julian=day+May1-1
  }
  if(month == 6) {
    julian=day+May1-1+31 #Add the number of days in may.
  }
  if(month == 7) {
    julian=day+May1-1+61 #Add the number of days in may and june.
  }
  if(month == 8) {
    julian=day+May1-1+92 #Add the number of days in may, june, july.
  }
  if(month == 9) {
    julian=day+May1-1+123 #Add the number of days in may-august.
  }
  
  return(julian)  #the return() function lets you define the output of the function.
                  #In this case we have created two objects within the function.
                  #May1, which is not of interest, and julian, our desired output.
}


#We now have a function called "Convert.to.Julian".

Convert.to.Julian(5,15)  #This gives you the julian date of May 15.
Convert.to.Julian(9,12)  #This gives you the julian date of Sep 12.
#This is the same as 
Convert.to.Julian(month=9, day=12)
Convert.to.Julian(month=data$Month[135], day=data$Day[135])
#Always check to make sure your function works.----

#So the basic structure of a function is:

#FunctionName = function(argument1, argument2, argument3, ...) {
#
#  code does things with argument1, argument2, argument3
#  The code treats these as just regular old objects.
#
#  return(something)
#}


#Now say we want to convert ALL of our month, day pairings to julian date 
#using our function.

Convert.to.Julian(month=data$Month[1], day=data$Day[1])
Convert.to.Julian(month=data$Month[2], day=data$Day[2])
Convert.to.Julian(month=data$Month[3], day=data$Day[3])
Convert.to.Julian(month=data$Month[4], day=data$Day[4])
Convert.to.Julian(month=data$Month[5], day=data$Day[5])

#Well, that's a boring thing to do 153 times.
#This is where the power of coding becomes evident.


#Loops----
#We'll do this two ways: with a for loop and with the apply function.

#for loop
#First figure out how many times you want to iterate through things.
#In this case we want to use our function 153 times, once for each 
#row of data. 
rows=153
#or better yet:
rows=nrow(data)
#We'll store the julian dates as a vector called Dates.
#It's often necessary to initiate the output vector. We can do that here:
Dates=c()
#Now Dates is a vector of length 0 (i.e. empty)
#We are going to iteratively add to this vector
  for(i in 1:rows) { #Again with the curly brackets to define the start and 
  #end of the loop. Fills in i with 1:153 iteratively (doesn't have to be i, just has to be consistent)
  M=data$Month[i]  #Extract the month data for data point i
  D=data$Day[i]    #Extract the day data for data point i
  J=Convert.to.Julian(M,D) #convert M and D to a julian date.
  Dates=c(Dates,J)  #Add them to the Dates vector.
}

#Like magic, the Dates vector has now grown to include 153 dates.
#We can add that on to our main dataframe

data$Julian=Dates

#Now let's plot again
plot(data$Julian, data$Ozone)
#There you have it.


#What is a loop doing?
#It quite literally is just defining a new object, in this case called "i",
#which takes on the given values, in this case numbers 1 to 153. It iterates
#through, so the first time i=1, then i=2, then i=3, etc.
#You typically use the object i in place of a number to access data in 
#an iterative fashion. So above when we say M=data$Month[i], we are 
#saying "assign object M to be the "ith" member of the data$Month vector".

#So what happens if (realistically, when) your loop doesn't run.

#Let's say you write the following loop:
Dates=c()
for(i in 1:rows) { #Again with the curly brackets to define the start and 
  #end of the loop.
  M=data$Month[i]  #Extract the month data for data point i
  D=data$Day[i]    #Extract the day data for data point i
  J=Convert.to.Julian(M,D) #convert M and D to a julian date.
  if(i == 53) {stop('You fail at R')}
  Dates=c(Dates,J)  #Add them to the Dates vector.
}

#How would you go back and fix it?
#Look at the current value of i. It is 53. So that gives you some inkling.

#You can just store i=53 and go INTO the loop and see where the error is 
#occurring.

#This is also how I make loops in the first place.
#Start with i=1
Dates=c()
i=2
M=data$Month[i]  #Extract the month data for data point i
D=data$Day[i]    #Extract the day data for data point i
J=Convert.to.Julian(M,D) #convert M and D to a julian date.
Dates=c(Dates,J)
#If it works with i=1, it should work with i=2, i=3, etc. So make it work
#with some low numbers, then write the for(i in 1:rows) {} stuff afterwards.



#The other way to apply a function to a dataframe is with the apply function.
#There are several apply functions: apply, sapply, lapply, mapply.
#I won't go into them, but in general, they are faster than for loops.
?mapply
mapply(Convert.to.Julian, data$Month, data$Day)

#There is also >1 type of loop. 
#while loops are good if you want to run UNTIL some condition is met.
#For example simulate a population going to extinction. Once it goes to
#extinction, not much point carrying on.

x=0.5
sequence=x
while(x > 0 & x < 1) {
  x=x+rnorm(1,mean=-0.001, sd=0.01)
  sequence=c(sequence,x)
}
plot(sequence, type='l')


#One more example from my PhD work.----

sharing=read.csv('SongSharing.csv', header=T, row.names=1)

#Rows in this file are the different song types sung within a population of
#birds. Each column pertains to a bird. Column names are
#band combinations (if banded). Cells contain how many times the bird
#sang each song type.
#I want to compare how much repertoire overlap there is between each
#possible combination of 19 birds. There are 19*18/2=171 different comparisons.

#Convert NAs to 0s

sharing[is.na(sharing)]=0

#Convert values >0 to 1, since we don't care how many times they sang it,
#only if they did or not.

sharing[sharing>0]=1

#Now comes the for loop. First need to create a place for the output.
#I'd like to store it in a 19*19 matrix, where each row/column corresponds
#to a single bird. Cell [i,j] will contain info comparing bird i to bird j.

#Make the output matrix, filled with NA values.
comparison=matrix(NA, ncol=19, nrow=19, dimnames=list(c(colnames(sharing)), c(colnames(sharing))))

#How to fill it? Note that we need to fill the matrix along two dimensions.
#rows and columns. So we need TWO for loops!
for(i in 1:nrow(comparison)) {
  for(j in 1:ncol(comparison)) {
    if(i<=j) { #values below the diagonal are equal to values above, so no
      #need for them.
      vector1=sharing[,i]
      vector2=sharing[,j]
      overlap=sum(vector1*vector2) #If we multiply vector1 by vector2, 
      #then sum, we get the number of shared song types.
      #If i==j, it just gives the repertoire size of the bird.
      comparison[i,j]=overlap #put the value in the correct matrix cell.
    }
  }
}
















