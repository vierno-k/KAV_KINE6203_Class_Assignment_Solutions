function [maleIsoIndMeans, femaleIsoIndMeans, maleGroupIsoMean, femaleGroupIsoMean] = ...
    genderIsoCalc (Gender, day1, day2, day3)
% This function is one that separates participants by their gender and also
% calculates each participants mean isometric strength across the three
% days. This function also calculates the overall isometric mean strength
% for both female and male groups.
%   Inputs:
% Gender- a vector that identifies each of the athletes as male ('M') or
% female ('F').
% day1- a vector that has each of the athletes isometric strength
% measurements collected from the first day of testing.
% day2- a vector that has each of the athletes isometric strength
% measurements collected from the second day of testing.
% day3- a vector that has each of the athletes isometric strength
% measurements collected from the third day of testing.
%   Outputs:
% maleIsoIndMeans- a vector that has the mean isometric strength of the
% three days of testing for each of the male athletes. 
% femaleIsoIndMeans- a vector that has the mean isometric strength of the
% three days of testing for each of the female athletes. 
% maleGroupIsoMean- a single number that represents the overall isometric
% strength mean for all of the male athletes. 
% femaleGroupIsoMean- a single number that represents the overall isometric
% strength mean for all of the female athletes. 
%   How to call genderIsoCalc- [maleIsoIndMeans, femaleIsoIndMeans,
% maleGroupIsoMean, femaleGroupIsoMean] = genderIsoCalc(Gender, Day1,
% Day2,Day3);

% Who is male, who is female?
male = Gender == 'M';
female = Gender == 'F';

% Calculate each males strength across the 3 days
maleIsoIndMeans = mean ([day1(male), day2(male), day3(male)], 2);

% Calculate each females strength across the 3 days
femaleIsoIndMeans = mean([day1(female), day2(female), day3(female)], 2);

% Calculate overall male group mean
maleGroupIsoMean = mean(maleIsoIndMeans);

% Calculate overall female group mean
femaleGroupIsoMean = mean(femaleIsoIndMeans);

end 


