This tool is used to visualize brain voxels at 2 different resolutions. It was used to extract Gyri and Sulci voxels in a project by the DIVE group. This tool is intended to be used internally by the DIVE group. However, it is provided without documentation and can be used by anyone after citing the following paper:

@article{zeng2015allen,
  title={Allen mouse brain atlases reveal different neural connection and gene expression patterns in cerebellum gyri and sulci},
  author={Zeng, Tao and Chen, Hanbo and Fakhry, Ahmed and Hu, Xiaoping and Liu, Tianming and Ji, Shuiwang},
  journal={Brain Structure and Function},
  volume={220},
  number={5},
  pages={2691--2703},
  year={2015},
  publisher={Springer}
}
----------------------------------------------------------------------------------------------
Installation instructions:
--------------------------

MATLAB Compiler

1. Prerequisites for Deployment 

. Verify the MATLAB Compiler Runtime (MCR) is installed and ensure you    
  have installed version 8.0 (R2012b).   

. If the MCR is not installed, do the following:
  (1) enter
  
      >>mcrinstaller
      
      at MATLAB prompt. The MCRINSTALLER command displays the 
      location of the MCR Installer.

  (2) run the MCR Installer.

Or download the Windows 64-bit version of the MCR for R2012b 
from the MathWorks Web site by navigating to

   http://www.mathworks.com/products/compiler/mcr/index.html
   
   
For more information about the MCR and the MCR Installer, see 
Distribution to End Users in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.    


NOTE: You will need administrator rights to run MCRInstaller. 


2. Files to Deploy and Package

Files to package for Standalone 
================================
-Tool.exe
-MCRInstaller.exe 
   -if end users are unable to download the MCR using the above  
    link, include it when building your component by clicking 
    the "Add MCR" link in the Deployment Tool
-This readme file 

3. Definitions

For information on deployment terminology, go to 
http://www.mathworks.com/help. Select MATLAB Compiler >   
Getting Started > About Application Deployment > 
Application Deployment Terms in the MathWorks Documentation 
Center.
------------------------------------------------------------------
Usage:
------
The tool should be used along with the corresponding files:
1- Ontology.mat
2- 100.mat
3- 200.mat

These files should be placed in the same directory as the files Tool.fig and Tool.m in order for the tool to function correctly.




