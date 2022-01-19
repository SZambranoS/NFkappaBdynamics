function plot_trajs_singlecells(StackTrack,namefiletracks,filetrackfolder)

workingdir=pwd;


[Mmax,Nmax]=size(StackTrack(1).data);

figure(1)

cd(filetrackfolder)
load(namefiletracks);
cd(workingdir)
n_tracks = numel(tracks);
colors = hsv(n_tracks);
colors=colors(randperm(length(colors)),:);

all_points = vertcat(points{:});

 frames_points=[]; 
 for n=1:length(points)
 frames_points=[frames_points;n*ones(length(points{n}),1)];
 end; 



 

[nFrames,nCells]=size(matricesofX);




hStackTrack = axes('Position', [.05, .3, .45, .6]);

A=double(StackTrack(1).data);

minimum=mean(A(:))-std(A(:));

maximum=mean(A(:))+3*std(A(:)); 

limitstouse=[minimum, maximum]; 


imagesc(StackTrack(1).data, 'Parent', hStackTrack);



title(num2str(1))
colormap('gray')
%colormap('jet')
hold(hStackTrack, 'on');
pointsframe=points{1};
plot(pointsframe(:,1), pointsframe(:,2),'g+');

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
     StackTrack, nFrames,matricesofX,matricesofY,limitstouse,points));


hCellSlider = uicontrol( ...
    'Style', 'slider', ...
    'Value', 1,...
    'Min', 1,'Position',[30,24,500,23],...
    'Max',  nCells, ...
    'SliderStep', [1/nCells, 1/nCells],...
    'Callback', @(src, evt) changeCell(hStackTrack, hPlot, get(src, 'Value'),...
     StackTrack,  nFrames,matricesofX,matricesofY,limitstouse,points));









function changeFrame(hStackTrack, hPlot, iFrame, ...
    StackTrack, nFrames,matricesofX,matricesofY,limitstouse,points)


[Mmax,Nmax]=size(StackTrack(1).data);

iFrame = round(iFrame);
iCell = getappdata(hStackTrack, 'iCell');

X=matricesofX(:,iCell);
Y=matricesofY(:,iCell);



imagesc(StackTrack(iFrame).data, 'Parent', hStackTrack);


rightframes=find(~isnan(X));

hold(hStackTrack, 'on');
title(num2str(iFrame))
pointsframe=points{iFrame};
plot(hStackTrack,pointsframe(:,1), pointsframe(:,2),'g+');

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
StackTrack, nFrames,matricesofX,matricesofY,limitstouse,points)
[Mmax,Nmax]=size(StackTrack(1).data);

iFrame = getappdata(hStackTrack, 'iFrame');
iCell = round(iCell);


X=matricesofX(:,iCell);
Y=matricesofY(:,iCell);


imagesc(StackTrack(iFrame).data, 'Parent', hStackTrack);

hold(hStackTrack, 'on');

pointsframe=points{iFrame};
plot(hStackTrack,pointsframe(:,1), pointsframe(:,2),'g+');
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




