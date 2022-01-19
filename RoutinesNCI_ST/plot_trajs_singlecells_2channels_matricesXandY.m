function plot_trajs_singlecells_2channels_matricesXandY(StackTrack,StackBG,matricesofX,matricesofY)

workingdir=pwd;


[Mmax,Nmax]=size(StackTrack(1).data);

figure(1)

cd(workingdir)
 

[nFrames,nCells]=size(matricesofX);






hStackTrack = axes('Position', [.05, .3, .45, .6]);

A=double(StackTrack(1).data);

minimum=mean(A(:))-std(A(:));

maximum=mean(A(:))+3*std(A(:)); 

limitstouse=[minimum, maximum]; 

%redSlice = (2^16)*(StackBG(1).data-min(StackBG(1).data(:)))/((max(StackBG(1).data(:))));
redSlice = 3*StackBG(1).data;
greenSlice = 3*StackTrack(1).data;
blueSlice=zeros(size(StackTrack(1).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
imagesc(rgbForThisTime,[0 200]);



title(num2str(1))
colormap('gray')
%colormap('jet')
hold(hStackTrack, 'on');
%plot(hStackTrack,matricesofX(1,:), matricesofY(1,:),'g+');


hPlot = axes('Position', [.55, .3, .40, .6]);

X=matricesofX(:,1);
Y=matricesofY(:,1);

rightframes=find(~isnan(X));
plot(hPlot,X,Y,'g',matricesofX(1,1),matricesofY(1,1),'ko');
axis([1 Mmax 1 Nmax])
set(hPlot,'Ydir','reverse')

%axis([1 Mmax 1 Nmax]);
%axis([matricesofX(1,1)-200, matricesofX(1,1)+200, matricesofY(1,1)-200,matricesofY(1,1)+200]);

setappdata(hStackTrack, 'iFrame', 1);
setappdata(hStackTrack, 'iCell', 1);

[nFrames,nCells]=size(matricesofX)


hFrameSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1, 'Position',[30,64,500,23],...
    'Max',  nFrames, ...
    'SliderStep', [1/nFrames, 1/nFrames],...
    'Callback', @(src, evt) changeFrame(hStackTrack, hPlot, get(src, 'Value'), ...
     StackTrack, StackBG, nFrames,matricesofX,matricesofY,limitstouse));


hCellSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1,'Position',[30,24,500,23],...
    'Max',  nCells, ...
    'SliderStep', [1/nCells, 1/nCells],...
    'Callback', @(src, evt) changeCell(hStackTrack, hPlot, get(src, 'Value'),...
     StackTrack, StackBG, nFrames,matricesofX,matricesofY,limitstouse));









function changeFrame(hStackTrack, hPlot, iFrame, ...
    StackTrack, StackBG, nFrames,matricesofX,matricesofY,limitstouse)


[Mmax,Nmax]=size(StackTrack(1).data);

iFrame = round(iFrame);
iCell = getappdata(hStackTrack, 'iCell');

X=matricesofX(:,iCell);
Y=matricesofY(:,iCell);

redSlice = 3*StackBG(iFrame).data;
greenSlice = 3*StackTrack(iFrame).data;
blueSlice=zeros(size(StackTrack(iFrame).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
image(rgbForThisTime,'Parent', hStackTrack);

rightframes=find(~isnan(X));

hold(hStackTrack, 'on');
title(num2str(iFrame));

%plot(hStackTrack,matricesofX(iFrame,:), matricesofY(iFrame,:),'g+');

if (iFrame<=max(rightframes)) && (iFrame>=min(rightframes))

    
    
    
%axis(hStackTrack, [max(X(iFrame)-200,1), min(X(iFrame)+200,1024), max(Y(iFrame)-200,1),min(Y(iFrame)+200,1024)]);


axis([1 Mmax 1 Nmax])
    
hold(hStackTrack, 'on');
plot(hStackTrack,X(iFrame), Y(iFrame),'or',...
    'MarkerSize', 9);
hold(hStackTrack, 'off');


else
    
axis([1 Mmax 1 Nmax])

    set(hPlot,'Ydir','reverse')
    

end;





plot(hPlot, matricesofX(:,iCell),matricesofY(:,iCell),'g',matricesofX(iFrame,iCell),matricesofY(iFrame,iCell),'ko')
[Mmax,Nmax]=size(StackTrack(1).data);
axis([1 Mmax 1 Nmax])
    set(hPlot,'Ydir','reverse')
    




title(num2str(iCell))
 title(hStackTrack, num2str(iFrame))
setappdata(hStackTrack, 'iFrame', iFrame);




function changeCell(hStackTrack, hPlot,  iCell, ...
StackTrack, StackBG, nFrames,matricesofX,matricesofY,limitstouse)
[Mmax,Nmax]=size(StackTrack(1).data);

iFrame = getappdata(hStackTrack, 'iFrame');
iCell = round(iCell);


X=matricesofX(:,iCell);
Y=matricesofY(:,iCell);

redSlice = 3*StackBG(iFrame).data;
greenSlice = 3*StackTrack(iFrame).data;
blueSlice=zeros(size(StackTrack(1).data)); 
rgbForThisTime = cat(3, redSlice, greenSlice, blueSlice);
image(rgbForThisTime,'Parent', hStackTrack);

hold(hStackTrack, 'on');


%plot(hStackTrack,matricesofX(iFrame,:), matricesofY(iFrame,:),'g+');
rightframes=find(~isnan(X));


if (iFrame<=max(rightframes)) && (iFrame>=min(rightframes))

%axis(hStackTrack, [max(X(iFrame)-200,1), min(X(iFrame)+200,1024), max(Y(iFrame)-200,1),min(Y(iFrame)+200,1024)]);

axis([1 Mmax 1 Nmax])
    
hold(hStackTrack, 'on');
plot(hStackTrack,X(iFrame), Y(iFrame),'or',...
    'MarkerSize', 9);
hold(hStackTrack, 'off');
axis([1 Mmax 1 Nmax])


else

 axis([1 Mmax 1 Nmax])
    set(hPlot,'Ydir','reverse')
    

   
    
end;


plot(hPlot, matricesofX(:,iCell),matricesofY(:,iCell),'g',matricesofX(iFrame,iCell),matricesofY(iFrame,iCell),'ko')

axis([1 Mmax 1 Nmax])

    set(hPlot,'Ydir','reverse')
    

title(num2str(iCell))


title(hStackTrack, num2str(iFrame))
setappdata(hStackTrack, 'iCell', iCell);




