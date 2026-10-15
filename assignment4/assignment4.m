
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
normDay1 = Day1 ./Weight;
normDay2 = Day2 ./Weight;
normDay3 = Day3 ./Weight;

% Group normalized mean for each day
normDay1mean = mean (normDay1);
normDay2mean = mean (normDay2);
normDay3mean = mean (normDay3);

% Question 7, export your results to a csvfile using an appropriate built-in function

% Create a cell array for each of the final results
results = {maleIsoIndMeans, femaleIsoIndMeans, maleGroupIsoMean, femaleGroupIsoMean, ...
    Day1toDay2, Day2toDay3, normDay1mean, normDay2mean, normDay3mean};

% Create titles for results to help identify each of the 9 final results 
headers = {'maleIsoIndMeans', 'femaleIsoIndMeans', 'maleGroupIsoMean', 'femaleGroupIsoMean', ...
    'Day1toDay2', 'Day2toDay3', 'normDay1mean', 'normDay2mean', 'normDay3mean'};

% Determine how many numbers the longest result has, make sure there are
% enough rows for all the results
maxLength = 0;

for resultNum = 1:length (results) 
    if numel (results{resultNum}) > maxLength
        maxLength = numel (results{resultNum});
    end
end

% Make a empty cell array that includes enough rows for the longest result,
% a additional row for the titles, and nine total columns for each of the
% results
output = cell(maxLength + 1, length(results));

% Put the tittles for each of the results in the first row
output(1, :) = headers;

% Fill each column with its correct results, values go into their spaces
% and the unfilled spaces stay empty
for resultNum = 1 :length(results)
    values = results{resultNum};
    output (2:numel(values) + 1, resultNum) = num2cell(values(:));
end

% Export results to a CSV file
writecell(output, 'iso_results.csv');





