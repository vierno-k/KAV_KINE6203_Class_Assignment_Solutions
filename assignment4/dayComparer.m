function [increasedIDs] = dayComparer (SubjectID, firstDay, secondDay)
% This function takes the subject ids and two separate days (first and second) as 
% inputs and returns a matrix with the subject IDs of those who had an 
% increase from the first day to the second day.
%   Inputs:
% SubjectID- a vector that represents the unique identification number for
% each of the athletes.
% firstDay- a vector that includes each of the athletes strength values
% collected from the first day of testing.
% secondDay- a vector that includes each of the athletes strength values
% collected from the second day of testing.
%   Output: 
% increasedIDs- a vector that has the IDs of athletes whose strength
% increased from the first day, to the second day of testing. 
%   How to call dayComparer- increasedIDs = dayComparer(SubID, Day1, Day2);

% Those whos strength increased from day1 to day2
increased = secondDay > firstDay;

% IDs for those that had a increase
increasedIDs = SubjectID (increased);

end


