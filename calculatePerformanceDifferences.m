
function [forwardDiff, backwardDiff] = calculatePerformanceDifferences(forwardTime, preferredTime, backwardTime)
%CALCULATEPERFORMANCEDIFFERENCES Calculate differences in kickstart performance.
%   This function compares mean 5 m start times at the forward and backward
%   back plate positions against the swimmer's preferred position.
%
%   INPUTS: 
%   forwardTime   - Mean start times at the forward back plate position (s).
%   preferredTime - Mean start times at the preferred back plate position (s).
%   backwardTime  - Mean start times at the backward back plate position (s).
%
%   OUTPUTS:
%   forwardDiff   - Forward mean time minus preferred mean time (s).
%   backwardDiff  - Backward mean time minus preferred mean time (s).
%
%   A positive difference indicates slower performance compared to the
%   preferred position, while a negative difference indicates faster
%   performance.
%
%   The inputs can be individual values or equally sized arrays, allowing
%   the function to calculate differences for multiple swimmers.

% Calculate the difference between the forward and preferred positions.
forwardDiff = forwardTime - preferredTime;

% Calculate the difference between the backward and preferred positions.
backwardDiff = backwardTime - preferredTime;

end


