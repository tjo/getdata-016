# Getting and Cleaning Data Course Project

## Overview

The provided script contains a set of functions that process the UCI HAR Dataset, to provide a tidy result set containing average of each measurement mean and standard deviations for each activity and each subject.

## Steps to run the project
1. Pull the data source from github.
2. Run ```source("run_analysis.R")```.
3. Change working directory using ```setwd()``` to a folder containing "UCI HAR Dataset".
4. Run ```clean_data()``` function, this will return the tidy data set.

## Dependencies
The script depends on ```reshape2``` package being installed and available.

If it's not installed, run ```install.packages("reshape2")```