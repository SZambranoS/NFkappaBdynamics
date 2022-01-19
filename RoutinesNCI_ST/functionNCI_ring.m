function [matrixNCI] = functionNCI_ring(NUCLEARINTENSITY,NUCLEARAREA, RINGINTENSITY,BG)



[NFRAMES,NCELLS]=size(NUCLEARINTENSITY); 

matrixNCI=zeros(size(NUCLEARINTENSITY)); 


for i=1:NCELLS
    
    nucintensity=NUCLEARINTENSITY(:,i);
    
    nucarea=NUCLEARAREA(:,i);
    nucintensity=nucintensity(find(nucintensity>0));
    maxFrame=length(nucintensity);
    nucarea=nucarea(1:maxFrame);   %%%%%%%
    
    nucaverageintensity=(nucintensity)./nucarea; 
    
    nucaverageintensityminusBG=nucaverageintensity-BG(1:maxFrame)'; 
    
    ringintensityminusBG=RINGINTENSITY(1:maxFrame,i)-BG(1:maxFrame)';

    NCIcell=nucaverageintensityminusBG./(ringintensityminusBG); 
    
matrixNCI(1:maxFrame,i)=NCIcell; 

    
    
end; 




