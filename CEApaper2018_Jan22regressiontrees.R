options (java.parameters = "-Xmx1024m" )

#Read in the bird data you will use 
birds<-read.csv("merge6excessbbsremoved.csv", header=TRUE)
#this is a dataset containing point counts from Alberta's boreal forest region. Some point counts are on different energy 
#sector disturbances and some are at varying distances away. The effect of the energy sector disturbances on boreal bird
#abundance is measured several ways in this data set: as the area occupied by that disturbance within 150 m (dose-response),
#whether or not a point count is "on" (<150 m from) or "off" a particular disturbance (control-impact), or the shortest distance
#from each point count to each type of disturbance (zone-of-impact or influence). The energy sector disturbances of interest
#are roads, pipelines, seismic lines, and gas wellpads.

#For each bird species, the number of detected from each point count is recorded. There are offsets for each species, based on the 
#singing rate and likelihood of detecting each species given its availability (singing), which varies with effective detection radius.

#There are also habitat variables, latitude and longitude, all of which can affect presence of a species.
#Due to the large number of habitat variables, I have also created broader habitat classes that individual species might be assigned to
#in models, based on their predicted a priori habitat preferences. For example, based on a Boreal Avian Modelling Project in Forest 
#Ecology and Management (Mahon et al. 2017), Ovenbirds would be predicted to be more abundant in structurally complex, older deciduous forest.

#Based on other studies, Ovenbirds would be predicted to decline along seismic lines, pipelines, well-pads, and roads; decline as the area of
#these disturbances increases within 150 m of point counts; and increase as point counts get further away from these disturbances.

#How Ovenbird abundance varies with habitat and human footprint amount might be linear or non-linear.

#Ovenbird
mean(birds$OVEN)#0.51
var(birds$OVEN)#1.00
#probably better modelled as a negative bino ial distribution, but we'll use Poisson anyway

birds$YEAR<-as.factor(birds$YEAR)#changed to categorical variable: data unbalanced and no good reason to 
#believe abundance will vary linearly with year

birds$YoungWhiteSpruce<-birds$ConifR+birds$Conif1+birds$Conif2+birds$Conif3+birds$Conif4+birds$CCConifR+birds$CCConif1+birds$CCConif2+birds$CCConif3+birds$CCConif4
birds$OldWhiteSpruce<-birds$Conif5+birds$Conif6+birds$Conif7+birds$Conif8+birds$Conif9
birds$YoungBlackSpruce<-birds$Swamp.Conif0+birds$Swamp.ConifR+birds$Swamp.Conif1+birds$Swamp.Conif2+birds$Swamp.Conif3+birds$Swamp.Conif4+birds$Wetland.BSpr0+birds$Wetland.BSprR+birds$Wetland.BSpr1+birds$Wetland.BSpr2+birds$Wetland.BSpr3+birds$Wetland.BSpr4
birds$OldBlackSpruce<-birds$Swamp.Conif5+birds$Swamp.Conif6+birds$Swamp.Conif7+birds$Swamp.Conif8+birds$Swamp.Conif9+birds$Wetland.BSpr5+birds$Wetland.BSpr6+birds$Wetland.BSpr7+birds$Wetland.BSpr8+birds$Wetland.BSpr9
birds$Decid.Old<-birds$CCDecid4+birds$Decid4+birds$Decid5+birds$Decid6+birds$Decid7+birds$Decid8+birds$Decid9+birds$Swamp.Decid4+birds$Swamp.Decid5+birds$Swamp.Decid6+birds$Swamp.Decid7+birds$Swamp.Decid8+birds$Swamp.Decid9
birds$Decid.Herb<-birds$CCDecidR+birds$DecidR+birds$Swamp.DecidR
birds$Decid.Shrub<-birds$CCDecid1+birds$Decid1+birds$Swamp.Decid1
birds$Decid.Pole<-birds$CCDecid2+birds$Decid2+birds$Swamp.Decid2
birds$Decid.Mature<-birds$CCDecid3+birds$Decid3+birds$Swamp.Decid3

