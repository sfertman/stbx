% regexp examples for tearing off a number at the end of a character string
str = 'It''s 1pm now. Num6er of hour5 l3ft @ work is: 4';

% splitting the string 
[s, m] = regexp(cellstr(str), '\d*$','split', 'match');

% concatination methods from quickest to slowest
s_1 = s; s_1(end) = m;
s_2 = s; s_2{end} = m{1};
s_3 = [s(1:end-1), m];
s_4 = [[s{:}], m]; 
 
% trying this thing on many strings in vectorized way
n = 1e6; % number of strings
str = 'It''s 1pm now. Num6er of hour5 l3ft @ work is: ';
str = cellstr(str + num2str(round(1e12*rand(n,1)))); % randomizing the numbers at the end of strings just for fun
[s, m] = regexp(cellstr(str), '\d*$','split', 'match'); % the business end of this program

% concatination methods from quickest to slowest
s_1 = vertcat(s{:});
s_1(:,2) = m{:};

s_2 = vertcat(s{:});
m_2 = vertcat(m{:});
s_2(:,2) = m_2;

