function [matricesofXtracks, matricesofYtracks ] = MatricesXandYfromTracks(filetracks)


load(filetracks); 



all_points = vertcat(points{:});

 frames_points=[]; 
 for n=1:length(points)
 frames_points=[frames_points;n*ones(length(points{n}),1)];
 end; 


matricesofXtracks=NaN(length(points),n_tracks);
matricesofYtracks=NaN(length(points),n_tracks);


for i_track = 1 : n_tracks
    track = adjacency_tracks{i_track};
    track_points = all_points(track, :);
    track_frames=frames_points(track);
    matricesofXtracks(track_frames,i_track)=track_points(:,1);
    matricesofYtracks(track_frames,i_track)=track_points(:,2);
end



end

