function [ output_args ] = hist2dw_pdf( D, C, B )
%HIST2DW_PDF Summary of this function goes here
%   Detailed explanation goes here


% [F,X] = stbx.stats.ecdf(D, 'frequency', C);
[F,X] = stbx.stats.ecdf(D, C);

[N,x_] = ecdfhist(F,X,B);





end

