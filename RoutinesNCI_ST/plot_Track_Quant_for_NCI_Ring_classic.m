function plot_Track_Quant_for_NCI_Ring_classic(OUT, Stackp65, nCells, nFrames,matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT)


h = figure(1);

set(h, 'units','normalized', 'Position', [0.05 .05 0.9 .9])


[matrixNCI]= functionNCI_ring(matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT); 
 

maxvalue=max(max(matrixNCI));

hStack = axes('Position', [.05, .3, .45, .6]);

A=double(Stackp65(1).data);

minimum=mean(A(:))-std(A(:));

maximum=mean(A(:))+5*std(A(:)); 

limitstousep65=[minimum, maximum]; 

imagesc(Stackp65(1).data,limitstousep65);
colormap('gray')


hPlot = axes('Position', [.55, .3, .40, .6]);

plot(hPlot, [1:nFrames],matrixNCI(:,1),...
    [1,1],[0,maxvalue]);



setappdata(hStack, 'iFrame', 1);
setappdata(hStack, 'iCell', 1);



hFrameSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1, 'Position',[30,64,500,23],...
    'Max',  nFrames, ...
    'SliderStep', [1/nFrames, 1/nFrames],...
    'Callback', @(src, evt) changeFrame(hStack, hPlot, get(src, 'Value'), ...
     OUT, Stackp65, nFrames,limitstousep65,matrixNCI));


hCellSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1,'Position',[30,24,500,23],...
    'Max',  nCells, ...
    'SliderStep', [1/nCells, 1/nCells],...
    'Callback', @(src, evt) changeCell(hStack, hPlot, get(src, 'Value'),...
     OUT, Stackp65, nFrames,limitstousep65,matrixNCI));









function changeFrame(hStack, hPlot, iFrame, ...
    OUT, Stackp65, nFrames ,limitstousep65,matrixNCI)



maxvalue=max(max(matrixNCI));

iFrame = round(iFrame);
iCell = getappdata(hStack, 'iCell');


imagesc(Stackp65(iFrame).data, 'Parent', hStack,limitstousep65);


if iFrame <= OUT{iCell}.maxFrame
hold(hStack, 'on');
plot(hStack,OUT{iCell}.Baricenter(iFrame,1), OUT{iCell}.Baricenter(iFrame,2),'or',...
    'MarkerSize', 9);

title(num2str(iCell))
hold(hStack, 'off');
end



plot(hPlot, [1:nFrames],matrixNCI(:,iCell),...
    [iFrame,iFrame],[0,maxvalue]);
title(num2str(iCell))
 
 


setappdata(hStack, 'iFrame', iFrame);




function changeCell(hStack, hPlot,  iCell, ...
    OUT, Stack, nFrames,limitstousep65,matrixNCI)

maxvalue=max(max(matrixNCI));

iFrame = getappdata(hStack, 'iFrame');
iCell = round(iCell);



imagesc(Stack(iFrame).data, 'Parent', hStack,limitstousep65);


if iFrame <= OUT{iCell}.maxFrame
hold(hStack, 'on');
plot(hStack,OUT{iCell}.Baricenter(iFrame,1), OUT{iCell}.Baricenter(iFrame,2),'or',...
    'MarkerSize', 9);
hold(hStack, 'off');
end


plot(hPlot, [1:nFrames],matrixNCI(:,iCell),...
    [iFrame,iFrame],[0,maxvalue]);
title(num2str(iCell))
setappdata(hStack, 'iCell', iCell);




