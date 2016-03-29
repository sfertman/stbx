function Y = butterfilter(X, G0, wc, n, varargin)
%BUTTERFILTER applies Butterworth filter on input X
% Iputs: ( X, G0, wc, n, 'type', 'lpf' )
% X input data
% G0 filter DC gain
% wc filter cutoff frequency 
%   //TODO: make this^ thing work with multiple wc as input where each one
%   will denote start/end of frequency bands
% n number of filter poles
% Optional parameters:
%   'type' {'lpf','hpf'}
%   'input' {'time', 'freq'} % time domain or frequency domain (not shifted!)
%   'output' {'time', 'freq'} % same as above, just for requested output
%
% Output
% Y output data


if ~exist('G0','var') || isempty(G0), G0 = 1; end
if ~exist('wc','var') || isempty(wc), wc = 1; end
if ~exist( 'n','var') || isempty(n),  n  = 1; end


p = inputParser;
addParameter(p, 'type', 'lpf', @(u) any(strcmpi(u, {'lpf','hpf'})));
addParameter(p, 'input', 'time', @(u) any(strcmpi(u, {'time','freq'})));
addParameter(p, 'output', 'time', @(u) any(strcmpi(u, {'time','freq'})));
parse(p, varargin{:});

N = length(X);

switch lower(p.Results.input)
    case 'time'
        % //TODO: the number of fftshifts can be reduced for better
        % performance -- look into it sometime
        fftx = fftshift(fft(X, N)); 
%         fftx = fftshift(fft(X, 2*N)); 
    case 'freq'
        fftx = X;
    otherwise
        error('Something went terribly wrong');
end

w = (1:N) - nthvarout(2, @max, fftx); % //TODO: can this be done using fftshift?
% w = (1:2*N) - N+1;

butterFilter = G0*(1 + (w./wc).^(2*n)).^-0.5;
switch lower(p.Results.type)
    case 'lpf'
        % do nothing
    case 'hpf'
        butterFilter = G0 - butterFilter; 
    otherwise 
        error('Something went terribly wrong')
end

switch lower(p.Results.output)
    case 'time'
%         Y = ifft(ifftshift(butterFilter.*fftx),2*N);
        Y = ifft(ifftshift(butterFilter.*fftx),N);
    case 'freq'
        Y = ifftshift(butterFilter.*fftx,N); % output freq must be not shifted
    otherwise
        error('Something went terribly wrong')
end


end

