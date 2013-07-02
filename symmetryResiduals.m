function result = symmetryResiduals(in_signalX, in_signalY, in_XValueOfAxisOfSymmetry, in_numberOfPoints, in_refPointsSide)

%Author: Alejandro Endo
%Date: April 17, 2008
% TODO
%Parameters:
% TODO
%Returns:
%

axisIndex = binaryClosestSearch(in_XValueOfAxisOfSymmetry, in_signalX);

[xReflected, yReflected]=findSymmetricPoints(in_signalX, in_signalY, in_XValueOfAxisOfSymmetry, in_numberOfPoints, 'nearest', in_refPointsSide);

if (strcmpi(in_refPointsSide, 'left'))
    yOptimal = in_signalY(axisIndex-in_numberOfPoints:axisIndex);
else
    yOptimal = in_signalY(axisIndex: axisIndex+in_numberOfPoints);
end
    result = sum(abs(yReflected-yOptimal))/abs(xReflected(end) - xReflected(1)); %numerator is abs'd, how is that different (better? worse?) to squaring it? i'm always reluctant to square just to remove signs because it changes the shape of the result

