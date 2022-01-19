clear

hold off

close all

Namefile=('GFP_20170912 mm1s gfp p65 DN100 0.1_0.2_0.5 ug DNA.lif_Series_29.mat');



load(Namefile);


[matrixNCI]= functionNCI_ring(matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT); 
 

[Ttot, Ncells]=size(matrixNCI);

ThAreaRingMin=400; 
ThAreaRingMax=1000; 


Framemax=30; 


listredcells=[];

for n=1:Ncells
    
    vRingareas=matrixAREARING(:,n);
    
    if length(find(vRingareas))>0
        
        if mean(vRingareas(find(vRingareas)))>=ThAreaRingMin && mean(vRingareas(find(vRingareas)))<=ThAreaRingMax
            
            listredcells=[listredcells,n]; 
            
        end;
        
    end; 
    
end;


matrixNCI_goodcells=matrixNCI(:,listredcells); 

cells=find(matrixNCI_goodcells(Framemax,:));

matrixNCIfinal=matrixNCI_goodcells(1:Framemax,cells); 



[M,N]=size(matrixNCIfinal); 

% for n=1:N
% 
%     matrixNCIfinal(:,n)=matrixNCIfinal(:,n)/max(matrixNCIfinal(:,n));
%     
% end; 




[valuemax, indexordered]=sort(max(matrixNCIfinal))




h=figure(2) 

set(h, 'Color', 'w');

set(h, 'units','normalized', 'Position', [.2 .2 .25 .3])

imagesc(matrixNCIfinal(:,indexordered)',[0.2, 1.5])


colormap(summer)

set(gca,'xtick',[1 round(Framemax*0.5), Framemax],'xticklabel', [0 round(Framemax*0.5)-1 Framemax-1]*6,'fontsize',15)

set(gca,'fontsize',15)

xlabel('time (mins)')

ylabel('Cell')