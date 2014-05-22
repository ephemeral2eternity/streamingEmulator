function finishConn(curTS)
% finishConn Finish all the connections that end in the current time
%   "curTS". Delete all the finished connections and add those vacancies to
%   the empty queue list "emptyConnQueue". Change the total connection
%   number "connNum" and total open server number "serverNum".
%
%   @curTS: the current timestamp the the event (Here the event is finishing
%           a connection)
%
%   Copyright Aug. 21, 2012, Chen Wang, addConnection.m

global servQ;
global emptyConnQueue;
global curConnQueue;

import java.util.LinkedList

itr = curConnQueue.listIterator();
while itr.hasNext()
    scID = itr.next();
    serverID = scID(1);
    connID = scID(2); 

    servFinTS = servQ{serverID}(connID, 2);
    if servFinTS == curTS
        emptyConnQueue.add([serverID connID]);

        % Set all parameters to 0 which is defaultly null.
        servQ{serverID}(connID, :) = 0;
        itr.remove();
    end
end

end