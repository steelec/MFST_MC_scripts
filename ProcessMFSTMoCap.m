%ProcessMFSTMocap
function PPs = ProcessMFSTMoCap(dataDir,IDs,days,keyorder,parseType,showVisuals)
% Specifically for MFST Motion Capture pilot performed at CIRMMT
% Joseph Thibodeau (R)(C)(TM) 2012 Patent Pending
% dataDir is a string path to where the data lives
% subjects is a cell array of subject names
% days is a vector of days to investigate
% keyorder is a vector of keys ex. [1 2 3 4] for normal arrangment
% parsetype is either 'ascii' or 'binaryRS'
% showVisuals is bool

if(nargin ~= 6)
    error('Not the right number of arguments!');
end

%% Scoring for MFST_Mocap

%initialise vars for creation of xml file.
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment - essentially hard-coded b/c this is the first sequence slot available after the two familiarisation sequences
stimDuration=300;
isi=200;
WRITEFLAG=0; %output xml to file in dataDir, or not {0,1}

% setup basic information for data structure
PPs.stimuli=gen13ElementSeqs(LRNSeqID,stimDuration,isi,WRITEFLAG,dataDir);
PPs.date=date;
PPs.time=clock;
PPs.name='PPs';

clear WRITEFLAG;

blocks=6;
elemsPerSeq = 13;
scoringWindowOffset = 100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment
PPs=MFST_MC_prepareData2(dataDir,PPs,IDs,days,blocks,elemsPerSeq,scoringWindowOffset,isi,LRNSeqID,false,keyorder,parseType,showVisuals);
%MFST_MC_plotData(PPs,1);
% MFST_MC_plotData2(PPs,2);
% dbstop in ProcessMFSTMoCap 37
disp('Done Processing');
%disp('Saving output...');
%uisave('PPs',date);
