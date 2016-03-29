function  [x, y] = linearize( X, Y )

% Gaussian kernel smoothing
h = 0.125; % kernel radius
% y_hat = stbx.ksm.smgauss1d(X,Y,h);
y_hat = stbx.dsp.butterfilter(Y, 1, 15, 5);
% //TODO: ^ make this this find the optimal kernel size for the given data
%         automatically

% finding cos of angle between each pair of lines between each subsequent 3
% points using the curvature function.
[~, cos_gamma] = stbx.geometrix.curvature(X, y_hat);
% mapping to [0,1] and inverting positive-negative, note the min(cos) - cos
y_ftr = 1+(min(cos_gamma) - cos_gamma)/(max(cos_gamma) - min(cos_gamma));
y_ftr = sqrt(y_ftr); % taking the square root for better resolution and thresholding
% //TODO: ^ not necessary for numeric optimization that will come later.

% y_ftr = stbx.ksm.smgauss1d(X,y_ftr,h/2).';
y_ftr = stbx.dsp.butterfilter(y_ftr, 1, 30, 5);

diff_y_ftr = zeros(size(y_ftr));
diff_y_ftr(1:end-1) = diff(y_ftr); % take the 1st derivative of the adjusted cos angle
diff_y_ftr(end) = diff_y_ftr(end-1); % make sure it's the same size as the rest of the datya
% find the maximum cos angle points, larger adj cos angle, smaller angles
poiIdx = find(diff_y_ftr(1:end-1) >= 0 & diff_y_ftr(2:end) < 0 & y_ftr(1:end-1) > 0.175) + 1;
% ^ those are our points of interest indices.

% make sure that the edges are included in poi array
if min(poiIdx) ~= 1, poiIdx = [1, poiIdx]; end
if max(poiIdx) ~= length(Y), poiIdx = [poiIdx, length(Y)]; end

% get the Xs and Ys of the estimated points of interest and output them
% x = [X(poiIdx(1:end-1)),X(poiIdx(2:end))];
% y = [y_hat(poiIdx(1:end-1)),y_hat(poiIdx(2:end))];
x = X(poiIdx);
y = y_hat(poiIdx);

%%% ------------------------------------------------------------------
% //TODO: add the following filter -- if the distance betwen any two points
%         is less than threshold (maybe d < mu - 2*sigma), aggregate the
%         points into one. It's position is the average of the tow points.
%         Repeat untill no close proximity points are found.

% find eucledian distance between every two adjacent points
distxy = sqrt((x(1:end-1) - x(2:end)).^2 + (y(1:end-1) - y(2:end)).^2);

% find points to remove by simple threshold
removeIdx = find((distxy.^2)/max(distxy.^2) < 0.01);
% if any if the indices are on the edges, we take the edge point
if ~isempty(removeIdx) && removeIdx(1) == 1
    x(2) = [];
    y(2) = [];
    removeIdx = removeIdx(2:end) - 1; % -1 because we one point less now
end

if ~isempty(removeIdx) && removeIdx(end) == length(x) - 1
    x(end-1) = [];
    y(end-1) = [];
    removeIdx(end) = [];
end

% remove each pair of close points and replace them withone that has
% average x location

avgX = mean([x(removeIdx+1); x(removeIdx)],1);
% find y by using matlabs interp function
avgY = interp1(X,y_hat,avgX);

% remove ponts and replace them with the calculated
x(removeIdx) = avgX; x(removeIdx + 1) = [];
y(removeIdx) = avgY; y(removeIdx + 1) = [];


% //TODO: first, we aggregate points that are very close to each other, and
%         then we look at all angles between each two subsequent lines, if
%         they are larger than threshold (maybe a < mu + 2*sigma) then we
%         combine the two lines into one line between the farthest two
%         points out of three.

end

