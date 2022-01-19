function [LabelsMap, refinedmask,roughmask] = CheckSegmentationFOR_Track_Quant_for_NCI_Ring_classic_WS(StackTrack, parCellTrack)


%This is classic because we calculate the ring around the nucleus in the
%same way as in the eLife paper.


%August 2017-> Applies watershead in nuclear segmentation, which requires
%also some care in the segmentation of the ring around the  cell (see
%track_and_quantify_2channels_forNuctoCyto_classical for WS).

parCellSeg=parCellTrack(1:5);
TolArea=parCellTrack(6);
RingWidth=parCellTrack(7);
FactorBG=parCellTrack(8);
sigmaforring=parCellTrack(9);


nFrames = length(StackTrack);

for i = 1:nFrames;
    [cellROIs_refined(i),roughmask(i).data,refinedmask(i).data] = segment_fromImage_refined_cluster(StackTrack(i).data, parCellSeg);
    disp(i)
    figure(1)
    imagesc(StackTrack(i).data)
    title(strcat('Track channel ',num2str(i))); 
    figure(2)
    imagesc(roughmask(i).data)
    title(strcat('Rough segmentation frame ',num2str(i))); 
    figure(3)
    imagesc(refinedmask(i).data)
    title(strcat('Fine segmentation frame ',num2str(i))); 
    
    %pause(0.25)
end

clear i


%% Track Cells based on Nearest Neighbor




[LabelsMap]=track_just_nuclei(cellROIs_refined, StackTrack, nFrames, TolArea);


for i=1:nFrames
    figure(1)
    imagesc(StackTrack(i).data)
    title(strcat('Track channel ',num2str(i))); 
    figure(2)
    imagesc(roughmask(i).data)
    title(strcat('Rough segmentation frame ',num2str(i))); 
    figure(3)
    imagesc(refinedmask(i).data)
    title(strcat('Fine segmentation frame ',num2str(i))); 
    figure(4)
    imagesc(LabelsMap(i).data)
    title(strcat('Tracking frame ',num2str(i))); 
    pause(1); 
    
end; 



end

