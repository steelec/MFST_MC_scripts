% some impromptu scripting for MFST visualizations 2014/05/07
numD = length(Days);
numS = length(IDs);

% some colour options
colourDiv = 2;
colourOffset = 0.5;
widthMin = 1;
widthMax = 2;
widthRange = widthMax-widthMin;
widths = widthMin:widthRange/numD:widthMax;
lstyle = '-';

% scatter plot stuff
markerMultiplier = 50
markerSizes = [1:numD].*markerMultiplier;

% figure handles
figs = [];

% legend labels
leg = {};

% overall colormap
subjColours = colormap(jet(length(IDs))); %set colormap to 15 (num subjects)

figure(99)
close(99)
figure(99)
hold on
for s = 1:numS
    legs{s} = IDs{s}; %legend handle for this subject
    tc = subjColours(s,:); %this colour
    % make a smaller colour map for this subject, with 6 points
    cmap = repmat(tc,numD,1);
    for d = 1:numD
        cmap(d,:) = cmap(d,:)./d./colourDiv + (colourOffset.*(cmap(d,:) > 0)); %includes some fudging to get nicer saturation
    end %making cmap
    
    scatter3(chunkSizeMean(s,:),numChunksMean(s,:), accMean(s,:), markerSizes, cmap, 'filled') % mark the points on this line
    
    % then plot each line segment for this subject with a different colour and thickness
    for d = 1:(numD-1)
        figs(s) = plot3(chunkSizeMean(s,d:d+1),numChunksMean(s,d:d+1), accMean(s,d:d+1), 'LineStyle', lstyle, 'LineWidth', widths(d), 'Color', cmap(d,:));
    end %days
end %subjects
legend(figs,legs);
xlabel('Chunk Size');
ylabel('Num Chunks');
zlabel('Accuracy');
view([47 7]);
grid on;
hold off