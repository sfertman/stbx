function varargout = mle(varargin)
% <TODO>
%   very basic, expand and vectorize
% </TODO>
% MLE(@pdf, sample, theta)
%   finds ln-likelihood of the sample data assuming the given pdf
% the 'sample' may consist of a many dimensions
%   every sample dimension or sensor must be placed in a different column
%   and then the rows of the 'sample' matrix would be the number of trials 
%   or measurements of every sensor.

pdf_h = varargin{1}; % pdf handle
sample = varargin{2}; % measured sample
theta = varargin{3}; % state of nature

LL = zeros(length(theta),1);
for j = 1:length(theta)
    for i = 1:length(sample)
        p = pdf_h(sample(i,:), theta(j));
        if isnan(p)
%             disp('WARNING in ''likelihood.m'': NaN p!');
            continue;
        end
        LL(j) = LL(j) + log(p);
        % we take the rows of the 'sample' matrix because every element 
        % (different column) represents a different random variable value 
        % (x, y, z, etc...).
    end
end
varargout{1} = LL;

if isinf(LL)
    warning('Infinite likelihood. The cause may be zero probability somewhere...')
end

end