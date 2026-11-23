
%%%%% Swimming Kickstart Performance Analysis %%%%%
% MATLAB Final Project
%
% Purpose:
% This program analyzes simulated swimming kickstart data to
% investigate relationships between rear-leg tibia length,
% rear-leg maximal knee extension torque, and the time
% required to reach the 5 m marker across different
% starting block back plate positions.
%
% Each swimmer performs 3 trials at 3 back plate positions:
% Forward, Preferred, and Backward.
%
% The program will calculate each swimmer's mean time to
% reach the 5 m marker at each back plate position,
% differences in mean times between positions, and
% correlations with tibia length and rear-leg knee
% extension torque.
 
clear;
clc;
close all;

%%%%% Section 1: Import and Validate Data %%%%%
% This section imports the Excel spreadsheet containing
% the simulated swimmers' tibia lengths, rear-leg peak
% knee extension torque measurements, individual 5 m
% start times, and trial information.
%
% The program checks that the Excel file exists before
% attempting to import the data.

% Name of the Excel file containing the simulated data
fileName = 'Swimming_Kickstart_Sample_Data_25_Swimmers.xlsx';

% Check whether the Excel file exists in the current folder
if ~isfile(fileName)
    error('Excel data file was not found.');
end

% Import the Excel spreadsheet into a MATLAB table
swimmerData = readtable(fileName);

% Display the imported data in the Command Window
disp('Imported Swimming Kickstart Data:');
disp(swimmerData);


%%%%% Section 2: Verify Required Columns %%%%%
% This section checks whether the imported spreadsheet
% contains all five columns required for the analysis.
%
% Checking the column names helps prevent errors caused
% by missing or incorrectly labeled measurements.

% Identify the five required columns
requiredColumns = {'SwimmerID', 'TibiaLength_cm', ...
    'RearTorque_Nm', 'StartTime_s', 'Trial'};

% Compare the required columns with the imported column names
columnsPresent = ismember(requiredColumns, ...
    swimmerData.Properties.VariableNames);

% Stop the program if any required columns are missing
if ~all(columnsPresent)

    % Identify which required columns are missing
    missingColumns = requiredColumns(~columnsPresent);

    % Display the missing column names
    disp('Missing required columns:');
    disp(missingColumns);

    % Stop the program to prevent incorrect calculations
    error('The spreadsheet is missing required columns.');
end

% Confirm that all five columns are available
disp('All required columns are present.');


%%%%% Section 3: Check Measurement Values %%%%%
% This section checks the three numerical measurement
% columns: tibia length, rear-leg knee extension torque,
% and time to reach the 5 m marker.
%
% All measurements should contain positive numeric values.
% Missing, infinite, zero, or negative measurements will
% cause the program to stop and display an error message.
%
% This prevents invalid measurements from being included
% in the performance and correlation calculations.

% Identify the three numerical measurement columns
measurementColumns = {'TibiaLength_cm', ...
    'RearTorque_Nm', 'StartTime_s'};

% Loop through each measurement column to check its values
for i = 1:length(measurementColumns)

    % Identify the current measurement column
    columnName = measurementColumns{i};

    % Extract the values from the current column
    values = swimmerData.(columnName);

    % Check whether the measurements are numeric
    if ~isnumeric(values)
        error('Column %s must contain numeric values.', columnName);
    end

    % Check for missing, infinite, zero, or negative values
    if any(~isfinite(values) | values <= 0)
        error('Column %s contains missing or invalid values.', columnName);
    end

end

% Confirm that all numerical measurements passed validation
disp('All numeric measurements passed validation.');

% Notify the user that importing and validation are complete
disp('Data import and validation completed successfully.');


%%%%% Section 4: Identify Individual Swimmers %%%%%
% This section identifies each unique swimmer in the
% imported Excel spreadsheet.
%
% Each swimmer will be analyzed separately so that
% individual differences in 5 m start times are preserved.

% Find the unique swimmer IDs in the dataset
swimmerIDs = unique(string(swimmerData.SwimmerID));

% Determine the total number of swimmers
numSwimmers = length(swimmerIDs);

% Display the number of swimmers in the Command Window
fprintf('Number of swimmers identified: %d\n', numSwimmers);


%%%%% Section 5: Calculate Mean 5 m Start Times %%%%%
% This section calculates the mean time required to reach
% the 5 m marker for each swimmer at each back plate position.
%
% The three positions are Forward, Preferred, and Backward.
% Each position should contain three trials.
%
% A for loop is used to repeat these calculations for
% every swimmer in the dataset.

