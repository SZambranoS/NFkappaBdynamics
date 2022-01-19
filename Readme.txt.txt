Software for quantification of NFkappaB dynamics as nuclear to cytosolic ratio from time-lapse movies of NFkappaB dynamics. 

Related with the biorxiv: https://www.biorxiv.org/content/10.1101/2021.12.07.471485v1


If you use the software, please cite the paper. 


NFkappaB dynamics data should be provided as an input, a .tif for the nuclear marking channel and a .tif for the NF-kappaB channel (in our case, GFP.

The routines needed (and similar ones doing slightlyl different things) are provided in "RoutinesNCI_ST"

To use them, use the scripts in the folder "FolderQuant". In particular: 

- SegmentTiffs segments the nuclei and the surrounding piece of cytosol in each frame. 

- ScriptFromFbFtoNCI performs the tracking. If this is cited, please acknowledge "Dr. Jean-Yves Tinevez from the Image Analysis Hub of the Institut Pasteur is acknowledged for publicly sharing his "Simple Tracker" MATLAB routines."

- GenerateMatrixNCI_analyzepeaks puts together the data. 

Samuel Zambrano, Milan, January 2022