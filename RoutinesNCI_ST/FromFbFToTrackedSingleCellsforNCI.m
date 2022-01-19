function [] = FromFbFToTrackedSingleCellsforNCI(pathinput,filenamepoints,filenamefinal,pathoutput,vparamstracking)


dirwork=pwd;

cd(pathinput);
load(filenamepoints);
cd(dirwork); 


[m,nframes]=size(OUTPUT)

for k=1:nframes
    
    points{k}=[OUTPUT{k}.xbaricenter', OUTPUT{k}.ybaricenter'];
    QUANT{k}=OUTPUT{k}.QUANT';
    TRACK{k}=OUTPUT{k}.TRACK';
    areas{k}=OUTPUT{k}.areas';
    INTRING{k}=OUTPUT{k}.INTRING';
    AREARING{k}=OUTPUT{k}.AREARING';
    BG{k}=OUTPUT{k}.BG';
    AverageBGQUANT(k)=OUTPUT{k}.BG';

end; 




%Parameters to be used for the tracking

%vparamstracking=[ndim,max_linking_distance,max_gap_closin,debug];






n_dim = vparamstracking(1)
max_linking_distance = vparamstracking(2)
max_gap_closing = vparamstracking(3)
debug = true


[ tracks,adjacency_tracks ] = simpletracker(points,...
    'MaxLinkingDistance', max_linking_distance, ...
    'MaxGapClosing', max_gap_closing, ...
    'Debug', debug);
n_tracks = numel(tracks);
all_points = vertcat(points{:});
all_QUANT=vertcat(QUANT{:});
all_areas=vertcat(areas{:});
all_TRACK=vertcat(TRACK{:});
all_INTRING=vertcat(INTRING{:});
all_AREARING=vertcat(AREARING{:});






 frames_points=[]; 
 for n=1:length(points)
 frames_points=[frames_points;n*ones(length(points{n}),1)];
 end; 


matricesofXtracks=NaN(length(points),n_tracks);
matricesofYtracks=NaN(length(points),n_tracks);
matrixQUANT=NaN(length(points),n_tracks);
matrixareas=NaN(length(points),n_tracks);
matrixTRACK=NaN(length(points),n_tracks);
matrixINTRING=NaN(length(points),n_tracks);
matrixAREARING=NaN(length(points),n_tracks);



for i_track = 1 : n_tracks
    track = adjacency_tracks{i_track};
    track_points = all_points(track, :);
    track_frames=frames_points(track);
    matricesofXtracks(track_frames,i_track)=track_points(:,1);
    matricesofYtracks(track_frames,i_track)=track_points(:,2);
    matrixQUANT(track_frames,i_track)=all_QUANT(track,:);
    matrixareas(track_frames,i_track)=all_areas(track,:);
    matrixTRACK(track_frames,i_track)=all_TRACK(track,:);
    matrixINTRING(track_frames,i_track)=all_INTRING(track,:);
    matrixAREARING(track_frames,i_track)=all_AREARING(track,:);
end

matricesofXtracks=InterpolateMatrixofNaNs(matricesofXtracks);
matricesofYtracks=InterpolateMatrixofNaNs(matricesofYtracks);
matrixQUANT=InterpolateMatrixofNaNs(matrixQUANT);
matrixareas=InterpolateMatrixofNaNs(matrixareas);
matrixTRACK=InterpolateMatrixofNaNs(matrixTRACK);
matrixINTRING=InterpolateMatrixofNaNs(matrixINTRING);
matrixAREARING=InterpolateMatrixofNaNs(matrixAREARING);



cd(pathoutput)

save(filenamefinal,'matricesofXtracks','matricesofYtracks','matrixQUANT','matrixareas','matrixTRACK','matrixINTRING','matrixAREARING','AverageBGQUANT','vparamstracking'); 


end