birds$Mixwood.Old<-birds$CCMixwood4+birds$Mixwood4+birds$Mixwood5+birds$Mixwood6+birds$Mixwood7+birds$Mixwood8+birds$Mixwood9+birds$Swamp.Mixwood4+birds$Swamp.Mixwood5+birds$Swamp.Mixwood6+birds$Swamp.Mixwood7+birds$Swamp.Mixwood8+birds$Swamp.Mixwood9
birds$Mixwood.Herb<-birds$CCMixwoodR+birds$MixwoodR+birds$Swamp.MixwoodR
birds$Mixwood.Shrub<-birds$CCMixwood1+birds$Mixwood1+birds$Swamp.Mixwood1
birds$Mixwood.Pole<-birds$CCMixwood2+birds$Mixwood2+birds$Swamp.Mixwood2
birds$Mixwood.Mature<-birds$CCMixwood3+birds$Mixwood3+birds$Swamp.Mixwood3

birds$YoungPine<-birds$Pine0+birds$PineR+birds$Pine1+birds$Pine2+birds$Pine3+birds$Pine4+birds$Swamp.Pine0+birds$Swamp.PineR+birds$Swamp.Pine1+birds$Swamp.Pine2+birds$Swamp.Pine3+birds$Swamp.Pine4+birds$CCPineR+birds$CCPine1+birds$CCPine2+birds$CCPine3+birds$CCPine4
birds$OldPine<-birds$Pine5+birds$Pine6+birds$Pine7+birds$Pine8+birds$Pine9+birds$Swamp.Pine5+birds$Swamp.Pine6+birds$Swamp.Pine7+birds$Swamp.Pine8+birds$Swamp.Pine9

birds$YoungLarchFen<-birds$Wetland.Larch0+birds$Wetland.LarchR+birds$Wetland.Larch1+birds$Wetland.Larch2+birds$Wetland.Larch3+birds$Wetland.Larch4
birds$OldLarchFen<-birds$Wetland.Larch5+birds$Wetland.Larch6+birds$Wetland.Larch7+birds$Wetland.Larch8+birds$Wetland.Larch9

birds$SimpleProd<-birds$Wetland.Shrub+birds$Wetland.GrassHerb+birds$Shrub+birds$GrassHerb+birds$Mixwood.Herb+birds$Mixwood.Shrub+birds$Decid.Herb+birds$Decid.Shrub
birds$SimpleUnprod<-birds$YoungPine+birds$OldPine+birds$YoungLarchFen+birds$OldLarchFen+birds$YoungBlackSpruce+birds$OldBlackSpruce
birds$ComplexDecid<-birds$Decid.Pole+birds$Mixwood.Pole+birds$Decid.Mature+birds$Decid.Old+birds$Mixwood.Mature+birds$Mixwood.Old
birds$ComplexConif<-birds$OldWhiteSpruce+birds$YoungWhiteSpruce
  
birds$Roads<-birds$RoadHardSurface+birds$RoadVegetatedVerge+birds$RoadTrailVegetated
birds$Linear<-birds$SeismicLine+birds$Pipeline+birds$RoadHardSurface+birds$TransmissionLine+birds$RoadVegetatedVerge+birds$RoadTrailVegetated
birds$Open<-birds$RuralResidentialIndustrial+birds$IndustrialSiteRural+birds$WellSite+birds$MineSite
birds$Narrow<-birds$SeismicLine
birds$Wide<-birds$Pipeline+birds$RoadHardSurface+birds$TransmissionLine+birds$RoadVegetatedVerge+birds$RoadTrailVegetated+birds$RuralResidentialIndustrial+birds$IndustrialSiteRural+birds$WellSite+birds$MineSite
birds$Forestry<-birds$CCPineR+birds$CCPine1+birds$CCPine2+birds$CCPine3+birds$CCPine4+birds$CCMixwoodR+birds$CCMixwood1+birds$CCMixwood2+birds$CCMixwood3+birds$CCMixwood4+birds$CCConifR+birds$CCConif1+birds$CCConif2+birds$CCConif3+birds$CCConif4+birds$CCDecidR+birds$CCDecid1+birds$CCDecid2+birds$CCDecid3+birds$CCDecid4
birds$Energy<-birds$Pipeline+birds$RoadHardSurface+birds$TransmissionLine+birds$RoadVegetatedVerge+birds$RoadTrailVegetated+birds$RuralResidentialIndustrial+birds$IndustrialSiteRural+birds$SeismicLine+birds$WellSite+birds$MineSite

