function updateConn(servID, connID, paramArry)
% updateConn Update all the parameters for the connection to be reproduced.
%
%   @servID: the id indicating the server where the connnection is on.
%   @connID: the id indicating the order of the connection on the server.
%   @paramArry: an 1x4 array with [arrivalTS endTS opTS opDepth]
%               arrivalTS --- The arrival timestamp of the connection
%               endTS --- The finishing timestamp of the connection
%               opTS --- The next reproduce operation timestamp
%               opDepth --- The reproducing depth of the connection.
%
%   Copyright Aug. 21, 2012, Chen Wang, updateConn.m

global servQ;

servQ{servID}(connID, :) = paramArry;

end