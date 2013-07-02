function BATCH_scoreMFST_MC()
%% Batch scoring for MFST_MC
%
%
% Requires that the sequences structure has been created with
% gen13ElementSeqs (note that this generates a particular set of sequences
% based on particular random seed - for Chris' MFST_MC experiment the seed
% was 19750909

% %setup basic path information
addpath('/home/raid1/steele/Documents/Projects/Working/BSL/scripts/matlab'); %path to the scoring scripts
dataDir='/home/raid1/steele/Documents/Projects/Working/BSL/scripts/';

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
%save('/home/chris/data/MFST_MC/PilotData/PPs.mat');
%%
%clear PPs.mat; %clear old data structure if it existed, prior to loading the correct one :-)
dataDir='/home/PENHUNE/MFST_MC/source/bx/PilotData/'; %path to the data
IDs={'Pilot_00' 'Pilot_01' 'Pilot_02' 'Pilot_03'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']
%load('/home/chris/data/MFST_MC/PilotData/PPs.mat');


%IDs={'P01' 'P02'};
days=6;
blocks=6;
stimDuration = 300; %duration of the stimulus
beforeTrialDelay = 200; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment
PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID);
%PPs=MFST_MC_scoreData(PPs,IDs,days,blocks); %for scoring within the structure
PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks); % for scoring into a single variable
%MFST_MC_plotData(PPs,1);
MFST_MC_plotData2(PPs,2);

%% Alternate Pilot data
% for some reason the scoring does not work for this data. Have not looked
% into the actual data files to see what the issue is, but will do so if
% these durations are used.
clear PPs.mat;
%IDs={'Pilot_00' 'Pilot_01' 'Pilot_02' 'Pilot_03'}; %ids of the individuals who will be scored
IDs={'AltPilot00'};
dataDir='/home/chris/data/MFST_MC/PilotData/AltPilotData';
load('/home/chris/data/MFST_MC/PilotData/PPAs.mat');
days=2;
blocks=6;
stimDuration = 150; %duration of the stimulus
beforeTrialDelay = 350; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-/
scoringWindowOffset = -100; %to account for predictive responses
PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset);
PPs=MFST_MC_scoreData(PPs,IDs,days,blocks); %for scoring within the structure
PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks); % for scoring in a single variable
MFST_MC_plotData(PPs,1);
MFST_MC_plotData2(PPs,2);


%% Run for test data that Rifat has collected
addpath('/home/PENHUNE/MFST_MC/scripts/matlab'); %path to the scoring scripts
dataDir='/home/tekguy/test/03302011/'; %path to the data
%IDs={'P01' 'P02' 'P03' 'P04' 'P05' 'P06' 'P07' 'P08' 'P09' 'P10' 'P11' 'P12' 'P13'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']
%load('/home/chris/data/MFST_MC/PilotData/PPs.mat');


IDs={'mike' 'mike_wire'};
IDs={'mike_MIDI' 'mike_lightMIDI'};

days=1;
blocks=2;
stimDuration = 300; %duration of the stimulus
%not required with Rifat's program
beforeTrialDelay = 0; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment


PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,false);
%PPs=MFST_MC_scoreData(PPs,IDs,days,blocks); %for scoring within the structure
PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks); % for scoring into a single variable
MFST_MC_plotData2(PPs,1);
MFST_MC_plotData2(PPs,2);

%% Starting to look at the 6 days of data - MFST_MC behavioural data set
dataDir='/home/PENHUNE/MFST_MC/source/bx/pilot/'; %path to the data
%IDs={'P01' 'P02' 'P03' 'P04' 'P05' 'P06' 'P07' 'P08' 'P09' 'P10' 'P11' 'P12' 'P13'}; %ids of the individuals who will be scored, corresponds to head of filename to be loaded ['IDs{1}' '_dXrY.txt']

% SCORING NOTES
% P06 only has 3 days of data, not included in the full data set here
% XXX P08_d6b3 and P11_d3b6 data are both the result of repeated blocks (necessitated
% by program crashes) XXX--> the scoring program has been changed such that
% when these IDs are used, the correct blocks are scored <--XXX
% P16 was a musician, synchrony data is excellent and removed (peak
% performance w/in 1st day
%

% IDs={'P06' 'P16'}; %bad data (see above) 
% Note that P16 actually has negative RTs!!! - yay for musicians! :-)

IDs={'P01' 'P02' 'P03' 'P04' 'P05' 'P07' 'P08' 'P09' 'P10' 'P11' 'P12' 'P13' 'P14' 'P15'};
IDs={IDs{:} 'P17' 'P18' 'P19' 'P20'}; % tfr2 data from P14 on

