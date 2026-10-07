% Import data Questions 1-3
[SubID, Age, Gender, Weight, Day1, Day2, Day3] = importfile('isok_data_6803.csv');

% Question 4, calling genderIsoCalc.m
[maleIsoIndMeans, femaleIsoIndMeans, maleGroupIsoMean, femaleGroupIsoMean] = ...
    genderIsoCalc (Gender, Day1, Day2, Day3);

% Question 5, calling dayComputer.m
[Day1toDay2] = dayComparer(SubID, Day1, Day2);
[Day2toDay3] = dayComparer(SubID, Day2, Day3);

% Question 6, weight normalize the isokinetic data and calculate the 
% group means for each day

% Normalize strength data for each day (1-3)
normalizeDay1 = Day1 ./Weight;
normalizeDay2 = Day2 ./Weight;
normalizeDay3 = Day3 ./Weight;

% Group normalized mean for each day
normalizeDay1mean = mean (normalizeDay1);
normalizeDay2mean = mean (normalizeDay2);
normalizeDay3mean = mean (normalizeDay3);

% Question 7, export your results to a csvfile using an appropriate built-in function

% Final results export