# birds$logNEAR_DIST_SEISMIC<-log(birds$NEAR_DIST_SEISMIC+0.1)
# birds$logNEAR_DIST_PIPELINE<-log(birds$NEAR_DIST_PIPELINE+0.1)
# birds$logNEAR_DIST_WELL<-log(birds$NEAR_DIST_WELL+0.1)
# birds$logNEAR_DIST_ANYROAD<-log(birds$NEAR_DIST_ANYROAD+0.1)
# #birds$logNEAR_DIST_CUTBLOCK<-log(birds$NEAR_DIST_CUTBLOCK+0.1)
# 
# birds$sNEAR_DIST_PIPELINE<-scale(birds$NEAR_DIST_PIPELINE, center=TRUE, scale=TRUE)
# birds$sNEAR_DIST_WELL<-scale(birds$NEAR_DIST_WELL, center=TRUE, scale=TRUE)
# birds$sNEAR_DIST_SEISMIC<-scale(birds$NEAR_DIST_SEISMIC, center=TRUE, scale=TRUE)
# birds$sNEAR_DIST_ANYROAD<-scale(birds$NEAR_DIST_ANYROAD, center=TRUE, scale=TRUE)
# #birds$sNEAR_DIST_CUTBLOCK<-scale(birds$NEAR_DIST_CUTBLOCK, center=TRUE, scale=TRUE)
# 
# birds$sLAT<-scale(birds$Y, center=TRUE, scale=TRUE)
# birds$sLONG<-scale(birds$X, center=TRUE, scale=TRUE)

#variables that might need to be transformed or standardized for other types of models, but they don't need to be for regression trees.



birds$SeismicLineTrt<-ifelse(birds$Impact=="Seismic",1,0)
birds$PipelineTrt<-ifelse(birds$Impact=="Pipeline",1,0)
birds$WellTrt<-ifelse(birds$Impact=="Wellpad",1,0)
birds$RoadTrt<-ifelse(birds$Impact=="Road",1,0)

#assigns point counts to binary disturbance categories as opposed to the "Impact" categorical variable in the data frame
#Variance Inflation Analysis
#install.packages("usdm")

library(usdm)
df = birds[,c("Decid.Old","Decid.Mature","Decid.Pole","Decid.Shrub","Decid.Herb","Mixwood.Old","Mixwood.Mature","Mixwood.Pole","Mixwood.Shrub","Mixwood.Herb","YoungWhiteSpruce","OldWhiteSpruce","YoungPine","OldPine","YoungLarchFen","OldLarchFen","YoungBlackSpruce","OldBlackSpruce","SeismicLine","WellSite","Pipeline","Roads")]
vif(df)

#Testing for strongly correlated predictor variables and removing those that cause Variance Inflation Factors to shoot above 10.
#It's debatable whether this needs to also be done for regression trees as it is for regular regression models


#Using Classification and Regression Trees to Find Breakpoints for Zone-of-Impact Models

#So the reason that I became interested in regression models was to find threshold distances from energy sector disturbances 
#(if any existed) at which abundance of boreal birds strongly changed

#The next section (commented out) provides a basic example of a regression tree using a package called partykit
# library(partykit)
# data("WeatherPlay", package = "partykit")
# WeatherPlay
# sp_o <- partysplit(1L, index = 1:3)#creates 3 splits for the outcome variable (col.1)
# sp_h <- partysplit(3L, breaks = 75)#creates 2 splits in the humidity variable (col.3) at the value 75
# sp_w <- partysplit(4L, index = 1:2)#creates 2 splits for the windy variable (col.4)
# 
# pn <- partynode(1L, split = sp_o, 
#                 kids = list(partynode(2L, split = sp_h, 
#                                       kids = list(partynode(3L, info = "yes"),
#                                                   partynode(4L, info = "no"))),                               
#                             partynode(5L, info = "yes"), 
#                             partynode(6L, split = sp_w, 
#                                       kids = list(partynode(7L, info = "yes"),
#                                                   partynode(8L, info = "no")))))
# #creates a decision tree represented by a partynode object. The first argument indicates
# #depth within a tree with higher numbers indicating greater depth (further branching)
# #the first split is among different outcomes. Second split (first kid nodes) is into
# #different humidity levels
# pn #data still raw, not yet applied to the Weatherplay dataset
# 
# #Now couple the recursive tree structure stored in pn with the corresponding data in a 'party' object.
# py <- party(pn, WeatherPlay)
# print(py)
# length(py)#branches
# width(py)#partitions at top of tree
# depth(py)#levels
# plot(py)
# #so far I've built a specific tree. I can inspect specific branches, each of which is its
# #own tree
# py[6]
# plot(py[6])
#

