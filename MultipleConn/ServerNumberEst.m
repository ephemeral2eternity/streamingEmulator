% Aug. 20, 2012, Chen Wang
% ServerNumberEst.m
% This mfile computes the number of servers needed for 1 to 1 connection.
% The arrival process of new viewer is Poisson 
% versus N to 1 connections. We are trying to test the interval T to
% minimize the communication cost while maximize the average utilization of
% the servers.
clc;
clear all;
close all;

import java.util.LinkedList
import java.util.ArrayList

%% Parameters Specification
lambda = 20;     % The Average Arrival Intervals of views follows Poisson 
vidLen = 120 * 60;   % All videos are with 120 minutes length.
MS = 10;        % There are maximally 10 connections for 1 server.

T = 24 * 60 * 60;    % Count the needed servers in one day.

%% Initialization of arrival TS
startTS = 0;
viewArrival = exprnd(lambda);
arrivalTS = startTS + viewArrival;
endTS = LinkedList();
endTS.add(arrivalTS + vidLen);

connNum = 0;
serverNum = 1;

nextFIN = endTS.getFirst();
curTS = min(arrivalTS, nextFIN);

tData = [];

%% Count the needed number of servers during 
while curTS < T
    if (curTS == arrivalTS) && (curTS ~= nextFIN)
        connNum = connNum + 1;
        if connNum > MS
            connNum = 1;
            serverNum = serverNum + 1;
        end
        
        % Update the next instance of changes.
        startTS  = startTS + viewArrival;
        viewArrival = exprnd(lambda);
        arrivalTS = startTS + viewArrival;
        
        endTS.add(arrivalTS + vidLen);  
    elseif (curTS == nextFIN) && (curTS ~= arrivalTS)
        connNum = connNum - 1;
        if (connNum < 1) && (serverNum > 1)
            connNum = 10;
            serverNum = serverNum - 1;
        elseif (connNum < 1) && (serverNum <= 1)
            connNum = 0;
            serverNum = 1;
        end
        endTS.removeFirst();
    end
    
    % Track the changes of server number and connection number.
    tData = [tData; curTS connNum serverNum];
    
    nextFIN = endTS.getFirst();
    curTS = min(arrivalTS, nextFIN);   
end