% Create arrays to store each swimmer's mean start times
forwardMean = zeros(numSwimmers, 1);
preferredMean = zeros(numSwimmers, 1);
backwardMean = zeros(numSwimmers, 1);

% Convert trial labels to strings for easier comparison
trialLabels = string(swimmerData.Trial);

% Loop through every swimmer in the dataset
for i = 1:numSwimmers

    % Identify the swimmer currently being analyzed
    currentSwimmer = swimmerIDs(i);

    % Find all rows belonging to the current swimmer
    swimmerRows = string(swimmerData.SwimmerID) == currentSwimmer;

    % Identify the three trials at each back plate position
    forwardRows = swimmerRows & startsWith(trialLabels, "Forward_");
    preferredRows = swimmerRows & startsWith(trialLabels, "Preferred_");
    backwardRows = swimmerRows & startsWith(trialLabels, "Backward_");

    % Verify that the swimmer has three trials at each position
    if sum(forwardRows) ~= 3 || sum(preferredRows) ~= 3 || ...
            sum(backwardRows) ~= 3

        error('Swimmer %s does not have 3 trials at each position.', ...
            char(currentSwimmer));
    end

    % Calculate the mean 5 m start time for each position
    forwardMean(i) = mean(swimmerData.StartTime_s(forwardRows));
    preferredMean(i) = mean(swimmerData.StartTime_s(preferredRows));
    backwardMean(i) = mean(swimmerData.StartTime_s(backwardRows));

end


%%%%% Section 6: Organize Mean Start Times into a Table %%%%%
% This section creates a summary table containing
% each swimmer's mean time to reach the 5 m marker
% at the three back plate positions.
%
% This table will be used later to calculate performance
% differences relative to each swimmer's preferred position.

% Create a table containing the swimmer IDs and mean times
meanTimeTable = table(swimmerIDs, forwardMean, preferredMean, ...
    backwardMean, 'VariableNames', ...
    {'SwimmerID', 'ForwardMean_s', 'PreferredMean_s', ...
    'BackwardMean_s'});

% Display the completed table in the Command Window
disp('Mean 5 m Start Times for Each Swimmer:');
disp(meanTimeTable);

% Confirm that the calculations are complete
disp('Individual swimmer mean start times calculated successfully.');


%%% Section 7: Calculate Performance Differences Using Custom Function %%%
% This section uses a custom function called
% calculatePerformanceDifferences to compare the mean 5 m start times
% at different back plate positions.
%
% The function receives three inputs:
%   1. forwardMean   - Mean start times at the forward position
%   2. preferredMean - Mean start times at the preferred position
%   3. backwardMean  - Mean start times at the backward position
%
% The function produces two outputs:
%   1. forwardDifference  - Forward mean minus preferred mean
%   2. backwardDifference - Backward mean minus preferred mean
%
% A positive difference indicates that the swimmer was slower
% compared to their preferred back plate position.
%
% A negative difference indicates that the swimmer was faster
% compared to their preferred back plate position.
%
% Using a custom function makes this calculation reusable
% and keeps the main script more organized.

% Call the custom function using the three mean time arrays.
[forwardDifference, backwardDifference] = ...
    calculatePerformanceDifferences(forwardMean, preferredMean, backwardMean);

% Display a message confirming that the calculation is complete.
disp('Performance differences calculated using custom function.');


%%%%% Section 8: Add Performance Differences to Summary Table %%%%%
% This section adds the calculated performance differences
% to the meanTimeTable created in Part 2.
%
% Each row still represents one individual swimmer.
% This allows us to preserve individual responses
% to changes in back plate positioning.

% Add forward performance differences to the summary table
meanTimeTable.ForwardDifference_s = forwardDifference;

% Add backward performance differences to the summary table
meanTimeTable.BackwardDifference_s = backwardDifference;

% Display the updated summary table
disp('Mean 5 m Start Times and Performance Differences:');
disp(meanTimeTable);


%%%%% Section 9: Check Performance Difference Calculations %%%%%
% This section verifies that the performance differences
% were calculated correctly.
%
% The program checks whether adding each calculated
% difference to the preferred mean reproduces the
% corresponding forward or backward mean.
%
% A small tolerance accounts for floating-point rounding
% when MATLAB performs calculations with decimal numbers.

