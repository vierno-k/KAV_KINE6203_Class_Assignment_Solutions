function [maleIsoIndMeans, femaleIsoIndMeans, maleGroupIsoMean, femaleGroupIsoMean] = ...
    genderIsoCalc (Gender, day1, day2, day3)
% This function is one that separates participants by their gender and also
% calculates each participants mean isometric strength across the three
% days. This function also calculates the overall isometric mean strength
% for both female and male groups. 

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


