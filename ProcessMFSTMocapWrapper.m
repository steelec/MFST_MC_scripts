%ProcessMFSTMocapWrapper

% Specifically for MFST Experiment at Penhune Lab (ConU)
% Joseph Thibodeau (R)(C)(TM) 2012 Patent Pending

% dataDir is a string path to where the data lives
% subjects is a cell array of subject names
% days is a vector of days to investigate
% keyorder is a vector of keys ex. [1 2 3 4] for normal arrangment
% parsetype is either 'ascii' or 'binaryRS'
% showVisuals is bool

%% Scoring for MFST_Mocap

%setup basic path information
dataDir='/home/thibodeauj/ChrisMFST/scripts/MFSTMoCap/';

%IDs={'P01','P02','P006','P007','P008','P009','P010','P11','P12'}; %ids of the individuals who will be scored
% IDs={'Tomas'};
IDs={'dilini'};
% IDs={'timertest_200Hz'}; %ids of the individuals who will be scored
% IDs={'clocktestDAQ_1Hz_2'}; % DAQ-Driven timer test
% IDs = {'RSClockTest_2Hz'}; % Binary message (as opposed to ASCII) timer test (not from DAQ)
% IDs={'P02','P010','P11','P12'}; %ids of wierd data to investigate 2012-05-01

days=[1,2];
keyorder = [4 3 2 1];
keyorder = [1 2 3 4];
parseType = 'binaryRS';
showVisuals = true;

ProcessMFSTMoCap(dataDir,IDs,days,keyorder,parseType,showVisuals);