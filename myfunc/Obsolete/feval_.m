function fOut = feval_( fHandles, fInputs)
% can use cellfun for this functionality

if nargin == 0
    help feval_;
end

if ~iscell(fHandles) || ~iscell(fInputs)
    error('Inputs must be cells! See description.');
end

if length(fHandles) ~= length(fInputs)
    error('The number of functions must match the number of function inputs');
end

fOut = cell(length(fHandles),1);
for funcIdx = 1:length(fHandles)
    fOut{funcIdx} = feval(fHandles{funcIdx}, fInputs{funcIdx});
end


    

end

