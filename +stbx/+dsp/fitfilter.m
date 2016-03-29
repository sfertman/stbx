function Y = fitfilter( X, D )
%FFTFIT Summary of this function goes here
% //TODO: change function name and function function into "bagging" --
% bootstrap aggregating. This should be done later... Right now,
% concentrate on makingit work with butterfilter.
% division of all points into subsets to use in each iteration

if ~exist('D', 'var'), D = 10; end 
% TODO: later some better default^ may be implemented, for my purposes now,
% it's good enough

N = length(X);

% I need to make an optimization algorithm here:
% 1) guess some s values to start with
G0 = 1; % not going to be changed
wc0 = 1; % our optimization variable
n = 8; % maybe will change during optimization but probably not, can be a parameter to play with later if things go unexpectedly bad

% pick a bunch (N/D) of points at random according to 'D' (divider
% parameter)
N_ = round(N/D); % number of points we're going to use at each iteration

%%% vvvvv Main loop begins here vvvvv
% for i = 1:D % TODO: D may be later changed to work with external value to
% denote number of partial draws to make from the data

% "WR" design -- allowing for duplicate values
pickIdx = sort(round(N*rand(1,N_))); 
% "WOR" design (without replacement)
while any(pickIdx(1) == pickIdx(2:end)) || any(pickIdx == 0 | pickIdx > N)
    pickIdx = sort(round(N*rand(1,N_)));
end

X_ = X(pickIdx); % partial data to fit

%%% for each X_ like above we need to find the best fit
wc = wc0;
% while noise is not white (figure out how to do that)

% get filtered data
x_ = stbx.dsp.butterfilter(X_, G0, wc, n); 

% get noise: x' = x0 + n --> n = x' - x0; i.e. noise is raw minus filtered
isWhiteNoiose( X_ - x_ );


%%
figure; hold on
plot(X_)
plot(x_,'r')
noise = X_ - x_;
figure; plot(noise)
figure; plot(xcorr(noise))



% 2) increase s until best fit reached (minimum square error from X);
%    another option may be to find an optimal s by binary search or
%    golden-section search. 
% 3) do this for number of times when each time a random bunch of points is
%    selected out of X 
% 4) average all results (s) found above
% *5) vectorize this thing to work on matrices where each column is an
%    independent vector
% 

end

