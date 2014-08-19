
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
set.seed(77)
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
knn.fit <- train(classe ~.,data=training,method="knn")
knnpred <- predict(knn.fit,newdata=testing)
confusionMatrix(table(knnpred,testing$classe))

library(randomForest)
rf.fit <- randomForest(classe ~., data=training,type="class")
rfpred <- predict(rf.fit,newdata=testing)
rf.fit
confusionMatrix(table(rf.fit$predicted,training$classe))
confusionMatrix(table(rfpred,testing$classe))
vi <- varImp(rf.fit)
varImpPlot(rf.fit)

# submission
pml.test <- read.csv("./raw_data/pml-testing.csv",stringsAsFactors=FALSE)
answers <- predict(rf.fit,newdata=pml.test)

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("./answers/problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(answers)
# References
1. Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.
2. Kuhn, Max Building Predictive Models in R Using the caret Package. Journal of Statistical Software. Vol. 28. November 2008.
3. Breiman, L; Cutler, A; Random Forests. http://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm