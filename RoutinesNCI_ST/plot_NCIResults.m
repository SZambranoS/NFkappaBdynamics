function plot_NCIResults(pathInput,Results, Stack)

figure(1)
pathroutines=pwd;
cd(pathInput)
load(Results);



matrixQUANT=matrixQUANT;
matrixareas=matrixareas;
matrixINTRING=matrixINTRING;
AverageBGQUANT=AverageBGQUANT;
matrixAREARING=matrixAREARING;

[nFrames,nCells]=size(matrixQUANT)

[matrixNCI] = functionNCI_ring(matrixQUANT, matrixareas, matrixINTRING,AverageBGQUANT);


size(matrixNCI)



maxaxis=max(max(matrixNCI)); 

hStack = axes('Position', [.05, .3, .45, .6]);

A=double(Stack(1).data);

minimum=mean(A(:))-std(A(:));

maximum=mean(A(:))+3*std(A(:)); 

limitstouse=[minimum, maximum]; 

imagesc(Stack(1).data,limitstouse);
%colormap('gray')
colormap('jet')

hPlot = axes('Position', [.55, .3, .40, .6]);

%plot(hPlot, [1:nFrames], matrixNCI(:,1),'g','linewidth',3, [1,1],[0,maxaxis]);
plot(hPlot, [1:nFrames], matrixNCI(:,1),'g',[1,1],[0,maxaxis]);


setappdata(hStack, 'iFrame', 1);
setappdata(hStack, 'iCell', 1);




hFrameSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1, 'Position',[30,64,500,23],...
    'Max',  nFrames, ...
    'SliderStep', [1/nFrames, 1/nFrames],...
    'Callback', @(src, evt) changeFrame(hStack, hPlot, get(src, 'Value'), ...
     OUT, Stack, nFrames,limitstouse,maxaxis,matrixNCI));


hCellSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1,'Position',[30,24,500,23],...
    'Max',  nCells, ...
    'SliderStep', [1/nCells, 1/nCells],...
    'Callback', @(src, evt) changeCell(hStack, hPlot, get(src, 'Value'),...
     OUT, Stack, nFrames,limitstouse,maxaxis,matrixNCI));









function changeFrame(hStack, hPlot, iFrame, ...
    OUT, Stack, nFrames ,limitstouse,maxaxis,matrixNCI)



%CropGFP=imfilter(CropGFP,fspecial('gaussian', 20,  1),'same');





iFrame = round(iFrame);
iCell = getappdata(hStack, 'iCell');

imagetouse=Stack(iFrame).data;
imagetouse=imfilter(imagetouse,fspecial('gaussian', 20,  1),'same');



imagesc(imagetouse, 'Parent', hStack,limitstouse);


if(iFrame<=OUT{iCell}.maxFrame)

axis(hStack, [max(OUT{iCell}.Baricenter(iFrame,1)-100,1), min(OUT{iCell}.Baricenter(iFrame,1)+100,1024), max(OUT{iCell}.Baricenter(iFrame,2)-100,1),min(OUT{iCell}.Baricenter(iFrame,2)+100,1024)]);

end;





plot(hPlot, [1:nFrames], matrixNCI(:,iCell),'g',[iFrame,iFrame],[0,maxaxis])
    


title(num2str(iCell))
 
 


setappdata(hStack, 'iFrame', iFrame);




function changeCell(hStack, hPlot,  iCell, ...
    OUT, Stack, nFrames,limitstouse,maxaxis,matrixNCI)

iFrame = getappdata(hStack, 'iFrame');
iCell = round(iCell);


imagetouse=Stack(iFrame).data;
imagetouse=imfilter(imagetouse,fspecial('gaussian', 20,  1),'same');


imagesc(imagetouse, 'Parent', hStack,limitstouse);


if(iFrame<=OUT{iCell}.maxFrame)

axis(hStack, [max(OUT{iCell}.Baricenter(iFrame,1)-100,1), min(OUT{iCell}.Baricenter(iFrame,1)+100,1024), max(OUT{iCell}.Baricenter(iFrame,2)-100,1),min(OUT{iCell}.Baricenter(iFrame,2)+100,1024)]);

end;

plot(hPlot, [1:nFrames], matrixNCI(:,iCell),'g',[iFrame,iFrame],[0,maxaxis])
    
title(num2str(iCell))
setappdata(hStack, 'iCell', iCell);




