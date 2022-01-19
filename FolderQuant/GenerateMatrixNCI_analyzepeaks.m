clear

hold off

close all

dirroutines='C:\Science\Routines Imaging\RoutinesNCI_ST'
diroutput=pwd;

Namefile_general=('NCIfromFbFGFP_POSXXX_07102020.mat');
  
% 
%  vpositions=[1:4];
%  Namefile_tosave=strcat('NCIDatas201007Media.mat');
% 
% 
% vpositions=[5:8];
% Namefile_tosave=strcat('NCIDatas201007TNF10.mat');


% 
% vpositions=[9:12];
% Namefile_tosave=strcat('NCIDatas201007TNF100.mat');
% 

vpositions=[13:16];
Namefile_tosave=strcat('NCIDatas201007IL1beta.mat');



% 





framemax=31; 



ThAreaRingMin=400; 
ThAreaRingMax=1000; 
matrixNCIfinal=[];
theta=0.15;

for np=1:length(vpositions)
    
Namefile=strrep(Namefile_general,'XXX',num2str(vpositions(np)))



load(Namefile);


% files = dir('/Users/cis/Google Drive (cise.kizilirmak@unimib.it)/Lab MB/Results/E1 Results');
%for i=1:length(files)
 %   eval(['load ' files(i).name ' -ascii']);
%end



cd(dirroutines)
[matrixNCI]= functionNCI_ring(matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT); 
cd(diroutput) 

[Ttot, Ncells]=size(matrixNCI);


Framemax=framemax; 


listgoodcells=[];

for n=1:Ncells
    
    vRingareas=matrixAREARING(:,n);
    
    if length(find(vRingareas))>0
        
        if mean(vRingareas(find(vRingareas)))>=ThAreaRingMin && mean(vRingareas(find(vRingareas)))<=ThAreaRingMax
        
        %vringareasfinal=vRingareas(find(vRingareas));
        
        %if length(find(vringareasfinal<ThAreaRingMin))>0 ||  length(find(vringareasfinal>ThAreaRingMax))>0

            
            listgoodcells=[listgoodcells,n]; 
            
        end;
        
    end; 
    
end;


matrixNCI_goodcells=matrixNCI(:,listgoodcells); 

cells=find(matrixNCI_goodcells(Framemax,:));

matrixNCIposfinal=matrixNCI_goodcells(1:Framemax,cells)

listgoodcellsposfinal=intersect(listgoodcells,cells)

matrixNCIfinal = [matrixNCIfinal,matrixNCIposfinal]; 


end;



[M,N]=size(matrixNCIfinal);

matrixNCIfinalsmooth=[];

for n=1:N
    
    vsmooth=smooth(matrixNCIfinal(:,n));
    
    matrixNCIfinalsmooth=[matrixNCIfinalsmooth,vsmooth];
    
    [valuepeaks, framepeaks]=findpeaks(vsmooth,'MinPeakProminence',theta)

    
%     
%     hold off
%     figure(40)
%     plot(vsmooth)
%     hold on
%     plot(matrixNCIfinal(:,n),'r')
%     axis([1, 40 0 4])
%     
%     
%         
%     plot(framepeaks,valuepeaks,'o')
%     pause(1)
%     
    PeaksValues{n}=valuepeaks;
    PeaksFrames{n}=framepeaks;
    Valuemax{n}=max(vsmooth);
    Integrated{n}=sum(vsmooth);
    
end; 






[valuemax, indexordered]=sort(max(matrixNCIfinalsmooth))

h=figure(2) 

set(h, 'Color', 'w');

set(h, 'units','normalized', 'Position', [.2 .2 .25 .3])

imagesc(matrixNCIfinalsmooth(:,indexordered)',[0, 3])


colormap(summer)

colorbar

set(gca,'xtick',[1 round(Framemax*0.5), Framemax],'xticklabel', [0 round(Framemax*0.5)-1 Framemax-1]*6,'fontsize',15)

set(gca,'fontsize',15)

xlabel('time (mins)')

ylabel('Cell')


save(Namefile_tosave,'matrixNCIfinalsmooth','PeaksValues','PeaksFrames','theta','Valuemax','Integrated') 

print(strrep(Namefile_tosave,'.mat','.png'),'-dpng')