# #Decision trees using rpart package. Continuous response variable will give regression trees.
# #Categorical response variable (like Emily's) will give classification trees.
# #Adapted From: https://rpubs.com/minma/cart_with_rpart
library(rpart)
library(rpart.plot)
# Step1: Begin with a small cp. Cp = complexity parameter, which is a function of the number of observations you are modelling in
#your whole tree and the number of observations in the terminal nodes (leaves) of your tree. Cp is calculated iteratively for each branch
#of each new node in your tree. As each branch splits further into new branches, the cp value of that branch gets increasingly smaller.
#Once the cp calculated gets smaller than a threshold value, further splitting of that branch stops, and the rpart package goes back to the next 
#branch point and calculates cp for that branch point.

set.seed(123)#each time a regression tree is run will produce slightly different results by chance otherwise

#tree <- rpart(OVEN ~YEAR+sLAT+sLONG+ComplexDecid+ComplexConif+SimpleProd+SimpleUnprod+NEAR_DIST_PIPELINE+NEAR_DIST_ANYROAD+NEAR_DIST_WELL+ NEAR_DIST_SEISMIC, data = birds, control = rpart.control(cp = 0.0001))
tree <- rpart(OVEN ~ComplexDecid+NEAR_DIST_PIPELINE, data = birds, control = rpart.control(cp = 0.0001))

#a simpler model will converge more quickly and produce a less complicated tree.

# Step2: Pick the tree size that minimizes misclassification rate (i.e. prediction error).
# Prediction error rate in training data = Root node error * rel error * 100%
# Prediction error rate in cross-validation = Root node error * xerror * 100%
# Hence we want the cp value (with a simpler tree) that minimizes the xerror. 
printcp(tree)#CP and cross-validation error decline with increasing number of splits

plot(tree)
text(tree, cex = 0.8, use.n = TRUE, xpd = TRUE)
#right now the tree is no more than a cloud at any node greater than
#the root node. The first split indicates the importantce of the amount 
#of complex deciduous forest in predicting Ovenbird abundance, which we
#expect, but that's it. We can't even see what abundance the tree predicts 
#from this first split.

# Clip a section of the tree for a closer look

#NOTE: THIS IS NOT THE SAME AS PRUNING A MODEL: THIS
#IS JUST SIMPLIFYING THE VISUAL OUTPUT

# The "prp" function is within the "rpart.plot" package, which you would have 
#already downloaded and called
new.tree.1 <- prp(tree,snip=TRUE)$obj # interactively trim the tree
#use the cursor to click on any branches that you want to get rid of,
#not the branches you want a closer look at.

prp(new.tree.1) # display the new tree
prp(new.tree.1, tweak=0.5)

# Clip a further section of the clipped section for a closer look
new.tree.2 <- prp(new.tree.1,snip=TRUE)$obj # interactively trim the tree
prp(new.tree.2) # display the new tree
prp(new.tree.2, tweak=0.5)

#by now you should be seeing that at each node there is a 
#condition to be met by all the observations assigned to that 
#node. The left branch from a node is for those observations
#that meet the condition while the right branch from the node
#is for observations that do not meet the condition.

#It appears that generally, the predicted number of Ovenbirds
#increases as the proportion of land within 150 m of point counts
#that is "Complex Deciduous" forest increases. Also generally,
#Ovenbirds seem to be predicted to increase as point counts get
#further away from the nearest pipeline.

bestcp <- tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"]
#The complexity parameter (cp) is used to control the size of the 
#decision tree and to select the optimal tree size. If the cost of 
#adding another variable to the decision tree from the current node 
#is above the value of cp, then tree building does not continue. 
#We could also say that tree construction does not continue unless 
#it would decrease the overall lack of fit by a factor of cp.

# Step3: Prune the tree using the best cp.
tree.pruned <- prune(tree, cp = bestcp)

