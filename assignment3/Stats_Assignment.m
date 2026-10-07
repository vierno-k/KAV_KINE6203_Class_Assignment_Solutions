% Load the data from the NFL Combine and pro day data file
% using the read table tool.

data = readtable ('NFL Combine and pro day data (1987 - 2021).csv');

% View a summary of the data in the table using the summary 
% function. 

summary (data)

% Calculate summary statistics for the timed variables in the
% database using appropriate functions. (Shuttle, 40, 3 cone)

forty = data.("x40Yard");
shuttle = data.Shuttle;
threeCone = data.("x3Cone");

% Calculating the Mean

meanForty = mean(forty, 'omitnan');
meanShuttle = mean(shuttle, 'omitnan');
meanThreeCone = mean(threeCone, 'omitnan');

% Standard Deviation

stdForty = std(forty, 'omitnan');
stdShuttle = std(shuttle, 'omitnan');
stdThreeCone = std(threeCone, 'omitnan');

% Median

medianForty = median(forty, 'omitnan');
medianShuttle = median(shuttle, 'omitnan');
medianThreeCone = median(threeCone, 'omitnan'); 

% Create a histogram showing all three distributions for these
% timed variables. Make sure to label your figure and add a legend. 

figure

histogram(forty) 
hold on 

histogram(shuttle)
histogram(threeCone)

xlabel('Time (seconds)')
ylabel('Frquency')
title('NFL Combine Timed Events')
legend('40 Yard Dash', 'Shuttle', '3 Cone')

hold off

% Create a scatter plot in a new figure showing the relationship 
% between 40 yard dash performance and shuttle time).

figure
scatter(forty, shuttle)

xlabel('40 Yard Dash Time (seconds)');
ylabel('Shuttle Time (seconds)');
title('40 Yard Dash vs. Shuttle Time');

% Calculate the correlation coefficient between these two variables.

corrcoef(forty, shuttle, 'Rows', 'complete')

% If your correlation coefficient indicates a strong relationship,
% fit a linear model to your data and calculate the coefficient of
% variation (r-squared). Plot your model on your scatterplot. 

model = fitlm(forty, shuttle);

rSquared = model.Rsquared.Ordinary;

hold on
plot(model)
hold off

% Run a t-test to determine if there is a difference in means between
% the 40 yard dash and the shuttle run. 

[h,p] = ttest (forty, shuttle);
