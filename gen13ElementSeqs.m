function [scoringSeq seq]=gen13ElementSeqs(LRNseqID,dur,isi, WRITEFLAG,outDir)
% Script to create the list of possible 13-element sequences (4-finger)
% following the specified rules (see gen13), randomly select a
% subset of them for use in an experiment (in this case, MFST_MC), and then
% create the .xml config file for use with the adaptive MFST program
%
% input:
%   <LRNseqID>      - 0-based index of location of repeated sequence for
%                     use in XML and scoringSeq
%   <dur>           - stimulus duratino
%   <isi>           - interstimulus interval
%   <WRITEFLAG>     - 1 to write xml file, 0 to not (skips most code
%                     associated w/ xml formatting and stops output)
%   <outDir>        - output directory for xml file, required even if no
%                     output requested (but not used in this case)
%
% output:
%   <scoringSeq>    - structure with the following information:
%                       - .id      - presentation order of sequences by block
%                       - .scoring - presentation order of elements in each
%                                    trial, organised by block
%
% Chris Steele
% Oct 06, 2010
%

%set general use variables
%addpath('/home/chris/matlab');
allSeq=gen13; %generates the 496 unique 13-element sequences for four locations
seqlength=13; %set sequence length that was used in gen13
rand('seed',19750909); %seed with number so that I can get the same sequences every time (randomly...)
numseq=6*6*4+2+2; %6 days, 6 blocks per day, 4 unique randoms per block + one LRN sequence and 1 TFR sequence
numseq=496 %temp change to get more random sequences out of the possible 496
%randomly select a number of sequences from 1 to 496, uniquely
selectRows=randperm(length(allSeq));
days=10;
blocks=6;
repeats=10;
randoms=4;
seqln=13; %num elements in each sequence
blockln=repeats+randoms;
sequenceID=3; %order of the first sequence (from this generation program) appearance in the .xml config file, 1-based.
blockID=3; %as above, but for blocks
% dur=300; isi=200; %now specified as input
stimID=0; %bkgrnd colour and character that jumps around...
xmlBlockDesc={};
% LRNseqID=2; %index of the LRN sequence in the config file. Should be the 1st sequence after the two practice sequences; now specified as input
RNDseqID=1; %index offset of first RND sequencece


%first two are LRN and TFR sequences, the rest are the random sequences
%that will be used only once each. The number should equal
%numrandsperblock*numblocks*numdays +2
seq=allSeq(selectRows,:);

if WRITEFLAG==1
    %create the xml formatting required for the MFST xml configuration3.xml
    %file
    head=['<sequence length="' num2str(seqlength) '">'];
    preText='<sequenceItem>';
    postText='</sequenceItem>';
    foot='</sequence>';
    
    %xmlSeqDesc=cell(numseq*(seqlength+2)+2,1);
    xmlSeqDesc={};
    xmlSeqDesc=cellAppend(xmlSeqDesc,'down','<!-- numOfSequences is automatically generated, change according to the number of sequences that are present prior to the first here and move those sequences inside this tag');
    xmlSeqDesc=cellAppend(xmlSeqDesc,'down','references to sequence numbers should also be adjusted accordingly -->');
    xmlSeqDesc=cellAppend(xmlSeqDesc,'down',['<stimSequences numOfSequences="',num2str(numseq),'">']);
    
    for idx=1:numseq %what sequence am I in?
        xmlSeqDesc=cellAppend(xmlSeqDesc,'down',['<!-- Sequence number ' num2str(idx)]);
        xmlSeqDesc=cellAppend(xmlSeqDesc,'down','-->');
        xmlSeqDesc=cellAppend(xmlSeqDesc,'down',head);
        for idx2=1:seqlength %what element of the sequence am I in?
            xmlSeqDesc=cellAppend(xmlSeqDesc,'down',[preText,num2str(seq(idx,idx2)),postText]);
        end
        xmlSeqDesc=cellAppend(xmlSeqDesc,'down',foot);
    end
    xmlSeqDesc=cellAppend(xmlSeqDesc,'down','</stimSequences>');
    
    % generate the xml for individual blocks for each of the days
