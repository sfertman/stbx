function [PHAT,CI] = binofit( X, N, ALPHA )
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% BINOFIT estimates probability of success and its confidence interval for
% binomial data. Copyright (C) 2016 Alexander Fertman.
%     
%     This file is part of STBX package.
%
%     STBX package is distributed in the hope that it will be useful and
%     it is absolutely free. You can do whatever you want with it as long
%     as it complies with GPLv3 license conditions. Read it in full at: 
%     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
%     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
%   
%     On a personal note, if you do end up using any of my code, consider
%     sending me a note. I would like to hear about the cool new things my
%     code helped to make and get some inspiration for my future projects
%     too.
%     
%     Cheers.
%     -- Alexander F.
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% BINOFIT estimates probability of success and its confidence interval for
% binomial data. This is an overload of a builtin Matlab function with the
% same name. I wrote it because I wanted to control the method used to
% calculate the confidence intervals, because I wanted the function to have
% more goodies compared with the original, because the original requires
% the statistics toolbox, and bacause I like to reinvent the wheel every
% now and again, particularly when there is other urgent work to be done.
%
% PHAT = BINOFIT(X) returns the estimate of of probability of success based
%   on the data in X.
%
% [PHAT, CI] = BINOFIT(X) returns also the confidence interval.
%
% BINOFIT(x) estimates binomial distribution parameters from the data in
%   vector x, assuming that each element in x represents number of
%   successes and that the total number of trials is sum(x).
%
% BINOFIT(X) estimates distribuiton parameters from the data in matrix X,
%   working along the columns, assuming that each element represents the
%   number of successes and that the total number of trials for each column
%   is sum(X,1).
%
% BINOFIT(X,N) allows specification of total number of trials using input
%   N. N can be one of the following:
%   (-) if N is scalar -- it is treated as the total number of trial for
%       each element of X (regardless of dimentionality) 
%   (-) if N is vector -- it must match the dimensions of X in the folowing
%       scenarios: 
%       (-) if X is a vector, N must have the same length as X.
%       (-) if X is a matrix, N must be the length of the number of columns
%           in X.
%   (-) if N is a matrix, it must be the same size as the matrix X. In this
%       case, both X and N do not have to matrices and can be of any
%       dimensionality. 
% 
% BINOFIT(X,N,ALPHA) allows specificatin of confidence level for estimation
%   of distribution parameters (default ALPHA is 0.05).
%
% A note on method of estimation. 
%   At this point in time, the estimations are based on the Wilson's
%   approximate "score" method which was reported to work well in a wide
%   range of cases and be better than the "exact" method [1]. Other methods
%   may be added in the future along with an appropriate param-value input
%   option ('#method' tag), but I wouldn't hold my breath. To the best of
%   my knowledge, the builtin BINOFIT uses Clopper-Pearson (1934) "exact"
%   method and you can use it if you have the stats toolbox.
%
% References:
% -----------
%  [1]  A. Agresti and B. A. Coull, “Approximate Is Better than ‘Exact’ for
%       Interval Estimation of Binomial Proportions,” The American
%       Statistician, vol. 52, no. 2, p. 119, May 1998. 
%

% error handling
twoDimsOnly = struct(...
    'identifier', {'stbx:stats:binofit001'}, ...
    'message', {'This function works on data with upto 2 dimensions.'});
countsNotNumInts = struct(...
    'identifier', {'stbx:stats:binofit002'}, ...
    'message', {'Trial counts must be intereg numbers.'});
countsDimsMismatch = struct(...
    'identifier', {'stbx:stats:binofit003'}, ...
    'message', {'Dimension mismatch between success and trial counts.'});
wrongConfidence = struct(...
    'identifier', {'stbx:stats:binofit004'}, ...
    'message', {'Confidence level must be a real number in (0,1).'});

% program defaults
DEFAULT_ALPHA = 0.05;

if nargin == 0
    % disp help for this file
    return
end

if nargin >= 1
    % deal with X
    assert(isnumeric(X) && all(rem(X(:),1) == 0), countsNotNumInts);
    %assert(ndims(X) <= 2,twoDimsOnly );

    % flagging unassigned parameters
    N = [];
    ALPHA = [];
end

if nargin >= 2
    % deal with N
    assert(isnumeric(N) && all(rem(N(:),1) == 0), countsNotNumInts);    
    %assert(ndims(N) <= 2, twoDimsOnly);
    if isscalar(N) 
        N = N*ones(size(X));
    elseif isvector(N)
        if isvector(X)
            assert(length(N) == length(X), countsDimsMismatch);
        elseif ismatrix(X)
            
        else
            error(countsDimsMismatch);
        end
    elseif ismatrix(N)
        assert(all(size(N) == size(X)), countsDimsMismatch);
    end % we've asserted that it cannot be anything else

    % flagging unassigned parameters
    ALPHA = [];
end

if nargin >= 3
    % deal with ALPHA
    assert(isnumeric(ALPHA) && isreal(ALPHA) && ALPHA > 0 && ALPHA < 1, wrongConfidence);
end


if isempty(N)
    % constructing N according to X
    if isvector(X)
        N = sum(X);
    elseif ismatlrix(X)
        N = sum(X,1);
    elseif ndims(X) > 2 %#ok
        N = sumn(X, 1:ndims-1);
    else 
        % we get here only if X is a scalar which should be happening
        error(stbx.commons.err.superunknown);
    end
end

if isempty(ALPHA)
    ALPHA = DEFAULT_ALPHA;
end

% 100*(1-ALPHA/2) th percentile of the standard normal dist.
z = sqrt(2).*erfinv(1-ALPHA); % z(p) = sqrt(2)*erfinv(2*p -1)
zsq = z^2; % z squared for eazier coding of equations

% very abstractly and wthout takingdimensionality mismatches into account:

% estimate of probability of success
PHAT = X./N; 

% estimate of midpoint
midPoints = PHAT.*N./(N+zsq) + 0.5*zsq./(N+zsq);
% estimate of distances of CI from midpoint
confInts = z*sqrt( (PHAT.*(1-PHAT).*N./(N + zsq) + 0.25*zsq./(N+zsq) )./(N + zsq)  );
% estimate of CI
CI = {midPoints - confInts, midPoints + confInts};
% CI = zeros([size(midPoints), 2])
% CI = midPoints + bsxfun(@times, confInts, [-1, 1]);


end

