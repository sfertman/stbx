function img_blend = imgblend( A, B, MODE, OPAC, varargin )
% IMGBLEND combines images layer by layer using specified blending options
%   (kind of like working with layersin photoshop).
%
% IMGBLEND(A,B,MODE,OPAC,...) combines images A (bottom) and B (top) using
% blending technique M with opacity O.
%   MODE -- blending mode:
%       'Normal' (default)
%       'Multiply' -- a.*b
%       'Additive' -- min(a + b, 1)
%       'Difference' -- max(a - b, b - a)
%       'Screen' -- 1 - (1-a).*(1-b)
%       ... more can be implemented ...
%   OPAC -- a measure of layer opacity 0: transparent, 1: opaque (default)
%       if isreal -- a real number between 0 and 1 
%       if isinteger -- any int between 0 and INTMAX of the same integer
%       class. 
%
%
% See also:
%   isreal, isinteger, intmax

% <TODO>
%   make this function deal with indexed/rgb incompatibilit internally and
%   automatically.
% </TODO>

narginchk(2,inf);

persistent BLEND_FUNC

% defining the modes of blending
if ~exist('BLEND_FUNC', 'var') || isempty(BLEND_FUNC)

    BLEND_FUNC = { ... a: bottom image, b: top image, o: opacity
        'Normal',       @(a,b) b;
        'Multiply',     @(a,b) a.*b; 
        'Additive',     @(a,b) min(a + b, 1);
        'Difference',   @(a,b) max(a - b, b - a); 
        'Screen',       @(a,b) 1 - (1-a).*(1-b);
        'Darken',       @(a,b) min(a,b); 
        'Lighten',      @(a,b) max(a,b); 
        'SoftLight',    @(a,b) (1-2*b).*(a.^2) + 2*a.*b; % works but not verified
    };

    BLEND_FUNC = containers.Map(BLEND_FUNC(:,1), BLEND_FUNC(:,2));
end

if ~exist('MODE', 'var') || isempty(MODE)
    MODE = 'Normal';
end

if ~exist('OPAC', 'var') || isempty(OPAC)
    OPAC = 1;
end
    
% dealing with opacity input
if isreal(OPAC)
    assert(OPAC >=0 && OPAC <= 1, 'Real opacity values must be between 0 and 1.') 
elseif isinteger(OPAC)
    % translating opacity to a double we can work with
    OPAC = double(intmax(class(OPAC)))/double(OPAC);
end

MODE(1) = upper(MODE(1));
assert(BLEND_FUNC.isKey(MODE), 'Unsupported blending mode -- see help for this file.')
img_blend = feval(BLEND_FUNC(MODE), A,B);
if OPAC > 0, img_blend = (1-OPAC)*A + OPAC*img_blend; end
end

