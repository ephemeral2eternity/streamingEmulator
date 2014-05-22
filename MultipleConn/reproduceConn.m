function reproduceConn(curTS, MS, maxDepth)
% reproduceConn Reproduce all connections that have reached the reproducing
%   interval. Split all the connections for reproducing and change the
%   starting and finishing timestamp of these connection. Change the
%   reproducing depth and add new connection by choosing the empty vacancies
%   from the empty queue list "emptyConnQueue". Update the total connection
%   number "connNum" and total open server number "serverNum" if necessary.
%
%   @curTS: the current timestamp the the event (Here the event is
%   reproducing a connection)
%   @MS: If necessary, open a new server with MS maximal connections.
%
%   Copyright Aug. 21, 2012, Chen Wang, reproduceConn.m

global servQ;
global emptyConnQueue;
global curConnQueue;
global Intvl;

import java.util.LinkedList
% import java.util.concurrent
tmpNewConn = [];
itr = curConnQueue.listIterator();
while itr.hasNext()
    scID = itr.next();
    serverID = scID(1);
    connID = scID(2); 

    servOpTS = servQ{serverID}(connID, 3);
    if servOpTS == curTS
        orgEndTS = servQ{serverID}(connID, 2);
        orgOpDepth = servQ{serverID}(connID, 4);
        
        if orgOpDepth < maxDepth
            % Update all parameters for new splitted connections.
            newArrivalTS = curTS;
            newEndTS = (orgEndTS - newArrivalTS) ./ 2 + newArrivalTS;
            newOpTS = curTS + Intvl;
            newOpDepth = orgOpDepth + 1;

            % add new connection
            % addConnection(newArrivalTS, newEndTS, newOpTS, newOpDepth);
            tmpNewConn = [tmpNewConn; newArrivalTS newEndTS newOpTS newOpDepth];
            
            % Update previous connection with new parameters.
            updateConn(serverID, connID, [newArrivalTS newEndTS newOpTS newOpDepth]);
        end
    end
end

for i = 1 : size(tmpNewConn, 1)
    if emptyConnQueue.size() < 1            
        % open a new server first.
        openNewServer(MS);
    end
    addConnection(tmpNewConn(i, 1), tmpNewConn(i, 2), tmpNewConn(i, 3), tmpNewConn(i, 4));
end
clear itr;
end