#Misclassification rate = root node error * final xerror
#The tree has a misclassification rate of 0.99806 * 0.56251 * 100% ~ 55% in 
#cross-validation. 
#Once we do get a satisfactory tree, the pruned tree can 
#be used to produce confusion matrices and tree structure plots.

# confusion matrix (all data used, not just training data)
conf.matrix <- table(birds$OVEN, predict(tree.pruned,type="vector"))
rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep = ":")
colnames(conf.matrix) <- paste("Pred", colnames(conf.matrix), sep = ":")
print(conf.matrix)


plot(tree.pruned)
text(tree.pruned, cex = 0.8, use.n = TRUE, xpd = TRUE)

prp(tree.pruned, faclen = 0, cex = 0.8, extra = 1)#a nicer looking tree
# extra = 1 adds number of observations at each node; equivalent to using use.n = TRUE in plot.rpart

str(tree.pruned)
tree.pruned$frame
#the frame for "tree.pruned" provides some basic information about the pruned
#regression tree we plotted. Each observation in the data frame is for a 
#separate node in the tree, starting with the root node (node 1). Can you tell 
#which observation in the frame corresponds to which node in the tree?


# Clip a section of the tree for a closer look
new.tree.1 <- prp(tree.pruned,snip=TRUE)$obj # interactively trim the tree
prp(new.tree.1) # display the new tree


#rpart.plot is front end to the workhorse function called prp and
#can take prp's arguments to modify appearance of the tree
rpart.plot(tree.pruned, box.palette="auto")
rpart.plot(tree.pruned, box.palette=0)
rpart.plot(tree.pruned, box.palette="Grays")
rpart.plot(tree.pruned, box.palette="gray")
rpart.plot(tree.pruned, box.palette="Greens")
rpart.plot(tree.pruned, box.palette="Blues")
rpart.plot(tree.pruned, box.palette="Purples")
rpart.plot(tree.pruned, box.palette="Gy")
rpart.plot(tree.pruned, box.palette="Gn")
rpart.plot(tree.pruned, box.palette="BuGn")
rpart.plot(tree.pruned, box.palette="GnRd")
rpart.plot(tree.pruned, box.palette="RdGn")
rpart.plot(tree.pruned, box.palette="RdYlGn")

rpart.plot(tree.pruned, box.palette="red")

rpart.plot(tree.pruned, type=0)#default
rpart.plot(tree.pruned, type=1)#label all nodes
rpart.plot(tree.pruned, type=2)#split labels below node labels
rpart.plot(tree.pruned, type=3)#left and right split labels
rpart.plot(tree.pruned, type=4)#like type 3 but interior nodes have lables

rpart.plot(tree.pruned, extra=0)#default (mean predicted value)
rpart.plot(tree.pruned, extra=1)#nbr of obs
rpart.plot(tree.pruned, extra=100)#percentage of obs
rpart.plot(tree.pruned, extra=101)#number and percentage

rpart.plot(tree.pruned, tweak=1)
rpart.plot(tree.pruned, tweak=2)#make text size bigger

rpart.plot(tree.pruned)
rpart.plot(tree.pruned[1])

#Decision trees using boosted regression trees.
library(gbm)#I had trouble installing gbm through R Studio and downloaded the package from a CRAN mirror
library(dismo)#Boosted Regression Trees Using dismo package, which is more user friendly than but depends on "gbm"
gbm1b <- gbm.step(data=birds, gbm.x = c("YEAR","Y","X","ComplexDecid","ComplexConif","SimpleProd","NEAR_DIST_SEISMIC","NEAR_DIST_WELL","NEAR_DIST_PIPELINE","NEAR_DIST_ANYROAD"), gbm.y = c("OVEN"),
                            family = "poisson", offsets=c("OVENoff"), tree.complexity = 5,
                            learning.rate = 0.1, bag.fraction = 0.5)
#This next procedure can take a while to run. Increasing the learning rate can speed up the process, but the more variables you have
#the slower (smaller) you want your learning rate to be. The higher the tree complexity, the slower (smaller) you want your learning rate to be as well. 

# GBM STEP - version 2.9 

#Performing cross-validation optimisation of a boosted regression tree model 
#for NA and using a family of poisson 
#Using 14548 observations and 10 predictors 
#creating 10 initial models of 50 trees 

