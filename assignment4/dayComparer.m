function [increasedIDs] = dayComparer (SubjectID, firstDay, secondDay)
% This function takes the subject ids and two days as inputs and 
% returns a matrix with the subject IDs of the subjects who had an 
% increase from the first day to the second day.

% Those whos strength increased from day1 to day2
increased = secondDay > firstDay;

% IDs for those that had a increase
increasedIDs = SubjectID (increased);

end


