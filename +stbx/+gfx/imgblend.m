function img_blended = imgblend( A, B, MODE, OPAC, varargin )
% IMGBLEND combines two images using specified blending function (kind of
%   like working with layers in photoshop).
%
% IMGBLEND(A,B,MODE,OPAC) combines images A (bottom) and B (top) using
% blending technique MODE with opacity OPAC.
%   MODE -- blending mode:
%       'normal' (default)
%       'multiply'      a.*b
%       'additive'      min(a + b, 1)
%       'difference'    max(a - b, b - a)
%       'screen'        1 - (1-a).*(1-b)
%       'darken'        min(a,b)
%       'lighten'       max(a,b)
%       'softlight'     (1-2*b).*(a.^2) + 2*a.*b
%       ... more can be easily implemented in 'BLEND_FUNC' inside
%   OPAC -- a measure of top layer (B) opacity ranging from 0 (fully
%       transparent) to 1 (fully opaque -- default).
%       if OPAC is a single or double then OPAC must be between 0 and 1; if
%       OPAC is integer then it must be between 0 and INTMAX of its class
%       and will be mapped from [0,INTMAX] to [0,1] (double).
%
% See also:
%   intmax

% <TODO>
%   (-) make this function deal with indexed/rgb incompatibility internally
%       and automatically.
%   (+) varargin is there only on case more parameter are required in the
%       future. 
% </TODO>

% make sure we have at least two outputs
narginchk(2,inf);

% dealing with A and B inputs
szA = size(A);
szB = size(B);
assert( all(2 <= [ndims(A), ndims(B)]) && all(szA(1:2) == szB(1:2)), ...
    'The input images must be matrices of the same size.');

persistent BLEND_FUNC

% defining the modes of blending
if isempty(BLEND_FUNC)

    BLEND_FUNC = { ... a: bottom image, b: top image, o: opacity
        'normal',       @(a,b) b;
        'multiply',     @(a,b) a.*b; 
        'additive',     @(a,b) min(a + b, 1);
        'difference',   @(a,b) max(a - b, b - a); 
        'screen',       @(a,b) 1 - (1-a).*(1-b);
        'darken',       @(a,b) min(a,b); 
        'lighten',      @(a,b) max(a,b); 
        'softlight',    @(a,b) (1-2*b).*(a.^2) + 2*a.*b; % works but not verified
    };

    BLEND_FUNC = containers.Map(BLEND_FUNC(:,1), BLEND_FUNC(:,2));
end

% dealing with MODE input
if ~exist('MODE', 'var') || isempty(MODE)
    MODE = 'normal';
else
    MODE = lower(MODE);
    assert(BLEND_FUNC.isKey(MODE), 'Unsupported blending mode -- see help for this file.')
end

% dealing with opacity input
if ~exist('OPAC', 'var') || isempty(OPAC)
    OPAC = 1;
elseif isreal(OPAC)
    assert(OPAC >=0 && OPAC <= 1, 'Real opacity values must be between 0 and 1.') 
elseif isinteger(OPAC)
    assert(OPAC >= 0, 'Opacity must be greater than zero.');
    % translating opacity to a double we can work with
    OPAC = double(intmax(class(OPAC)))/double(OPAC);
end

% generate blended top layer
img_blended = feval( BLEND_FUNC(MODE), A, B );
% combine images w/ opacity, if applicable
if OPAC > 0
    img_blended = (1-OPAC)*A + OPAC*img_blended; 
end