#folds are unstratified 
#total mean deviance =  1.4434 
#tolerance is fixed at  0.0014 
#ntrees resid. dev. 
#50    0.8025 
#now adding trees... 
#100   0.7718 
#150   0.7539 
#200   0.7402 
#.
#.
#.
#1400   0.705 
#1450   0.7047 
#1500   0.7055 
#fitting final gbm model with a fixed number of 1050 trees for NA

#mean total deviance = 1.443 
#mean residual deviance = 0.511 

#estimated cv deviance = 0.701 ; se = 0.009 

#training data correlation = 0.841 
#cv correlation =  0.676 ; se = 0.008 

#elapsed time -  0.07 minutes 

summary(gbm1b)
#var                                     rel.inf
#ComplexDecid             ComplexDecid 34.083682
#YEAR                             YEAR 14.147468
#sLONG                           sLONG 12.884167
#sLAT                             sLAT 11.781238
#NEAR_DIST_PIPELINE NEAR_DIST_PIPELINE  6.116207
#NEAR_DIST_SEISMIC   NEAR_DIST_SEISMIC  5.912766
#NEAR_DIST_ANYROAD   NEAR_DIST_ANYROAD  5.736713
#NEAR_DIST_WELL         NEAR_DIST_WELL  4.515968
#ComplexConif             ComplexConif  3.712833
#SimpleProd                 SimpleProd  1.108956

#the relative importance of different variables looks
#consistent with what I saw when running a basic
#regression tree using the rpart package


#To more broadly explore whether other settings perform better, and assuming
#that these are the only data available, you could either split the data into
#a training and testing set or use the cross-validation results. You could systematically
#alter tc, lr and the bag fraction and compare the results. See the
#later section on prediction to find out how to predict to independent data and
#calculate relevant statistics.

gbm1c <- gbm.simplify(gbm1b, n.drops = 5)
#gbm.simplify - version 2.9 
#simplifying gbm.step model for NA with 10 predictors and 14548 observations 
#original deviance = 0.7006(0.0095)
#a fixed number of 5 drops will be tested
#creating initial models...
#dropping predictor: 1 2 3 4 5
#processing final dropping of variables with full data
#1-SimpleProd
#2-ComplexConif
#3-NEAR_DIST_WELL
#4-NEAR_DIST_ANYROAD
#5-NEAR_DIST_SEISMIC

#Simple productive vegetative habitat doesn't seem to be 
#that important; removing it increases cp a little bit but
#not that much. As in the basic regression tree it looks
#like seismic lines, roads, wells have less of an impact
#than pipelines on Ovenbird abundance

gbm1d <- gbm.step(data=birds, gbm.x = gbm1c$pred.list[[2]], gbm.y = c("OVEN"),
                  family = "poisson", offsets=c("OVENoff"), tree.complexity = 5,
                  learning.rate = 0.1, bag.fraction = 0.5)
#1 less predictor 

#mean total deviance = 1.443 
#mean residual deviance = 0.54 

#estimated cv deviance = 0.726 ; se = 0.008 

#training data correlation = 0.83 
#cv correlation =  0.659 ; se = 0.006 

#slight decrease in accuracy

#elapsed time -  0.07 minutes 

#Plotting Fitted Values (Using original predictor set)
gbm.plot(gbm1b, n.plots=10, write.title = FALSE)
#plots the relationships of the response variable to each of the predictors
#Ovenbird abundance is predicted to increase as complex deciduous forest increases
#Ovenbird abundance is predicted to increase as nearest distance to pipelines increases
#Ovenbird abundance is predicted to increase as complex coniferous forest increases,
#though less dramatically than deciduous forest.

#also note that when all variables are plotted they are plotted top to bottom
#and left to right in order of importance

par(mfrow=c(1,2))
plot(gbm1b,i="ComplexDecid")
plot(gbm1b,i="YEAR")

par(mfrow=c(1,1))
plot(gbm1b,i="ComplexDecid")
#remember that there is no single final boosted regression tree and the relationships
#you see in the plots are averaged across all of the trees
#boosted regression trees are a kind of "ensemble model"


gbm.plot.fits(gbm1b)
# Values above each graph indicate the weighted mean of fitted values in relation to each non-factor predictor.

