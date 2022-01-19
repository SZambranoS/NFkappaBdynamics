function [matrixNCI] = functionNCI_ring_withNANs(NUCLEARINTENSITY,NUCLEARAREA, RINGINTENSITY,BG)



[NFRAMES,NCELLS]=size(NUCLEARINTENSITY); 

matrixNCI=NaN(size(NUCLEARINTENSITY)); 


for i=1:NCELLS
    
    nucintensity=NUCLEARINTENSITY(:,i);
    nucarea=NUCLEARAREA(:,i);
   
    maxFrame=max((find(~isnan(nucarea))));
    minFrame=min((find(~isnan(nucarea))));
    
    nucarea=nucarea(minFrame:maxFrame); 
    nucintensity=nucintensity(minFrame:maxFrame); 
     
    nucaverageintensity=(nucintensity)./nucarea; 
    
    nucaverageintensityminusBG=nucaverageintensity-BG(minFrame:maxFrame)'; 
    
    ringintensityminusBG=RINGINTENSITY(minFrame:maxFrame,i)-BG(minFrame:maxFrame)';

    NCIcell=nucaverageintensityminusBG./(ringintensityminusBG)
    
    
    
    
    if(length(find(NCIcell<0))>0)
        
        disp('OJO') 
        i
    end; 
    
matrixNCI(minFrame:maxFrame,i)=NCIcell; 

    
    
end; 



