function strOut = escapechars( str, chr )
% ESCAPECHARS inserts '\' before specified characters in string. Any
% characters can be "escaped"; however, some special characters (i.e.
% escape characters) need to be input using '\' in front of them. Both
% inputs to this function must be either 1D character arrays or cellstr. If
% both inputs are cellstr then they must have the same size.
% For example:
%   ESCAPECHARS('my_text_is^Tex&compatible', '\^_\&')
% returns
%   my\_text\_is\^Tex\&compatible
%
% See also:
%   regexp

assert(ischar(str) || iscellstr(str), 'Input string must be ''char'' or ''cellstr''.');
assert(ischar(chr) || iscellstr(chr), 'Input string must be ''char'' or ''cellstr''.');

if ischar(str)
    if ischar(chr)
        chrIdx = regexp(str, ['[',chr,']']);    
        strOut = crunchSrtOut(str, chrIdx);
    else % iscellstr(chr)
        chrIdx = regexp(str, cellfun(@(cc) ['[',cc,']'], chr, 'UniformOutput', false));
        strOut = cellfun(@(cc) crunchSrtOut(str, cc), chrIdx, 'UniformOutput', false);
    end
else % iscellstr(str)
    if ischar(chr)
        chrIdx = regexp(str, ['[',chr,']']);
    else % iscellstr(chr)
        assert(all(size(str) == size(chr)), 'Strings and pattern cells must be the same size.');
        chrIdx = regexp(str, cellfun(@(cc) ['[',cc,']'],chr, 'UniformOutput', false));
    end
    strOut = cellfun(@crunchSrtOut, str, chrIdx, 'UniformOutput', false);
end

end

function strOut = crunchSrtOut(str, chrIdx)
%%% fastest so far. Try to rig the isempty check outside this function
if isempty(chrIdx)
    strOut = str;
    return;
end
len_chrIdx = length(chrIdx);
chrIdx = chrIdx + (0:(len_chrIdx-1));
len_strOut = length(str) + len_chrIdx;
strOutIdx = true(1, len_strOut);
strOutIdx(chrIdx) = false;
strOut(strOutIdx) = str;
strOut(chrIdx) = '\';
end

% function strOut = crunchSrtOut(str, charIdx)
% %%% faster than slow
% charIdx = regexp(str, ['[',chars,']']);
% for i = 1:length(charIdx)
%     str = [str(1:charIdx(i)-1), '\', str(charIdx(i):end)];
%     charIdx = charIdx + 1;
% end
% end

% function strOut = crunchSrtOut(str, charIdx)
% %%%  too slow -----
% [sss,cid] = regexp(str, ['[',chars,']'],'split');
% temp_cell = [sss(1) ; strcat(cellstr('\'+ str(cid).'), sss(2:end).') ].';
% strOut = strcat(temp_cell{:});
% end

