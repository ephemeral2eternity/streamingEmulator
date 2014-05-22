function openNewServer(MS)
% openServer Open a new server to serve the connections
%   serverConn = openServer(MS) returns the new created server with MS
%   number of connections
%   MS: the maximum number of connections defined for one server
%   Copyright Aug. 20, 2012, Chen Wang, openServer.m
% 
import java.util.LinkedList

global servQ;
global emptyConnQueue;


% For conn field of serverConn.
% The first column is the start timestamp of the connection
% The second column is the finishing timestamp of the connection
% The third column indicates the next reproduce operation timestamp
% The fourth column indicates the reproducing times of the connection.

serverConn = zeros(MS, 4);

servQ = [servQ; serverConn];

servID = size(servQ, 1);
for i = 1 : MS
    emptyConnQueue.add([servID i]);
end

end
