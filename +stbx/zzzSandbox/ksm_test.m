clear all
close all

%%
X = 2*pi*(-1:0.001:1);
% Y = 0.25*X + sin(X);
Y_ = 0.5*X + sin(X) + 0.5*sin(1.5*X) + cos(3.1*X+0.33*pi)+3;% +0.75*cos(17*X) + 3;
Y = Y_ + 0.0*randn(size(X));
% figure; plot(X,Y,'.-')
[x, y] = stbx.roboschool.linearize(X,Y);
figure;
 hold on; grid on;
% plot(X, Y_, 'b-', 'LineWidth', 1.5)
plot(X, Y,  'ob');
% plot(X, y_hat, '-.r','LineWidth', 1.5)
% plot(X(poiIdx), y_hat(poiIdx), 'sk')
plot(x, y, 'sk--','LineWidth',1.5)

% subplot(212); hold on; grid on;
% plot(X, y_ftr, '-'); 
% plot(X(poiIdx), y_ftr(poiIdx), 'or')
return

%%
y_hat = stbx.ksm.smgauss1d(X,Y,0.125);

[r_sqr,g] = stbx.curvature(X, y_hat');
y_ftr = -g;
y_ftr = (y_ftr - min(y_ftr))/(max(y_ftr) - min(y_ftr)); % mapped into [0,1]
y_ftr = sqrt(y_ftr);

diff_y_ftr = diff(y_ftr);
diff_y_ftr = [diff_y_ftr, diff_y_ftr(end)];
max_diff_y_ftr = find(diff_y_ftr(1:end-1) >= 0 & diff_y_ftr(2:end) < 0 & y_ftr(1:end-1) > 0.175) + 1;

poiIdx = max_diff_y_ftr;
if min(poiIdx) ~= 1, poiIdx = [1, poiIdx]; end
if max(poiIdx) ~= length(Y), poiIdx = [poiIdx, length(Y)]; end

%%
figure;
subplot(211); hold on; grid on;
plot(X, Y_, 'b-', 'LineWidth', 1.5)
plot(X, Y,  'ob');
plot(X, y_hat, '-.r','LineWidth', 1.5)
plot(X(poiIdx), y_hat(poiIdx), 'sk')
plot([X(poiIdx(1:end-1))',X(poiIdx(2:end))'], [y_hat(poiIdx(1:end-1)),y_hat(poiIdx(2:end))], 'k--','LineWidth',1.5)

subplot(212); hold on; grid on;
plot(X, y_ftr, '-'); 
plot(X(poiIdx), y_ftr(poiIdx), 'or')

