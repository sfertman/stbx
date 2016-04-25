function [ output_args ] = compress( X, G )
%COMPRESS Summary of this function goes here
% X data
% G grouping (optional)

if ~exist('G','var') 
    G = {}; 
elseif ~isempty(G)
    % make sure the same number of rows as X
    assert(size(G,1) == size(X,1), 'Grouping var size mismatch. Must have the same number of rows as data.');
end

error(stbx.commons.err.underConstruction);
end