%IDs={'P14' 'P15' 'P16' 'P17' 'P18' 'P19' 'P20'}; % Ps from 14 on have the two transfer blocks, set this prior to rerunning scoredatamatrix and the plotting to see the position of this data

days=6;
blocks=6;
stimDuration = 300; %duration of the stimulus
%not required with Rifat's program
beforeTrialDelay = 200; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version) to correct timer mismatch :-( ; same as isi in most cases
scoringWindowOffset = -100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment


PPs=MFST_MC_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,true);
%PPs=MFST_MC_scoreData(PPs,IDs,days,blocks); %for scoring within the structure
PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks); % for scoring into a single variable
MFST_MC_plotData2(PPs,1);
MFST_MC_plotChunk(PPs);
MFST_PC_plotConsol(PPs,1,blocks,false);

%% Starting to look at the data from the bx part of the MRI pilot (using LabView presentation and collection)
% THis data was collected for comparison with Avrum's Musician's data (IEEE
% publication data set)
% beforeTrialDelay set correctly (-300)
dataDir='/home/PENHUNE/MFST_MC/source/bx/MRI_pilot/MAT_READ_FORMAT'; %path to the data

IDs={'Pilot_01' 'Pilot_02' 'Pilot_03' 'Pilot_04'}; %nonmusicians 6 days (NM_PPs)
%IDs={'Pilot_05' 'Pilot_06' 'Pilot_07' 'Pilot_08'}; %musicians 2 days (M_PPs)
%IDs={'ChrisFinalTest' 'ChrisTest2' 'TR' 'Pilot_01' 'Pilot_02' 'Pilot_03' 'Pilot_04'}; %for these pilots use a 300ms (duration time) for "beforeTrialDelay" to correct for timer reporting stim onffset as onset
%this is relevant for data collected with the following program: mfst_controlBox_pilottest2
%IDs={'ChrisFinalTest' 'TR'};

% IDs={'TG1'};
% IDs={'TR'};
days=6;
blocks=6;
stimDuration = 300; %duration of the stimulus
%not required with Rifat's program
beforeTrialDelay = -300; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version; = 200ms) to correct timer mismatch :-( ; same as isi in most cases
% this value must be set to -300 for use with the early trial version of the
% LabView program b/c it was reporting stim-off instead of stim on
scoringWindowOffset = -100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment


PPs=MFST_MC_MRI_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,false);
%PPs=MFST_MC_MRI_preparePosData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,false); %read in position data and prepare for analyses

PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,false); % for scoring into a single variable
MFST_MC_plotData2(PPs,1,false);
MFST_MC_plotData2(PPs,2,false);
%MFST_MC_plotChunk(PPs);
% MFST_PC_plotConsol(PPs,1,blocks,false);

%% NewKeyboard MRI pilot data
% THis data was collected to test the LabView program (Rifat) across two
% days of data collection
% beforeTrialDelay set correctly (-300) XXX is this required?

%Oct 26, 2011
%XXX when I run this the data does not look correct, need to look at the
%individual data files to determine what is going on. Could be another
%timing issue, or just bad data?

dataDir='/home/PENHUNE/MFST_MC/source/bx/NewKeyboardMRI_pilot/MAT_READ_FORMAT'; %path to the data

IDs={'Pilot_01' 'Pilot_02' 'Pilot_03' 'Pilot_04' 'Pilot_05' 'Pilot_06' 'Pilot_07' 'Pilot_08' 'Pilot_09' 'Pilot_10'}; %nonmusicians 6 days (NM_PPs)

days=2;
blocks=6;
stimDuration = 300; %duration of the stimulus
%not supposed to be required with Rifat's program, but may still be required
beforeTrialDelay = 0; %duration of pre-trial delay - required for data collected with the ADAPTIVE MFST (Ricco's version; = 200ms) to correct timer mismatch :-( ; same as isi in most cases
% this value must be set to -300 for use with the early trial version of the
% LabView program b/c it was reporting stim-off instead of stim on
scoringWindowOffset = -100; %to account for predictive responses
LRNSeqID=2; %set the index for the location (0-based) of the LRN sequence used in this experiment


PPs=MFST_MC_MRI_prepareData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,false);
%PPs=MFST_MC_MRI_preparePosData(dataDir,PPs,IDs,days,blocks,beforeTrialDelay,stimDuration,scoringWindowOffset,LRNSeqID,false,false); %read in position data and prepare for analyses

PPs=MFST_MC_scoreDataMatrix2(PPs,IDs,days,blocks,false); % for scoring into a single variable
MFST_MC_plotData2(PPs,1,false);
MFST_MC_plotData2(PPs,2,false);
%MFST_MC_plotChunk(PPs);
% MFST_PC_plotConsol(PPs,1,blocks,false);