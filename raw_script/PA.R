
# project raw script
if (file.exists("F:/machine_learning/assignments/project"))  {
  setwd("f:/machine_learning/assignments/project")
} else if (file.exists("E:/machine_learning/assignments/project")){
  setwd("e:/machine_learning/assignments/project")
} else {
  stop("no directory")
}

library(ggplot2)
library(caret)

pml <- read.csv("./raw_data/pml-training.csv")



# References
Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.
