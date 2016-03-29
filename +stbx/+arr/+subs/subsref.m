function [ output_args ] = subsref( input_args )
% SUBSREF overrides subsref to catch X(Y) where Y is a cell array of
% indices to be used with stbx.arr.cellsubsref. If not caught, use builtin
% subsref. As a matter of convenience you can locally override builtin
% subsref with this function use: import stbx.arr.subs.subsref, otherwise,
% stbx.arr.cellsubsref can be called directly.
%
% See also
%   stbx.arr.subs.subsasgn, subsref, cellfun

error(stbx.commons.err.underConstruction);
end

