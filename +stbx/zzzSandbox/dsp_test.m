clear all
close all

%%
X = 2*pi*(-1:0.001:1);
% Y = 0.25*X + sin(X);
Y_ = 0.5*X + sin(X) + 0.5*sin(1.5*X) + cos(3.1*X+0.33*pi)+3;%+0.75*cos(17*X) + 3;
Y = Y_ + 0.75*randn(size(X));

% y = stbx.dsp.fftfit(Y);
y= stbx.dsp.butterfilter(Y_,1,15,5);
[x_,y_] = stbx.roboschool.linearize(X,Y)

figure; ax = newplot; hold on; grid on;
plot(ax, X, Y, 'o', 'Color', [173,235,255]/255);
plot(ax, X, Y_, 'k--', 'LineWidth', 1.5)
plot(ax, X, y,'-.r', 'LineWidth', 1.5);
plot(ax, x_, y_,'-sk', 'LineWidth', 1.5);


[tf, R, chi2_cr] = stbx.dsp.isWhiteNoise(Y,10)
[tf, R, chi2_cr] = stbx.dsp.isWhiteNoise(Y-Y_,10)
[tf, R, chi2_cr] = stbx.dsp.isWhiteNoise(randn(1,1000),100, 0.95)

figure; plot(X,Y-Y_)
figure; plot(abs(fft(Y-Y_)))

figure; plot(abs(fft(randn(1,100))))
figure; plot(xcorr(randn(1,1000),50))

%%
xx = 0:0.01:25;
figure; 
subplot(211); plot(xx, chi2pdf(xx, 10));
subplot(212); plot(xx, chi2cdf(xx, 10));


chi2inv(1-0.95, 10)