% Set the acceptable numerical difference
tolerance = 1e-10;

% Check the forward performance differences
forwardCheck = abs((preferredMean + forwardDifference) ...
    - forwardMean);

% Check the backward performance differences
backwardCheck = abs((preferredMean + backwardDifference) ...
    - backwardMean);

% Stop the program if a calculation fails the check
if any(forwardCheck > tolerance) || ...
        any(backwardCheck > tolerance)

    error('Performance difference calculation check failed.');

end

% Display confirmation that the calculations passed
disp('Performance difference calculations passed the check.');


%%%%% Section 10: Organize Tibia Length and Rear-Leg Torque %%%%%
% This section extracts each swimmer's rear-leg tibia
% length and maximal isometric knee extension torque.
%
% These measurements are already included in the Excel
% spreadsheet and do not need to be calculated by MATLAB.
%
% Since each swimmer has 9 kickstart trials, their tibia
% length and rear-leg torque appear multiple times in
% the original dataset.
%
% The goal is to obtain one tibia length and one rear-leg
% torque measurement for each swimmer.
%
% A for loop is used to organize these measurements
% separately for every swimmer.

% Create arrays to store each swimmer's measurements
tibiaLength = zeros(numSwimmers, 1);
rearTorque = zeros(numSwimmers, 1);

% Loop through each swimmer identified in Part 2
for i = 1:numSwimmers

    % Identify the current swimmer
    currentSwimmer = swimmerIDs(i);

    % Find all rows belonging to this swimmer
    swimmerRows = string(swimmerData.SwimmerID) == currentSwimmer;

    % Extract the swimmer's tibia length measurements
    currentTibia = swimmerData.TibiaLength_cm(swimmerRows);

    % Extract the swimmer's rear-leg torque measurements
    currentTorque = swimmerData.RearTorque_Nm(swimmerRows);

    % Check that tibia length is consistent across all
    % trials belonging to the same swimmer
    if any(currentTibia ~= currentTibia(1))
        error('Inconsistent tibia length for swimmer %s.', ...
            char(currentSwimmer));
    end

    % Check that rear-leg torque is consistent across all
    % trials belonging to the same swimmer
    if any(currentTorque ~= currentTorque(1))
        error('Inconsistent rear-leg torque for swimmer %s.', ...
            char(currentSwimmer));
    end

    % Store one tibia length measurement for this swimmer
    tibiaLength(i) = currentTibia(1);

    % Store one rear-leg torque measurement for this swimmer
    rearTorque(i) = currentTorque(1);

end

% Confirm that the measurements have been organized
disp('Tibia length and rear-leg torque organized successfully.');

%%%%% Section 11: Add Physical Measurements to Summary Table %%%%%
% This section adds each swimmer's tibia length and
% rear-leg torque to the summary table created earlier.
%
% The table now combines physical measurements with
% mean 5 m start times and performance differences.
%
% Each row represents one swimmer rather than one
% individual kickstart trial.

% Add tibia length to the summary table
meanTimeTable.TibiaLength_cm = tibiaLength;

% Add rear-leg torque to the summary table
meanTimeTable.RearTorque_Nm = rearTorque;

% Display the updated table in the Command Window
disp('Complete Swimmer Performance and Measurement Summary:');
disp(meanTimeTable);

% Confirm that the summary table is complete
disp('Physical measurements added to summary table successfully.');


%%%%% Section 12: Introduction to Calculate Correlations Between Variables %%%%%
% This section investigates relationships between the
% swimmers' physical characteristics and changes in the
% time required to reach the 5 m marker.
%
% The two physical characteristics are:
% 1. Rear-leg tibia length (cm)
% 2. Rear-leg maximal isometric knee extension torque (N*m)
%
% These measurements will be compared with the differences
% in mean 5 m start times between:
% 1. Forward and Preferred back plate positions
% 2. Backward and Preferred back plate positions
%
% Pearson correlation coefficients are calculated using
% MATLAB's built-in corrcoef function.
%
% Correlations range from -1 to +1 and describe the
% direction and strength of linear relationships.
%
% Because the dataset contains 25 simulated swimmers,
% the correlation results are intended to demonstrate
% and verify the program's analysis capabilities.
% They should not be interpreted as actual research findings.


%%%%% Section 13: Check Data Before Correlation Analysis %%%%%
% Pearson correlations require at least two observations
% and variation in both variables.
%
% For this project, we require at least 3 swimmers so the
% analysis is not based on only 2 data points.
%
% The program will stop if the sample is too small or if
% one of the variables contains identical values for
% every swimmer.

