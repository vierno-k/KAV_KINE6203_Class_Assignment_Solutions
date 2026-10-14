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

% Final results in cell array
results = {maleIsoIndMeans, femaleIsoIndMeans, maleGroupIsoMean, femaleGroupIsoMean...
    Day1toDay2, Day2toDay3, normDay1mean, normDay2mean, normDay3mean};

% Headers for results 
headers = {'maleIsoIndMeans', 'femaleIsoIndMeans', 'maleGroupIsoMean', 'femaleGroupIsoMean', ...
    'Day1toDay2', 'Day2toDay3', 'normDay1mean', 'normDay2mean', 'normDay3mean'};

% Length of longest final result
maxLength = 0;

for resultNum = 1:length (results) 
    if numel (results{resultNum}) > maxLength
        maxLength = numel (results{resultNum});
    end
end

% Output- empty cell array
output = cell(maxLength + 1, length(results));

% First row column headers
output(1, :) = headers;

% Filling each column with its correct results
for resultNum = 1 :length(results)
    values = results{resultNum};
    output (2:numel(values) + 1, resultNum) = num2cell(values(:));
end

% Export results to a CSV file
writecell(output, 'isokinetic_results.csv');





