
# project raw script
if (file.exists("F:/machine_learning/assignments/ml_project"))  {
  setwd("f:/machine_learning/assignments/ml_project")
} else if (file.exists("E:/machine_learning/assignments/ml_project")){
  setwd("e:/machine_learning/assignments/ml_project")
} else {
  stop("no directory")
}

library(ggplot2); library(caret)

### Data Manipulation
# read the data
pml <- read.csv("./raw_data/pml-training.csv",stringsAsFactors=FALSE)

# eliminate variables with low variability 
# using the nearZeroVar function of the caret package
nz <- nearZeroVar(pml)
pml <- pml[,-nz]

# get rid of columns that are mostly NA
pml <- pml[,colSums(is.na(pml))/nrow(pml)<.9]

# get rid of user name and time related variables
pml <- pml[,-c(1:6)]

# make classe a factor variable
pml$classe <- factor(pml$classe)

# split data into training and test sets
inTrain <- createDataPartition(y=pml$classe,p=0.6, list=FALSE)
training <- pml[inTrain,]
testing <- pml[-inTrain,]

### Exploratory Analysis
# build boxplots for all variables 
#for (i in 1:ncol(training)){
#  p <- qplot(x=classe,y=training[,i],data=training,ylab=names(training[i]),geom="boxplot")
#    ggsave(paste("./exploratory_graphs/plot_",i,".png"))
#}

### Model training/building
#rfFit <- train(classe~ .,data=training,method="rf")
#rFit <- train(classe~ .,data=training,method="rpart")
#gbmFit <- train(classe ~ ., method="gbm",data=training,verbose=FALSE,tuneLength=5)
#rPred <- predict(rFit,newdata=testing)

library(randomForest)
rf.fit <- randomForest(classe ~., data=training,type="class")
rfpred <- predict(rf.fit,newdata=testing)
rf.fit
rf.table <- table(rfpred,testing$classe)
confusionMatrix(rf.table)
varImpPlot(rf.fit)

# References
1. Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.
2. Kuhn, Max Building Predictive Models in R Using the caret Package. Journal of Statistical Software. Vol. 28. November 2008.
