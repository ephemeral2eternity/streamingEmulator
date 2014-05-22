% This mfile computes the number of servers needed for 1 to 1 connection.
% The arrival process of new viewer is Poisson. We are trying to test the 
% interval Intvl to minimize the communication cost while maximize the average 
% utilization of the servers.
%
%   Copyright Aug. 20, 2012, Chen Wang, SingleServerNumberEst.m
clc;
clear all;
close all;
global servQ;
global emptyConnQueue;
global curConnQueue;
global Intvl;

import java.util.LinkedList


%% Parameters Specification
lambda = 20;     % The Average Arrival Intervals of views follows Poisson 
vidLen = 60 * 60;   % All views are served with 60 minutes long.
MS = 10;        % There are maximally 10 connections for 1 server.
maxDepth = 4;

Intvl = 60 * 5;

T = 24 * 60 * 60;    % Count the needed servers in one day.
servQ = {};
emptyConnQueue = LinkedList();
curConnQueue = LinkedList();

%% Initialization
% These parameters are for parameters of next new added connection.
arrivalTS = 0;
viewArrival = exprnd(lambda);
arrivalTS = arrivalTS + viewArrival;
endTS = arrivalTS + vidLen;
opTS = arrivalTS + Intvl;

% Set up nextFIN as default value T.
nextFIN = T;

% Initialize parameters for looping
curTS = arrivalTS;
tData = [];

%% Count the needed number of servers during 
while curTS < T
    if curTS == arrivalTS
        if (emptyConnQueue.size() < 1)
            openNewServer(MS);
        end
        addConnection(arrivalTS, endTS, 0, 1);
        
        % Update the next instance of changes.
        viewArrival = exprnd(lambda);
        arrivalTS = arrivalTS + viewArrival;
        endTS = arrivalTS + vidLen;
        opTS = arrivalTS + Intvl;
    elseif curTS == nextFIN
        finishConn(curTS);
    end
    
    nextFIN = getNextParam(servQ, 'nextFIN');
    
    % Track the changes of server number and connection number.
    tData = [tData; curTS curConnQueue.size() length(servQ)];
    
    % Update the timestamp of next event
    curTS = min(arrivalTS, nextFIN);
    curTS
end

