function [ output_args ] = autorbfsmooth( Y )
% AUTORBFSMOOTH smooths noisy input signal by automatiacally selecting
% kernel size and proportion multipliers.
%
% Optimization procedure aims to reduce noise by maximizing the "whiteness"
% of the difference between input and smoothed signals. Meaning, assuming
% that Y = Y_true + Y_noise, and Y_smooth is the result of rbf kernel
% smoothing, we try to maximize the whiteness of Y - Y_smooth. In this way,
% if Y_noise is white noise signal then Y - Y_smooth --> Y_noise and 
% Y_smooth --> Y_true.
% Additional noise type filtering will be added in the future (pink, red,
% grey).


end

