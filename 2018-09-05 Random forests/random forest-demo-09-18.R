if (!require(rpart)) install.packages('rpart') # DECISION TREE PACKAGE
library(rpart)
if (!require(rpart.plot)) install.packages('rpart.plot') # PLOTTING PACKAGE
library(rpart.plot)
if (!require(rattle)) install.packages('rattle') # PLOTTING PACKAGE
library(rattle)
if (!require(RColorBrewer)) install.packages('RColorBrewer') # PLOTTING PACKAGE
library(RColorBrewer)
if (!require(randomForest)) install.packages('randomForest') # RANDOM FOREST PACKAGE
library(randomForest)
if (!require(caret)) install.packages('caret') # ML SUPPORT PACKAGE
library(caret)
if (!require(tidyverse)) install.packages('tidyverse') # DATA MANIPULATION AND PLOTTING PACKAGE
library(tidyverse)

#set random seed for reproducability
set.seed(111)

#read in input data
setwd("~/spotlight seminar 06.09.18")

Sitrep_12_16 <- read_csv('Sitrep 12-16.csv') # 4 WINTERS OF SITREP DATA

Sitrep_16_17 <- read_csv('Sitrep 16-17.csv') # SITREP DATA FROM WITER 16-17


#creat (stratified) test/train splits
# ========================================================================== 

#  create index for test/train split
index <- createDataPartition(Sitrep_12_16$performanceny, # stratify according to performance in the next year
                             p = 0.8, # split 80:20
                             list = FALSE) 

Sitrep_12_16_train <- Sitrep_12_16[index,] # create training set

Sitrep_12_16_test <- Sitrep_12_16[-index,] # create test set

# confirm stratification
mean(Sitrep_12_16_train$performanceny)
mean(Sitrep_12_16_test$performanceny)

#USE WINTERS 12-16 TO TRAIN AND EVALUATE TREE AND FOREST
# ==========================================================================

tree <- rpart(performanceny~., # model formula
                Sitrep_12_16_train, # training data
                method = 'anova') # regesion tree 

fancyRpartPlot(tree) # visulize tree

forest <- randomForest(performanceny~., # model formula
                         Sitrep_12_16_train, # training data
                         ntree=1000, # 1000 tree forest
                         importance=TRUE)  # calculate variable importance

varImpPlot(forest) # visulize variable importance
importance(forest) # list variable importance

tree_p <- predict(tree,Sitrep_12_16_test) # make tree predictions
tree_error <- tree_p - Sitrep_12_16_test$performanceny # calculate tree error
rmse_tree <- sqrt(mean(tree_error^2)) # calculate tree RMSE

forest_p <- predict(forest,Sitrep_12_16_test) # make forest predictions
forest_error <- forest_p - Sitrep_12_16_test$performanceny # calculate forest error
rmse_forest <- sqrt(mean(forest_error^2)) # calculate forest RMSE



#TRAIN FINAL MODEL ON FULL DATASET (TRAIN + TEST) AND MAKE PREDICTIONS + PLOT SUMMARY
# ============================================================================================

forest_final <- randomForest(performanceny~.,
                               Sitrep_12_16,
                               ntree=1000,
                               importance=TRUE) # grow forest on all data



#MAKE FINAL PREDITIONS 
# =========================================================================================

predictions <- data.frame(trust_code = Sitrep_16_17$trust_code,
                          performance_16_17 = Sitrep_16_17$performancesy,
                          predictions_17_18 = predict(forest_final,Sitrep_16_17)) # make final predictions

write_csv(predictions,'predictions.csv')