% Check whether at least three swimmers are available
if numSwimmers < 3
    error('At least 3 swimmers are required for this analysis.');
end

% Check whether each variable contains variation
variablesToCheck = {tibiaLength, rearTorque, ...
    forwardDifference, backwardDifference};

variableNames = {'Tibia Length', 'Rear-Leg Torque', ...
    'Forward Difference', 'Backward Difference'};

% Loop through the variables to check their variability
for i = 1:length(variablesToCheck)

    % Get the current variable
    currentValues = variablesToCheck{i};

    % Check whether every value is identical
    if all(currentValues == currentValues(1))
        error('No variation in %s. Correlation cannot be calculated.', ...
            variableNames{i});
    end

end

disp('Data passed the correlation analysis checks.');


%%%%% Section 14: Calculate Pearson Correlation Coefficients %%%%%
% The corrcoef function returns a correlation matrix.
%
% When two variables are provided, the value in row 1,
% column 2 represents their Pearson correlation coefficient.
%
% Four correlations will be calculated:
% Tibia length vs. forward difference
% Tibia length vs. backward difference
% Rear torque vs. forward difference
% Rear torque vs. backward difference

% Tibia length and forward performance difference
R_tibiaForward = corrcoef(tibiaLength, forwardDifference);
r_tibiaForward = R_tibiaForward(1, 2);

% Tibia length and backward performance difference
R_tibiaBackward = corrcoef(tibiaLength, backwardDifference);
r_tibiaBackward = R_tibiaBackward(1, 2);

% Rear-leg torque and forward performance difference
R_torqueForward = corrcoef(rearTorque, forwardDifference);
r_torqueForward = R_torqueForward(1, 2);

% Rear-leg torque and backward performance difference
R_torqueBackward = corrcoef(rearTorque, backwardDifference);
r_torqueBackward = R_torqueBackward(1, 2);


%%%%% Section 15: Organize Correlation Results %%%%%
% This section stores the four calculated correlations
% in a table so they can be easily reviewed and
% eventually exported to a separate results file.

% Identify the relationships being analyzed
relationshipNames = [
    "Tibia Length vs Forward Difference"
    "Tibia Length vs Backward Difference"
    "Rear Torque vs Forward Difference"
    "Rear Torque vs Backward Difference"
];

% Combine the four correlation coefficients
correlationValues = [
    r_tibiaForward
    r_tibiaBackward
    r_torqueForward
    r_torqueBackward
];

% Create a table containing the correlation results
correlationTable = table(relationshipNames, correlationValues, ...
    'VariableNames', {'Relationship', 'Pearson_r'});

% Display the correlation results in the Command Window
disp('Pearson Correlation Results:');
disp(correlationTable);

% Confirm that the correlation analysis is complete
disp('Correlation analysis completed successfully.');


%%%%% Section 16: Prepare Data for Scatterplots %%%%%
% This section organizes the variables needed to create
% scatterplots showing relationships between the swimmers'
% physical measurements and their changes in 5 m start time.
%
% Four plots will be created:
% 1. Tibia length vs. forward performance difference
% 2. Tibia length vs. backward performance difference
% 3. Rear-leg torque vs. forward performance difference
% 4. Rear-leg torque vs. backward performance difference
%
% Each point represents one swimmer.

% Store the independent variables (X-axis data)
xData = {tibiaLength, tibiaLength, rearTorque, rearTorque};

% Store the dependent variables (Y-axis data)
yData = {forwardDifference, backwardDifference, ...
    forwardDifference, backwardDifference};

% Create labels describing each X-axis variable
xLabels = {'Rear-Leg Tibia Length (cm)', ...
    'Rear-Leg Tibia Length (cm)', ...
    'Rear-Leg Peak Knee Extension Torque (N*m)', ...
    'Rear-Leg Peak Knee Extension Torque (N*m)'};

% Create labels describing each Y-axis variable
yLabels = {'Forward - Preferred Time Difference (s)', ...
    'Backward - Preferred Time Difference (s)', ...
    'Forward - Preferred Time Difference (s)', ...
    'Backward - Preferred Time Difference (s)'};

