
clear


hold off

close all 


load('GFP_TEST.lif_Series_48.mat') 



 pathName=strcat(pwd,'\');
fileNamep65='GFP_TEST.lif_Series_48.tif'


%%



if fileNamep65 ~= 0
    [Stackp65, nFrames] = TIFread([pathName, fileNamep65]);
end


[nFrames,nCells]=size(matrixAREARING);

figure(1)



plot_Track_Quant_for_NCI_Ring_classic(OUT, Stackp65, nCells, nFrames,matrixQUANT,matrixareas, matrixINTRING, AverageBGQUANT)
