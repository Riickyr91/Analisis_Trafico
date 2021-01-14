 close all
 clear 
 clc
 
 addpath(genpath('D:\Imagenes_TFG'));
 
 for i=1:64
     
     if(i ~= 63)

        cam = "cam" + int2str(i);
        load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat");
        load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + "_Filt" + ".mat");
        
        figure('WindowState','maximized');
        subplot(1,2,1), imshow(plantilla);
        title(cam + " Sin filtrar")
        subplot(1,2,2), imshow(plantillaFilt);
        title(cam + " Filtrada")
        
        pause;
             
     end
    
 end