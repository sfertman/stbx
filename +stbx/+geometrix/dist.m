function D = dist( varargin )
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% DIST calculates the Euclidean distance between input variables. Copyright
% (C) 2016 Alexander Fertman.
%     
%     This file is part of STBX package.
%
%     STBX package is distributed in the hope that it will be useful and
%     it is absolutely free. You can do whatever you want with it as long
%     as it complies with GPLv3 license conditions. Read it in full at: 
%     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
%     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
%   
%     On a personal note, if you do end up using any of my code, consider
%     sending me a note. I would like to hear about the cool new things my
%     code helped to make and get some inspiration for my future projects
%     too.
%     
%     Cheers.
%     -- Alexander F.
%+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
% DIST calculates Euclidean distance.
% D = DIST(X) return distances between elements of X. If X is an N by M
%   matrix, DIST works along the rows by default considering columns as
%   vector coordinates (N vectors of dimension M). If X is a vector, the
%   size of D is going to be length(X) by length(X). If X is N by M matrix,
%   the size of D is going to be N by N.
% D = DIST(X, 'sequential') returns distance between each member and its
%   immediate neighbour in the matrix.

i=1; j=1; P= 1;
D(i,j) = sqrt(sum((P(:,i) - P(:,j)) .^ 2));


error(stbx.commons.err.underConstruction)

end

