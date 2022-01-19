
clear
close all
hold off; 

dirroutines='C:\Science\Routines Imaging\RoutinesNCI_ST'

fileFbF='FbFGFP_POS16_07102020.mat'; 



Namefile_tosave=strcat('NCIfrom',fileFbF); 

diroutput=pwd; 
dirinput=pwd; 



n_dim = 2;
max_linking_distance = 20; 
max_gap_closing = 5;
debug = true;

vparamstracking=[n_dim,max_linking_distance,max_gap_closing,debug];


cd(dirroutines)

FromFbFToTrackedSingleCellsforNCI(dirinput,fileFbF,Namefile_tosave,diroutput,vparamstracking); 

ThAreaRingMin=5; 
ThAreaRingMax=2000; 
matrixNCIfinal=[];
theta=0.15;



load(Namefile_tosave);


% files = dir('/Users/cis/Google Drive (cise.kizilirmak@unimib.it)/Lab MB/Results/E1 Results');
%for i=1:length(files)
 %   eval(['load ' files(i).name ' -ascii']);
%end


cd(dirroutines)

[matrixNCI]= functionNCI_ring(matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT); 
 
cd(diroutput)


[Ttot, Ncells]=size(matrixNCI);
Framemax=Ttot; 

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

matrixNCIfinal=matrixNCI_goodcells; 


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
    
end; 


[valuemax, indexordered]=sort(max(matrixNCIfinalsmooth))

h=figure(1) 

set(h, 'Color', 'w');

set(h, 'units','normalized', 'Position', [.2 .2 .25 .3])

imagesc(matrixNCIfinalsmooth(:,indexordered)',[0, 3])


colormap default

colorbar

set(gca,'xtick',[1 round(Framemax*0.5), Framemax],'xticklabel', [0 round(Framemax*0.5)-1 Framemax-1]*6,'fontsize',15)

set(gca,'fontsize',15)

xlabel('time (mins)')

ylabel('Cell')



colormap('summer')