% Identify the titles for the four scatterplots
plotTitles = {'Tibia Length vs. Forward Difference', ...
    'Tibia Length vs. Backward Difference', ...
    'Rear-Leg Torque vs. Forward Difference', ...
    'Rear-Leg Torque vs. Backward Difference'};

% Store the previously calculated Pearson correlations
rValues = [r_tibiaForward, r_tibiaBackward, ...
    r_torqueForward, r_torqueBackward];

% Choose brighter, easy-to-distinguish colors for each plot
plotColors = [
    0.0000 0.4470 0.7410   % bright blue
    0.8500 0.3250 0.0980   % orange
    0.4660 0.6740 0.1880   % green
    0.4940 0.1840 0.5560   % purple
];


%%%%% Section 17: Create the Scatterplots %%%%%
% This section creates four scatterplots showing the
% relationships between physical measurements and changes
% in the time required to reach the 5 m marker.
%
% All titles, labels, numbers, and text will appear
% in bold black font for better readability.
%
% Each scatterplot will have a different marker color.

% Open a new figure with a white background
figure('Name', 'Swimming Kickstart Correlation Plots', ...
    'Color', 'w', ...
    'Position', [100, 100, 1200, 800]);

% Arrange the four scatterplots in a 2-by-2 layout
tiledlayout(2, 2, 'TileSpacing', 'loose', ...
    'Padding', 'loose');

