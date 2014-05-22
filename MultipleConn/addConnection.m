function addConnection(arrivalTS, endTS, opTS, opDepth)
% addConnection Add a new connection that can either be created by new 
%   coming viewers or by reproducing connections on the available connections.
%
%   @arrivalTS: the arrival time stamp of the current connection
%   @endTS: the end time stamp of the current connection
%   @opTS? the time stamp of the scheduled reproducing procedure for this 
%           connection
%   @opDepth: the reproducing depth of the current connection 
%
%   Copyright Aug. 21, 2012, Chen Wang, addConnection.m
% 
import java.util.LinkedList

global servQ;
global emptyConnQueue;
global curConnQueue;

scID = emptyConnQueue.poll();

serverID = scID(1);
connID = scID(2); 


servQ{serverID}(connID, :) = [arrivalTS endTS opTS opDepth];
curConnQueue.add(scID);

end
