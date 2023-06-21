UCI HAR Tidy Data
================

# Tidy Data Final Project

An exciting area in data science is wearable computing. Companies like
Fitbit, Nike, Apple, etc. are developing algorithms that attract new
users by the thousands.

In this project, data collected by Jorge L. Reyes-Ortiz, Davide Anguita,
Alessandro Ghio, Luca Oneto (2012) at Università degli Studi di Genova
was cleaned to demonstrate proficiency in data cleaning techniques. (see
<https://link.springer.com/chapter/10.1007/978-3-642-35395-6_30>)

## What’s in this repository?

The current repository contains the following files:

1.README.md file: Provides an overview of the data set obtained and the
tidy data set that I created with its accompanying code book, and R
script files.

2.The data set provided by the authors of the study: The data set
contains the test and training files for a group of 30 randomly
partitioned volunteers (30% test vs. 70% train group). Each volunteer
performed six activities (walking, walking upstairs, walking downstairs,
sitting, standing, and laying down) while wearing a smartphone device
(Samsung Galaxy S II). The measurements captured by the device were the
three dimensional axial acceleration and the three dimensional angular
velocity at a constant rate of 50Hz. These measurements were captured
every 2.56 seconds (one window of time) for a total of 128 readings per
window of time.These fixed-width windows were then transformed into a
vector of 561 features by calculating time and frequency variables. The
authors aimed to present a new system of human physical Activity
Recognition (AR) using smartphone inertial sensors that captured the
state of the user and its environment by tapping into the diverse
sensors within the smartphone device.

3.The tidy data set: A data set containing information for each of the
volunteers’ results on each of the six activities for 50 features.

4.The code book: Indicates all the variable names and summaries that
were calculated, along with units, and any other relevant information.

5.The R script: run_analysis.R contains the code for merging the
training and test data sets, and all the relevant transformations that
took place to create the tidy data set. The R script is divided into
sections to make it easily understandable.

## Questions?

Feel free to reach out to <jpmonteagudo2014@gmail.com>