% Loop through the four relationships
for i = 1:4

    % Select the next plotting area
    nexttile;

    % Extract the current X and Y values
    currentX = xData{i};
    currentY = yData{i};

    % Create the scatterplot using the assigned color
    scatter(currentX, currentY, 90, ...
        'MarkerFaceColor', plotColors(i, :), ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1.0);

    hold on;

    % Add the dashed reference line at zero seconds
    % This represents no difference from preferred position
    yline(0, '--k', 'LineWidth', 1.5);

    % Add a best-fit line using linear regression
    p = polyfit(currentX, currentY, 1);
    xFit = linspace(min(currentX), max(currentX), 100);
    yFit = polyval(p, xFit);

    plot(xFit, yFit, ...
        'Color', plotColors(i, :), ...
        'LineWidth', 2);

    % Add bold black X-axis label
    xlabel(xLabels{i}, ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', 'k');

    % Add bold black Y-axis label
    ylabel(yLabels{i}, ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', 'k');

    % Add bold black title
    title(plotTitles{i}, ...
        'FontSize', 13, ...
        'FontWeight', 'bold', ...
        'Color', 'k');

    % Set all axis numbers and tick marks to bold black
    ax = gca;

    ax.Color = 'w';
    ax.XColor = 'k';
    ax.YColor = 'k';
    ax.FontSize = 11;
    ax.FontWeight = 'bold';
    ax.LineWidth = 1.2;
    ax.Box = 'on';

    % Add spacing around the points
    xRange = max(currentX) - min(currentX);
    yRange = max(currentY) - min(currentY);

    if xRange == 0
        xPad = 1;
    else
        xPad = 0.08 * xRange;
    end

    if yRange == 0
        yPad = 0.05;
    else
        yPad = 0.20 * yRange;
    end

    xlim([min(currentX) - xPad, max(currentX) + xPad]);
    ylim([min(currentY) - yPad, max(currentY) + yPad]);

    % Display Pearson correlation coefficient in bold black
    correlationText = sprintf('Pearson r = %.3f', rValues(i));

    text(0.05, 0.92, correlationText, ...
        'Units', 'normalized', ...
        'FontSize', 11, ...
        'FontWeight', 'bold', ...
        'Color', 'k', ...
        'BackgroundColor', 'w', ...
        'EdgeColor', 'k', ...
        'Margin', 4, ...
        'VerticalAlignment', 'top');

    % Add a label explaining the reference line
    text(0.05, 0.82, ...
        'Dashed line = preferred reference', ...
        'Units', 'normalized', ...
        'FontSize', 9, ...
        'FontWeight', 'bold', ...
        'Color', 'k', ...
        'BackgroundColor', 'w', ...
        'VerticalAlignment', 'top');

    % Add grid lines
    grid on;

    hold off;

end

% Add an overall bold black figure title
sgtitle('Simulated Swimming Kickstart Performance Relationships', ...
    'FontSize', 16, ...
    'FontWeight', 'bold', ...
    'Color', 'k');

% Confirm that all graphs were created
disp('All four correlation scatterplots created successfully.');


%%%%% Section 18: Create Main Results Folder %%%%%
% This section creates a folder where MATLAB will save
% all results from the swimming kickstart analysis.
%
% The folder will contain:
% 1. A summary of all swimmers
% 2. The correlation results
% 3. The four correlation scatterplots
% 4. Individual folders for each swimmer
%
% If the results folder already exists, MATLAB will
% use the existing folder rather than creating another.

% Identify the name and location of the results folder
resultsFolder = fullfile(pwd, 'Swimming_Kickstart_Results');

% Check whether the results folder already exists
if ~isfolder(resultsFolder)

    % Create the folder if it does not exist
    mkdir(resultsFolder);

end

% Confirm the results folder is available
disp('Main results folder is ready.');

%%%%% Section 19: Save Overall Analysis Results %%%%%
% This section exports the summary table containing each
% swimmer's mean 5 m start times, performance differences,
% tibia length, and rear-leg knee extension torque.
%
% It also saves the Pearson correlation results and
% the figure containing all four scatterplots.

% Create the full file path for the swimmer summary
summaryFile = fullfile(resultsFolder, ...
    'All_Swimmers_Summary.csv');

% Save the swimmer summary table as a CSV file
writetable(meanTimeTable, summaryFile);

% Create the full file path for the correlation results
correlationFile = fullfile(resultsFolder, ...
    'Correlation_Results.csv');

% Save the Pearson correlation results as a CSV file
writetable(correlationTable, correlationFile);

% Create the full file path for the scatterplot figure
figureFile = fullfile(resultsFolder, ...
    'Correlation_Plots.png');

% Save the current scatterplot figure as an image
saveas(gcf, figureFile);

% Confirm that the overall results have been saved
disp('Overall swimmer results and correlation plots saved.');

%%%%% Section 20: Create Individual Swimmer Folders %%%%%
% This section automatically organizes each swimmer's
% data into their own folder.
%
% A for loop is used to repeat this process for every
% swimmer identified earlier in the program.
%
% Each folder will contain:
% 1. All 9 original kickstart trials for that swimmer
% 2. Their mean 5 m start times and performance differences
% 3. Their tibia length and rear-leg peak torque
%
% This allows individual swimmer results to be accessed
% without manually separating the original spreadsheet.

% Loop through each swimmer in the dataset
for i = 1:numSwimmers

    % Identify the swimmer currently being processed
    currentSwimmer = swimmerIDs(i);

    % Convert the swimmer ID to text for file naming
    swimmerName = char(currentSwimmer);

    % Ensure the swimmer ID is safe to use as a folder name
    if ~all(isstrprop(swimmerName, 'alphanum') | ...
            swimmerName == '_')

        error('Swimmer ID contains invalid folder name characters.');

    end

    % Create the full path for the swimmer's folder
    swimmerFolder = fullfile(resultsFolder, swimmerName);

    % Check whether the swimmer's folder already exists
    if ~isfolder(swimmerFolder)

        % Create the folder if it does not exist
        mkdir(swimmerFolder);

    end

    %% Extract Individual Swimmer Data
    % Find all original trials belonging to this swimmer.

    swimmerRows = string(swimmerData.SwimmerID) == ...
        currentSwimmer;

    % Extract the swimmer's original trial measurements
    individualTrials = swimmerData(swimmerRows, :);

    % Extract their row from the completed summary table
    individualSummary = meanTimeTable(i, :);

    %% Save Individual Swimmer Results
    % Save the original trials and calculated summary
    % as two separate CSV files within the swimmer's folder.

    % Identify the filename for the original trial data
    trialFile = fullfile(swimmerFolder, ...
        [swimmerName '_Trials.csv']);

    % Save the swimmer's individual trials
    writetable(individualTrials, trialFile);

    % Identify the filename for the summary data
    swimmerSummaryFile = fullfile(swimmerFolder, ...
        [swimmerName '_Summary.csv']);

    % Save the swimmer's calculated summary results
    writetable(individualSummary, swimmerSummaryFile);

    % Display which swimmer has been processed
    fprintf('Saved results for swimmer %s.\n', swimmerName);

end

%%%%% Section 21: Confirm Results Have Been Saved %%%%%
% This section informs the user that the analysis
% results have been successfully exported.
%
% The folder location is displayed so the files
% can be opened and reviewed.

disp('All swimmer folders created successfully.');
disp('Swimming kickstart analysis results saved.');

% Display the location of the saved files
fprintf('Results saved in: %s\n', resultsFolder);
