function [ str, pos ] = scanftill( txtInStream,  token)
% SCANFTILL scans text input stream 'txtInStream', until 'token' is reached
%
% Input:
%
%   txtInStream     Can be either a character string or a file handle pointing
%                   to a text  file.
%   token           May be any character string
%
% Output:
%
%   str   String of characters read up to the token
%   pos   Position of last char read in txtInStream (end of the token)


% <TODO> let's start with file case. Make this work with regular strings as
% well </TODO>

%%% Assuming that 'txtInStream' is a valid file id
error('not finished, best of doing it is probably in mex');
str = '';
pos = 0;
if ~feof(txtInStream)
    str(end + 1) = fscanf(txtInStream, '%c');
else
    return 
end

tokenFound = false;
l_token = length(token);

while ~feof(txtInStream)
    for i_token = 1:l_token
        if str(end) ~= token(i_token)
            tokenFound = false;
            break;
        else
            str(end + 1) = fscanf(txtInStream, '%c');
        end
    end
    if tokenFound
        % exit loop and mop up 
    else % i.e. ~tokenFound
        
    end
end