end
for day=1:days
    for block=1:blocks
        if WRITEFLAG==1
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',strcat('<configuration ID="', num2str(blockID), '">'));
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<description>Day ', num2str(day), ' Block ', num2str(block), '</description>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down','<adapt>false</adapt>');
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down','<adaptRecalculationWindow>2</adaptRecalculationWindow>');
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down','<adaptSuccessCriterion>0.75</adaptSuccessCriterion>');
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<afterTrialDelay>', num2str(isi),'</afterTrialDelay>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<beforeTrialDelay>', num2str(isi),'</beforeTrialDelay>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<stimDuration>', num2str(dur),'</stimDuration>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<initialISI>', num2str(isi),'</initialISI>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<numOfStimsPerTrial>', num2str(seqln),'</numOfStimsPerTrial>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<numOfTrials>', num2str(blockln),'</numOfTrials>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<stimID>', num2str(stimID),'</stimID>']);
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down','<stopAfterTrial>false</stopAfterTrial>');
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down','<numOfStimPositions>4</numOfStimPositions>');
            xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<orderOfSequences length="', num2str(blockln),'">']);
        end
        % calculate what this block will look like
        % no consecutive randoms (done by doubling the vector and placing
        % 1s in between all possible locations)
        % always start/end with LRN sequence
        
        a=sort(randsample(repeats-1,randoms)); % 9 possible positions for randoms to fit (num repeats-2 (for ends) +1 for space @ end) within the order of sequences within the block, 4 randoms to insert
        a=a*2-1; %turn a into the index that is required for anyBlock
        anyBlock=repmat([-1,1],1,repeats-2); %index of -1 and 1s where 1s are repeated sequences and -1s are either extra or randoms
        anyBlock(a)=0;
        anyBlock(anyBlock==-1)=[]; %remove those that were not chosen
        thisBlock=logical([1 anyBlock 1]); %padd start and end of block with repeated LRN sequence
        
        for seqItem=1:blockln
            if thisBlock(seqItem)
                xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<sequenceItem>', num2str(LRNseqID),'</sequenceItem>']);
                cmd=['sequences.id.d' num2str(day) 'b' num2str(block) '(' num2str(seqItem) ')=' num2str(LRNseqID) ';']; % this will have to be re-indexed properly (-1)
                eval(cmd);
            else
                xmlBlockDesc=cellAppend(xmlBlockDesc,'down',['<sequenceItem>', num2str(LRNseqID+RNDseqID),'</sequenceItem>']);
                cmd=['sequences.id.d' num2str(day) 'b' num2str(block) '(' num2str(seqItem) ')=' num2str(LRNseqID+RNDseqID) ';']; % this will have to be re-indexed properly (-1)
                eval(cmd);
                RNDseqID=RNDseqID+1;
            end
        end
        blockID=blockID+1;
        xmlBlockDesc=cellAppend(xmlBlockDesc,'down','</orderOfSequences>');
        xmlBlockDesc=cellAppend(xmlBlockDesc,'down','</configuration>');
    end
end

%% Now create scoring setup by linking the blocks to the individual sequences
for day=1:days
    for block=1:blocks
        for seqIdx=1:blockln
            cmd=['sequences.scoring.d' num2str(day) 'b' num2str(block) '(seqIdx,:)=seq(sequences.id.d' num2str(day) 'b' num2str(block) '(' num2str(seqIdx) ') -1,:);'];
            eval(cmd);
        end
    end
end

scoringSeq=sequences;

%save to file
%(does not include setting some of the global information that is
%contained at the bottom of the file, cut and paste this into an existing
%xml configuration file to add your sequences as it changes for each
%experiment
if WRITEFLAG==1
    filename=strcat(outDir,'/configuration3.xml');
    file1=fopen(filename,'w');
    fprintf(file1,'%s\n',xmlBlockDesc{:});
    fprintf(file1,'\n\n');
    fprintf(file1,'%s\n',xmlSeqDesc{:});
    fclose(file1);
    fprintf('Done Done Done Done Done. The XML schema has been written to:\n %s\n',filename);
elseif WRITEFLAG==0
    %do nothing
else
    fprintf('WRITEFLAG must be set to 0 (no output) or 1 (xml output)');
end
