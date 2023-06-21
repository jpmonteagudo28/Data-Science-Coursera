---
title: "Code Book"
output: github_document
---

## Data Source

The data used in this project was obtained from [UC Irvine Machine Learning Repository](http://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones)

## The data set

There are 50 variables used in the human activity recognition (*humanAR_df* & *tidy_data*) data set. Except for the subject and activities variables(ordinal and categorical), the remaining 48 variables in the *tidy_data* file are quantitative and continuous and measure the average of the three-dimensional axial acceleration and the angular velocity at a constant rate of 50 Hz for each participant on six activities.

## Rationale

The features vector included 561 features measuring average, standard deviation, skewness,kurtosis, energy, entropy, range, correlation, angle, magnitude area, regression coefficients, and median. After filtering the mean and standard deviation variables, there were 79 possible variables to use in the *tidy_data* data set; however, I chose to use only 50 variables and ignore the remaining 29 variables that measured angle and magnitude as the authors did not specify the meaning of the magnitude component, and the angle component described the average signal between two vectors.

## The following list describes each variable used in the data set.

1.  Subject: number of volunteers (1-30) who participated in the study and performed each of the six activities assigned by the investigators.

2.  Activities: factor variable denoting the type of activities (1-6) assigned by the investigators. The activities are:

    1.  Walking
    2.  Walking Upstairs
    3.  Walking downstairs
    4.  Sitting
    5.  Standing
    6.  Laying

3.  All quantitative sensor signals (Accelerometer and Gyroscope) were obtained from Samsung smartphone devices, subdivided into time and frequency variables, and normalized and bounded within [-1,1].

    1.  All the time (*time\_*) variables denote 128 measurements captured within one window of time equivalent to 2.56 sec

    2.  All frequency (*freq\_*) variables denote a *discrete Fourier Transform* (DFT or FFT) performed on axial acceleration and angular velocity measurements. An FFT converts an acoustic signal into individual frequencies.

    3.  All variables containing *Accelerometer* are derived from the axial acceleration measurements and divided into a *Body* and *Gravity* components.

        i.  the *Body* component of the axial acceleration measurement refers to the dynamic acceleration or acceleration due to motion *(m/s^2^)*. It is calculated by subtracting the acceleration in each of the three-dimensional planes (X, Y, Z) from the gravity component in that plane.
        ii. the *Gravity* component refers to the force of gravity in *m/s^2^*, and assuming there's no rotation in the sensor of the smartphone device it should always point in the same direction.

    4.  The *Gyroscope* variables denote angular velocity *(rad/s)* in a three-dimensional plane. Angular velocity measures how fast an object rotates relative to its axis.

    5.  The *Jerk* variable denotes the rate of change of the acceleration with respect to time. In other words, jerk *(m/s^3^)* refers to the abruptness of changes in acceleration or how quickly things are speeding up or slowing down.

    6.  The *Mean* and *StDev.* components denote the average value of the variable or the standard deviation in the specific plane of motion (x,Y, or Z).

## Example

```{r}
library(knitr)
data <- humanAR_df[1:4,1:3]
knitr::kable(data, caption = "Snippet of human_AR data set")
```

| Subject | Activities         | **time_Body_Accelerometer_Mean.X** |
|---------|--------------------|------------------------------------|
| 1       | Walking            | 0.2773308                          |
| 1       | Walking_Upstairs   | 0.2554617                          |
| 1       | Walking_Downstairs | 0.2891883                          |

: **Snippet of humanAR data set**

The variable *(time_Body_Accelerometer_Mean.X)* refers to the average dynamic acceleration (*m/s^2^*) in a window of time for the specified activities.

```{r}
snippet <- humanAR_df[7:9,c(1,2,18)]
knitr::kable(snippet, caption = "Snippet showing time_Body_Accelerometer_Jerk_StDev.X")
```

| Subject | Activities         | **time_Body_Accelerometer_Jerk_StDev.X** |
|--------:|:-------------------|-----------------------------------------:|
|       2 | Walking            |                               -0.2775305 |
|       2 | Walking_Upstairs   |                               -0.2761219 |
|       2 | Walking_Downstairs |                                0.1472491 |

: **Snippet showing time_Body_Accelerometer_Jerk_StDev.X**

The variable *(time_Body_Accelerometer_Jerk_StDev.X)* refers to the average standard deviation of the change in dynamic acceleration (*m/s^3^*) with respect to time in one window of time for the specified activities.
