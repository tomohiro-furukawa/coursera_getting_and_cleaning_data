run_analysis <- function() {
    ### step 1: merges data set to create one data set
    # read train files into data frames
    trainSubject <- read.table( "UCI HAR Dataset/train/subject_train.txt" )
    trainY <- read.table( "UCI HAR Dataset/train/y_train.txt" )
    trainX <- read.table( "UCI HAR Dataset/train/X_train.txt" )
    
    # horizontally merge 3 train data frames into 1 data frame
    # (in an order of (subject, activity, features))
    train <- cbind( trainSubject, trainY, trainX )
    
    # read test files into data frames
    testSubject <- read.table( "UCI HAR Dataset/test/subject_test.txt" )
    testY <- read.table( "UCI HAR Dataset/test/y_test.txt" )
    testX <- read.table( "UCI HAR Dataset/test/X_test.txt" )
    
    # horizontally merge 3 test data frames into 1 data frame
    # (in an order of (subject, activity, features))
    test <- cbind( testSubject, testY, testX )
    
    # vertically merge train and test data frames into 1 data frame
    data <- rbind( train, test )
    
    ### step 2: extracts means and standard deviations
    features <- read.table( "UCI HAR Dataset/features.txt", stringsAsFactors = FALSE )
    meanStdIndices <- grep( "mean()|meanFreq()|std()|Mean", features[, 2] )
    data <- data[, c( 1, 2, meanStdIndices + 2 )]
    
    ### step 3: replace with descriptive activity names
    activities <- read.table( "UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE )
    data[, 2] <- factor( activities[, 2][data[, 2]], levels = activities[, 2] )
    
    ### step 4: labels the data set with descriptive variable names
    names( data ) <- c( "subject", "activity", features[meanStdIndices, 2] )
    
    ### step 5: creates a second data set with average values for each activity/subject
    data2 <- data %>% group_by( subject, activity ) %>% summarize_each( funs( mean ) )
    data2
}
