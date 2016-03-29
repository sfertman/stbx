function plotFuncHandle(f, x0, dx, t)
% supposed to plot a line according to function handle (f), starting value
% (x0), constant step size (dx) step "learning-rate" parameter (t). 
%
% This function seems to be redundant since you can do the following:
%   plot(x0 + t*dx, f(x0 + t*dx))
% and in case f is not setup to deal with vectorized inputs, the following
% will do the trick:
%   plot( x0 + t*dx, cellfun(@(u) f(x0 + u*dx), num2cell(t)) )

ff = nan(size(t));
for i = 1:length(t)
    ff(i) = f(x0 + t(i)*dx);
end

plot(t,ff); hold on;
plot(0, f(x0), '.', 'MarkerSize', 15)
hold off