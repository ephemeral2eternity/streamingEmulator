function nextParam = getNextParam(serverQueue, paramTyp)
% nextParam Get the next closest finish task time
%   nextParam = nextParam(servQueue, paramTyp) returns the next closest
%   parameter defined by the paramTyp.
%   paramTyp: 'nextOP' ---- return the next closest reproducing operation
%   time.
%             'nextFIN' ---- return the next closest task finishing time.
%
%   Copyright Aug. 20, 2012, Chen Wang, getNextParam.m
% 

import java.util.LinkedList
global curConnQueue;

existParams = []; % Maximal finishing time possible.
T = 24 * 60 * 60;    % The maximal possible value of timestamp.
switch paramTyp
    case 'nextOP'
        paramID = 3;
    case 'nextFIN'
        paramID = 2;
    otherwise
        error('Wrong paramTyp input!!!!');
end

if curConnQueue.size() >= 1
    itr = curConnQueue.listIterator();
    while itr.hasNext()
        scID = itr.next();
        serverID = scID(1);
        connID = scID(2); 

        existParams = [existParams serverQueue{serverID}(connID, paramID)];
    end
    nextParam = min(existParams);
else
    nextParam = T;
end

end