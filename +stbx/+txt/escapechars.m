function strOut = escapechars( str, chars )
% ESCAPECHARS inserts '\' before specified characters in string. Any
% characters can be "escaped"; however, some special characters (i.e.
% escape characters) need to be input using '\' in front of them.
% For example:
%   ESCAPECHARS('my_text_is^Tex&compatible', '\^_\&')
% returns
%   my\_text\_is\^Tex\&compatible
%
% See also:
%   regexp


%%% fastest so far ~50 microseconds for one run
charIdx = regexp(str, ['[',chars,']']);
len_charIdx = length(charIdx);
charIdx = charIdx + (0:(len_charIdx-1)); 
len_strOut = length(str) + len_charIdx;
strOutIdx = true(1, len_strOut);
strOutIdx(charIdx) = false;
strOut(strOutIdx) = str;
strOut(charIdx) = '\';

%%% faster
% charIdx = regexp(str, ['[',chars,']']);
% for i = 1:length(charIdx)
%     str = [str(1:charIdx(i)-1), '\', str(charIdx(i):end)];
%     charIdx = charIdx + 1;
% end


%%%  too slow -----
% [sss,cid] = regexp(str, ['[',chars,']'],'split');
% temp_cell = [sss(1) ; strcat(cellstr('\'+ str(cid).'), sss(2:end).') ].';
% strOut = strcat(temp_cell{:});


