function [LabelsMap, cellROIs_refined,refinedmask,roughmask] = Track_NCI_Ring_classic_FrameByFrame(StackTrack,StackQuant, parCellTrack, filenameprint, filenamesave, shallweplot,pathoutput)


%This is classic because we calculate the ring around the nucleus in the
%same way as in the eLife paper.


%Created in August 2018. To be used for ST dynamics in situations in which
%it is difficult to segment the cells. This function will search for the
%cells in each frame, keep the best and avoid the tracking between frames.
%This should allow to see spatial patterns of activation. 

parCellSeg=parCellTrack(1:5);
TolArea=parCellTrack(6);
RingWidth=parCellTrack(7);
FactorBG=parCellTrack(8);
sigmaforring=parCellTrack(9);


pathroutines=pwd;


nFrames = length(StackTrack);

for i = 1:nFrames;
    [cellROIs_refined(i),roughmask(i).data,refinedmask(i).data] = segment_fromImage_refined_cluster(StackTrack(i).data, parCellSeg);
    disp(i)
end
clear i


%% We do not track cells anymore. 



for i=1:nFrames

    cd(pathroutines)
    
    
[LabelsMap, LabelsRing, OUT, nCells,TotalintensityTrack,TotalintensityQuant,TotalintensitySignalQuant,ObjectsPerFrame,AverageBGQUANT] = track_and_quantify_2channels_forNuctoCyto_classical(cellROIs_refined(i), StackTrack(i), StackQuant(i), 1, TolArea,RingWidth,FactorBG,sigmaforring);

figure(101)
imagesc(LabelsMap(1).data)
figure(102)
imagesc(LabelsRing(1).data)
pause(1) 


% 
% for n=1:nFrames
%     figure(101)
%     imagesc(LabelsMap(n).data)
%     figure(102)
%     imagesc(LabelsRing(n).data)
% 
% end;


%%%Extract information of interest in matrices, each column corresponds to
%%%a cell.

areas=-1*ones(1,nCells);
QUANT=-1*ones(1,nCells);
TRACK=-1*ones(1,nCells);
Lengthboundaries=-1*ones(1,nCells);
INTRING=-1*ones(1,nCells);
AREARING=-1*ones(1,nCells);
xbaricenter=-1*ones(1,nCells);
ybaricenter=-1*ones(1,nCells);

nCells

for n=1:nCells
    nframes(1,n)=OUT{n}.maxFrame;
    areas(1,n)=OUT{n}.Area;
    QUANT(1,n)=OUT{n}.TotalIntensityQuant;
    TRACK(1,n)=OUT{n}.TotalIntensityTrack;
    INTRING(1,n)=OUT{n}.RingIntQuant;
    AREARING(1,n)=OUT{n}.RingArea;
    Lengthboundaries(1,n)=OUT{n}.LengthBoundary;
    xbaricenter(1,n)= OUT{n}.Baricenter(:,1); 
    ybaricenter(1,n)= OUT{n}.Baricenter(:,2);    
    
end;


OUTPUT{i}.areas=areas;
OUTPUT{i}.QUANT=QUANT;
OUTPUT{i}.TRACK=TRACK;
OUTPUT{i}.INTRING=INTRING;
OUTPUT{i}.AREARING=AREARING;
OUTPUT{i}.Lengthboundaries=Lengthboundaries;
OUTPUT{i}.xbaricenter=xbaricenter;
OUTPUT{i}.ybaricenter=ybaricenter;
OUTPUT{i}.BG=AverageBGQUANT;



%%%This is to print jpegs of the tracking


cd(pathoutput)

[B,L] = bwboundaries(LabelsMap(1).data>0);
    

OUTPUT{i}.BoundNuc=B;



    
    Bnuc{i}=B;
    
    [Bring,Lring] = bwboundaries(LabelsRing(1).data);
    
    Bcyto{i}=Bring;
    
OUTPUT{i}.BoundRing=Bring;
    
    
    
    
    if (strcmp(shallweplot,'QUANT')||(strcmp(shallweplot,'BOTH'))||(strcmp(shallweplot,'BOTHANDRINGS'))||(strcmp(shallweplot,'QUANTANDRINGS')))
        
        
        
        
        
        figure(1)
        %    FilterImg = imfilter(StackQuant(i).data,fspecial('gaussian', 20,  0),'same');
        FilterImg=StackQuant(i).data;
        imagesc(FilterImg);
        colormap('hot');
        %colormap('jet');
        hold on;
        
        
        if strcmp(shallweplot,'BOTH')|| strcmp(shallweplot,'BOTHANDRINGS')
            
            figure(2)
            %       FilterImg = imfilter(StackTrack(i).data,fspecial('gaussian', 20,  0),'same');
            FilterImg=StackTrack(i).data;
            imagesc(FilterImg);
            colormap('hot');
            %colormap('jet');
            hold on;
            
        end;
        
        
        
        
        
        for k = 1:length(B)
            figure(1)
            boundary = B{k};
            plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1);
            if strcmp(shallweplot,'BOTH')||strcmp(shallweplot,'BOTHANDRINGS')
                figure(2)
                boundary = B{k};
                plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1);
                
            end;
        end
        
        %[Bring,Lring] = bwboundaries(LabelsRing(i).data>0);
        
        
        
        
        if strcmp(shallweplot,'QUANTANDRINGS')||strcmp(shallweplot,'BOTHANDRINGS')
        
        for k = 1:length(Bring)
            figure(1)
            boundary = Bring{k};
            plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1);
        end
        
        end;
      
  
        
        filetoprint=strcat('QUANT',filenameprint,'F',num2str(i),'.jpg');
        figure(1)
        title(num2str(i));
        print(filetoprint,'-djpeg');
        
        if strcmp(shallweplot,'BOTH') ||strcmp(shallweplot,'BOTHANDRINGS') 
            filetoprint=strcat('TRACK',filenameprint,'F',num2str(i),'.jpg');
            figure(2)
            title(num2str(i));
            print(filetoprint,'-djpeg');
        end;
        
        hold off;
        %close all;
        
        
    end;
    
end;

cd(pathoutput)
save(filenamesave,'OUTPUT')

end

