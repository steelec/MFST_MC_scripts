% Graphing chunk size vs num chunks vs accuracy
% ***CALLED FROM WITHIN NEW_CHUNKS function! ***
function GraphChunksVsAcc(IDs, Days, chunkSize, numChunks, acc, titleSuffix, saveViews)
% This expects input matrices where each column is a day (or other time
% period) and each row is a subject (or some other thing). Really it just
% plots rows of data in a cool way, with a mean line plot included.
% 
% Inputs:
% IDs = a cell array of names
% Days = a vector of days ex [1 2 3 4 5 6]
% chunkSize, numChunks, acc = matrices of the same size, to be plotted
% titleSuffix = a string you may want to add to the title (ex. 'Max')
% saveViews = if nonzero you save all 3 orthogonal views and isometric as images
% (C) Joseph Thibodeau MA BASc Esq 2014


    numD = length(Days);
    numS = length(IDs);

    % some colour options
    colourDiv = 2;
    colourOffset = 0.5;
    widthMin = 1;
    widthMax = 2;
    widthRange = widthMax-widthMin;
    widths = widthMin:widthRange/numD:widthMax;
    
    lstyles = {'-','--','-.',':'};
    lstyleMax = 4; %max number of line styles

    % scatter plot stuff
    markerMultiplier = 40;
    markerSizes = [1:numD].*markerMultiplier;

    % figure handles
    figs = [];

    % legend labels
    leg = {};

    % overall colormap
    subjColours = colormap(hsv(length(IDs))); %set colormap to 15 (num subjects)

    currentFigure = figure;
    hold on
    for s = 1:numS
        legs{s} = IDs{s}; %legend handle for this subject
        tc = subjColours(s,:); %this colour
        lstyle = lstyles{mod(s-1,lstyleMax)+1}; % this line style
        % make a smaller colour map for this subject, with 6 points
        cmap = repmat(tc,numD,1);
        for d = 1:numD
            cmap(d,:) = cmap(d,:)./d./colourDiv + (colourOffset.*(cmap(d,:) > 0)); %includes some fudging to get nicer saturation
            %cmap(d,:) = cmap(d,:)./d./colourDiv + colourOffset; %a little desaturated to go in background
        end %making cmap

        scatter3(chunkSize(s,:),numChunks(s,:), acc(s,:), markerSizes, cmap, 'filled') % mark the points on this line

        % then plot each line segment for this subject with a different colour and thickness
        for d = 1:(numD-1)
            figs(s) = plot3(chunkSize(s,d:d+1),numChunks(s,d:d+1), acc(s,d:d+1), 'LineStyle', lstyle, 'LineWidth', widths(d), 'Color', cmap(d,:));
        end %days
    end %subjects

    % FINALLY do the MEAN PLOT
    legs{s+1} = 'Mean';
    tc = [0,0,0]; %BLACK
    cmap = repmat(tc,numD,1);
    for d = 1:numD
        cmap(d,:) = cmap(d,:)./d./colourDiv + (colourOffset.*(cmap(d,:) > 0)); %includes some fudging to get nicer saturation
    end %making cmap

    allCSMeans = nanmean(chunkSize);
    allNCMeans = nanmean(numChunks);
    allaccs = nanmean(acc);

    scatter3(allCSMeans, allNCMeans, allaccs, markerSizes.*2, cmap,'filled') % mark the points on this line

    % then plot each line segment for this subject with a different colour and thickness
    for d = 1:(numD-1)
        figs(s+1) = plot3(allCSMeans(d:d+1),allNCMeans(d:d+1), allaccs(d:d+1), 'LineStyle', '-', 'LineWidth', widths(d)*2, 'Color', cmap(d,:));
    end %days

    legend(figs,legs,'Location', 'EastOutside');
    xlabel('Chunk Size');
    ylabel('Num Chunks');
    zlabel('Accuracy');
    title(['Accuracy (Mean) Vs Chunk Measures (' titleSuffix ') by Day']);
    view([47 7]);
    grid on;
    hold off
    
    if (saveViews ~= 0)
        saveas(currentFigure,['pics/AccVsChunking' titleSuffix '.fig']);
        view([90 0]);
        print(currentFigure, '-dpng','-r300',['pics/AccVsChunking' titleSuffix '_View1.png']);
        view([0 0]);
        print(currentFigure, '-dpng','-r300',['pics/AccVsChunking' titleSuffix '_View2.png']);
        view([0 90]);
        print(currentFigure, '-dpng','-r300',['pics/AccVsChunking' titleSuffix '_View3.png']);
    end
    
    view([47 7]);
end