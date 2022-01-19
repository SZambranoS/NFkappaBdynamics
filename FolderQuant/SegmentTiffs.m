clear

hold off

close all



path_routines='C:\Science\Routines Imaging\RoutinesNCI_ST'; %Where your quantification routines are


%Parameters for segmentation

sigma =0.25;          % blurring for FINE nuclei identification and tracking [px], %%SMALL FOR THESE ASOS
%%%%%%%%%%%%%%MINSIZE SMALLER FOR RAW AND MEFS COCULTURES

minSize = 200;   % minimum size for nuclei identification [px^2] MAKE IT SMALLER FOR RAW CELLS
maxSize=2000; %This is also useful because sometimes two cells are attached (SZ)
%minSize = 500;
%maxSize =3500;
nclusters =2;  % Clusters of the image used for the rought segmentation. The threshold is the mean of the centroids of the intensities from the second lower to the maximum value
treshFactor_FINE = 0.8;  % threshold factor for nuclei identification
TolArea=0.25; 
sigmarough=1; 
%%%These are for the ring of NCI

RingWidth=20;
factorTolBG=1.1; 
sigmaforring=2;

parCellTrack = [sigma, minSize, nclusters, treshFactor_FINE, maxSize,sigmarough,TolArea,RingWidth,factorTolBG,sigmaforring]; % Parameters for cell tracking




pathInputQuant=strcat('C:\Science\Clones Dynamics\CK_29102020_New TNF test on MEFs 3 pos each media_oldTNF_newTNFinPBS_newTNFwithBSA_IL1b_Converted\');
pathInputTrack=strcat('C:\Science\Clones Dynamics\CK_29102020_New TNF test on MEFs 3 pos each media_oldTNF_newTNFinPBS_newTNFwithBSA_IL1b_Converted\');

pathOutput=pwd;




t = clock;  



% fileNameQuantGEN='GFP_mm1s 20180306_20X dry.lif_Series_Y.tif';
% fileNameTrackGEN='HOE_mm1s 20180306_20X dry.lif_Series_Y.tif';



%fileNameQuant='SubstackCKGFP.tif';

%fileNameTrack='SubstackCKHOE.tif'


cd(pathInputQuant)
fnamesQUANT = dir('GFP*.tif');
cd(pathInputTrack)
fnamesTRACK = dir('HOE*.tif');

numfids = length(fnamesQUANT);



%for n=[1:numfids]

for n=[1:numfids]


fileNameQuant =fnamesQUANT(n).name; 
fileNameTrack=fnamesTRACK(n).name; 


cd(path_routines);


[StackQuant, nFrames] = TIFread([pathInputQuant, fileNameQuant]);

[StackTrack, nFrames] = TIFread([pathInputTrack, fileNameTrack]);


%To determine what to print, BOTH means both the channel for the tracking
%and the quantification 
%whattoprint='BOTH'; 



%Each option below generates jpegs and hence is slower. 

%whattoprint='BOTHANDRINGS'; %It saves jpegs of both channels with contours of nuclei and rings. 

%whattoprint='BOTH'; %It saves jpegs of both channels with just contours nuclei. 

%whattoprint='QUANTANDRINGS'; %Generates jpegs of the quant channel with
%contours of nuclei and rings.

%whattoprint='NONE'; %Does not print anything. Fastest by a factor 0.6-0.7 than all the previous

whattoprint='QUANT'

filenameprint=strrep(fileNameQuant,'.tif','');
filenameprint=strrep(fileNameQuant,'.lif','');
filenamesave=strrep(fileNameQuant,'.tif','.mat');
filenamesave=strcat('FbF',filenamesave);

cd(path_routines)

Track_NCI_Ring_classic_FrameByFrame_FINER(StackTrack,StackQuant,parCellTrack,filenameprint, filenamesave,whattoprint,pathOutput);

cd(pathOutput); 

end;



