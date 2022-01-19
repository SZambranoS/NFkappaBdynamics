function [matricesofXinterp, matricesofYinterp ] = MatricesXandYInterpfromTracks(filetracks)



[matricesofXtracks, matricesofYtracks ] = MatricesXandYfromTracks(filetracks);


[Frames,n_tracks]=size(matricesofXtracks);



matricesofXinterp=nan(Frames,n_tracks);
matricesofYinterp=nan(Frames,n_tracks);





for n=1:n_tracks
   % hold off;
    X=matricesofXtracks(:,n);
    Y=matricesofYtracks(:,n);
    %plot(X,Y,'ko')
    %hold on;
    %axis([min(X), max(X), min(Y), max(Y)]);
    
%    disp('Before interpol')
 %   length(find(~isnan(X)))
    
    
    trackedframes=~isnan(X);
    
    pieces=bwlabel(trackedframes);
    
    listpieces=unique(pieces);
    listpieces=listpieces(find(listpieces)); 
    
    npieces=length(listpieces);
    
    
    if npieces>1
        
        for npiece=1:length(listpieces)-1;
            
            posi=max(find(pieces==npiece)); 
            posf=min(find(pieces==npiece+1)); 
            
            Xi=X(posi);
            Xf=X(posf);
            
            Yi=Y(posi);
            Yf=Y(posf); 
            
            
            X(posi:posf)=linspace(Xi,Xf, posf-posi+1);
            Y(posi:posf)=linspace(Yi,Yf, posf-posi+1);
            
            %plot(linspace(Xi,Xf, posf-posi+1),linspace(Yi,Yf, posf-posi+1),'go')
            
            
        end; 
 
    end; 
    
    frames=find(~isnan(X));
    
    
    
    matricesofXinterp(min(frames):max(frames),n)=X(min(frames):max(frames));
    matricesofYinterp(min(frames):max(frames),n)=Y(min(frames):max(frames));
    

%    plot(X,Y,'r+'); 
  
  % pause(1)
    
    
    
end;







end

