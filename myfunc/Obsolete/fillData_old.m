

function y=fillData_old(x,DIM)
% FIXGAPS Linearly interpolates gaps in a time series
% YOUT=FIXGAPS(YIN) linearly interpolates over NaN
% in the input time series (may be complex), but ignores
% trailing and leading NaN.
%

% R. Pawlowicz 6/Nov/99

% modified to deal with leading and trailing NaNs (Alexander F. -- 12/Dec/2013)
% modified to interpolate on dimension DIM (Alexander F. -- 29/Jan/2014) -
% -not finished!!!!!
if ~exist('DIM', 'var')
    DIM = 1;
end
y = x;

bd = isnan(x);
if sum(bd) == length(x)
    warning('data all NaNs');
    return
end
if bd(1)
    firstGoodIdx = find(~bd,1,'first');
    y(1:firstGoodIdx-1) = y(firstGoodIdx);
end

if bd(end)
    lastGoodIdx = find(~bd,1,'last');
    y(lastGoodIdx+1:end) = y(lastGoodIdx);
end

gd = find(~bd);

bd([1:(min(gd)-1) (max(gd)+1):end]) = 0;

y(bd)=interp1(gd,x(gd),find(bd));

end
