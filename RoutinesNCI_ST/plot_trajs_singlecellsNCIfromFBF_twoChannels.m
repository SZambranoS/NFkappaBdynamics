function plot_trajs_singlecellsNCIfromFBF_twoChannels(StackGFP,StackRFP,namefiletracks,filetrackfolder)




figure(1)
pathroutines=pwd;
cd(filetrackfolder)
load(namefiletracks);
cd(pathroutines)


matrixQUANT=matrixQUANT;
matrixareas=matrixareas;
matrixINTRING=matrixINTRING;
AverageBGQUANT=AverageBGQUANT;
matrixAREARING=matrixAREARING;

[nFrames,nCells]=size(matrixQUANT)

[matrixNCI] = functionNCI_ring(matrixQUANT, matrixareas, matrixINTRING,AverageBGQUANT);





[Mmax,Nmax]=size(StackGFP(1).data);

 

[nFrames,nCells]=size(matricesofXtracks);




hStackTrack = axes('Position', [.05, .3, .45, .6]);

A=double(StackGFP(1).data);

minimum=mean(A(:))-std(A(:));

maximum=mean(A(:))+3*std(A(:)); 

limitstouse=[minimum, maximum]; 


redSlice = StackRFP(1).data;
greenSlice = StackGFP(1).data;
blueSlice=zeros(size(StackGFP(1).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
image(rgbForThisTime,'Parent', hStackTrack);



title(num2str(1))
colormap('gray')
%colormap('jet')
hold(hStackTrack, 'on');
pointsframe=[matricesofXtracks(1,:)',matricesofYtracks(1,:)'];
plot(pointsframe(:,1), pointsframe(:,2),'g+');

hPlot = axes('Position', [.55, .3, .40, .6]);

X=matricesofXtracks(:,1);
Y=matricesofYtracks(:,1);

rightframes=find(~isnan(X));
plot(hPlot,X,Y,'g',matricesofXtracks(1,1),matricesofYtracks(1,1),'ko');
plot(hPlot, [1:nFrames], matrixNCI(:,1),'g',[1,1],[0,4])
axis([1, nFrames, 0 5])    


%axis([1 Mmax 1 Nmax]);
%axis([matricesofXtracks(1,1)-200, matricesofXtracks(1,1)+200, matricesofYtracks(1,1)-200,matricesofYtracks(1,1)+200]);

setappdata(hStackTrack, 'iFrame', 1);
setappdata(hStackTrack, 'iCell', 1);

[nFrames,nCells]=size(matricesofXtracks)


hFrameSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1, 'Position',[30,64,500,23],...
    'Max',  nFrames, ...
    'SliderStep', [1/nFrames, 1/nFrames],...
    'Callback', @(src, evt) changeFrame(hStackTrack, hPlot, get(src, 'Value'), ...
     StackGFP, StackRFP, nFrames,matricesofXtracks,matricesofYtracks,limitstouse,matrixNCI));


hCellSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1,'Position',[30,24,500,23],...
    'Max',  nCells, ...
    'SliderStep', [1/nCells, 1/nCells],...
    'Callback', @(src, evt) changeCell(hStackTrack, hPlot, get(src, 'Value'),...
     StackGFP, StackRFP, nFrames,matricesofXtracks,matricesofYtracks,limitstouse,matrixNCI));









function changeFrame(hStackTrack, hPlot, iFrame, ...
    StackGFP, StackRFP, nFrames,matricesofXtracks,matricesofYtracks,limitstouse,matrixNCI)


[Mmax,Nmax]=size(StackGFP(1).data);

iFrame = round(iFrame);
iCell = getappdata(hStackTrack, 'iCell');

X=matricesofXtracks(:,iCell);
Y=matricesofYtracks(:,iCell);



redSlice = StackRFP(iFrame).data;
greenSlice = StackGFP(iFrame).data;
blueSlice=zeros(size(StackGFP(iFrame).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
image(rgbForThisTime,'Parent', hStackTrack);
%imagesc(StackGFP(iFrame).data, 'Parent', hStackTrack);


rightframes=find(~isnan(X));

hold(hStackTrack, 'on');
title(num2str(iFrame))
pointsframe=[matricesofXtracks(iFrame,:)',matricesofYtracks(iFrame,:)'];
plot(hStackTrack,pointsframe(:,1), pointsframe(:,2),'g+');

if (iFrame<=max(rightframes)) && (iFrame>=min(rightframes))

    
    
    
%axis(hStackTrack, [max(X(iFrame)-200,1), min(X(iFrame)+200,1024), max(Y(iFrame)-200,1),min(Y(iFrame)+200,1024)]);


axis([1 Mmax 1 Nmax])
    
hold(hStackTrack, 'on');
plot(hStackTrack,X(iFrame), Y(iFrame),'oy',...
    'MarkerSize', 9);
hold(hStackTrack, 'off');


else
    
axis([1 Mmax 1 Nmax])

    set(hPlot,'Ydir','reverse')
    

end;





plot(hPlot, [1:nFrames], matrixNCI(:,iCell),'g',[iFrame,iFrame],[0,4])
axis([1, nFrames, 0 5])    
    




title(num2str(iCell))
 title(hStackTrack, num2str(iFrame))
setappdata(hStackTrack, 'iFrame', iFrame);




function changeCell(hStackTrack, hPlot,  iCell, ...
StackGFP, StackRFP, nFrames,matricesofXtracks,matricesofYtracks,limitstouse,matrixNCI)
[Mmax,Nmax]=size(StackGFP(1).data);

iFrame = getappdata(hStackTrack, 'iFrame');
iCell = round(iCell);


X=matricesofXtracks(:,iCell);
Y=matricesofYtracks(:,iCell);

redSlice = StackRFP(iFrame).data;
greenSlice = StackGFP(iFrame).data;
blueSlice=zeros(size(StackGFP(iFrame).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
image(rgbForThisTime,'Parent', hStackTrack);
%imagesc(StackGFP(iFrame).data, 'Parent', hStackTrack);
hold(hStackTrack, 'on');


pointsframe=[matricesofXtracks(iFrame,:)',matricesofYtracks(iFrame,:)'];
plot(hStackTrack,pointsframe(:,1), pointsframe(:,2),'g+');
rightframes=find(~isnan(X));


if (iFrame<=max(rightframes)) && (iFrame>=min(rightframes))

%axis(hStackTrack, [max(X(iFrame)-200,1), min(X(iFrame)+200,1024), max(Y(iFrame)-200,1),min(Y(iFrame)+200,1024)]);

axis([1 Mmax 1 Nmax])
    
hold(hStackTrack, 'on');
plot(hStackTrack,X(iFrame), Y(iFrame),'oy',...
    'MarkerSize', 9);
hold(hStackTrack, 'off');
axis([1 Mmax 1 Nmax])


else

 axis([1 Mmax 1 Nmax])
    set(hPlot,'Ydir','reverse')
    

   
    
end;



plot(hPlot, [1:nFrames], matrixNCI(:,iCell),'g',[iFrame,iFrame],[0,4])
axis([1, nFrames, 0 5])    
        
    

title(num2str(iCell))


title(hStackTrack, num2str(iFrame))
setappdata(hStackTrack, 'iCell', iCell);




