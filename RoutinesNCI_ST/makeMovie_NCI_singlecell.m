function makeMovie_NCI_singlecell(Results, iCell, StackGFP,dirout,printimages,width,axistochose)

close all; 
dirroutines=pwd;

cd(dirout);
load(Results);
cd(dirroutines);



matrixQUANT=matrixQUANT;
matrixareas=matrixareas;
matrixINTRING=matrixINTRING;
AverageBGQUANT=AverageBGQUANT;
matrixAREARING=matrixAREARING;

[matrixNCI] = functionNCI_ring(matrixQUANT, matrixareas, matrixINTRING,AverageBGQUANT);

maxaxis=max(max(matrixNCI));

vNCI=matrixNCI(1:OUT{iCell}.maxFrame,iCell);


vNCI=(vNCI-min(vNCI))/(max(vNCI)-min(vNCI)); 


vNCInorm=smooth(vNCI,3); 



for l=1:63
colormapgreen(l,:)=[0 (l-1)/62 0];
end
colormapgreen(64,:)=[1 1 1];



h = figure;
set(h, 'Color', 'k');

%set(h, 'units','normalized', 'Position', [.1 .1 .5 .3])

set(h, 'units','normalized', 'Position', [0 0.1 2/3 .5])


%hStack = axes('Position', [.05, .3, .45, .6]);
%hPlot = axes('Position', [.55, .3, .40, .6]);

hStackGFP = axes('Position', [.05, .15, .4, .8]);
hPlot = axes('Position', [.55, .15, .4, .8]);

%whitebg('k')

%hPlot = axes('Position', [.6, .3, .40, .6]);


height = width;

cd(dirout);
writerObj = VideoWriter(strrep('NCIDynamicsCellXXX.avi','XXX',num2str(iCell)));
writerObj.FrameRate=15;
open(writerObj);
cd(dirroutines);



for iFrame = 1:OUT{iCell}.maxFrame

xmin = round(OUT{iCell}.Baricenter(iFrame,1))-round(width/2);
xmin = max(xmin, 1);

xmax = round(OUT{iCell}.Baricenter(iFrame,1))+round(width/2);
xmax = min(xmax, 1024);

ymin = round(OUT{iCell}.Baricenter(iFrame,2))-round(height/2);
ymin = max(ymin, 1);

ymax = round(OUT{iCell}.Baricenter(iFrame,2))+round(height/2);
ymax = min(ymax, 1024);

CropGFP = StackGFP(iFrame).data(ymin:ymax,xmin:xmax);

axes(hPlot);
plot([1:OUT{iCell}.maxFrame]*6,vNCInorm,'g', 'linewidth',2);
hold on;
plot([6*iFrame,6*iFrame],[0,max(vNCInorm)],'--k', 'markersize',2);

if(length(axistochose)>0)
    axis(axistochose)
else;
axis tight;
end;

hold off;
xlabel('\color{white}{Time [min]}');
ylabel('\color{white}{Nuc:Cyto NF-\kappaB}'); 



set(gca,'XTick',6*[1 OUT{iCell}.maxFrame],'XTickLabel', {num2str(0), OUT{iCell}.maxFrame*6},'Xcolor','w')


set(gca,'ytick',[])

axes(hStackGFP)
CropGFP=imfilter(CropGFP,fspecial('gaussian', 20,  1),'same');


imagesc(CropGFP,[mean(CropGFP(:))-std(double(CropGFP(:))),mean(CropGFP(:))+4*std(double(CropGFP(:)))]);
colormap('gray')

set(gca,'xtick',[])
set(gca,'ytick',[])
hold off;



frame = getframe(h);

%set(h,'fontsize',14)
cd(dirout)
writeVideo(writerObj,frame);

if (strcmp(printimages,'YES'))

figure(2)
imagesc(CropGFP,[mean(CropGFP(:))-std(double(CropGFP(:))),mean(CropGFP(:))+4*std(double(CropGFP(:)))]);
colormap('gray')
set(gca,'xtick',[])
set(gca,'ytick',[])
print(strcat('Cell',num2str(iCell),'Frame',num2str(iFrame),'.png'),'-dpng')
close
end;
cd(dirroutines)
end



