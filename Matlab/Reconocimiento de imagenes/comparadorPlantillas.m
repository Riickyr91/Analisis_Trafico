%% Este script compara todas las plantillas recortadas a mano con las calculadas automaticamente
% Las plantillas predefinidas no tienen aplicado ni bwareaopen ni imclose
 close all
 clear 
 clc
 
 addpath(genpath('D:\Imagenes_TFG'));
 
 for i=1:64 % No está calculada las plantillas automaticas de la cam 65 ni 66
     
     if(i ~= 63)

        cam = "cam" + int2str(i);
        load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat");
        
        myPath = strcat('D:\Imagenes_TFG\PLANTILLAS\',cam);
        allPlantillas = dir(fullfile(myPath,'*.mat'));
        fileNames={allPlantillas.name};   
        r = string(strcat(myPath,'\',fileNames(1,1)));   
        load(r);
        
        figure('WindowState','maximized');
        subplot(1,2,1), imshow(plantilla);
        title(cam + " Automatizada")
        subplot(1,2,2), imshow(I_Plantilla);
        title(cam + " Manual")
        
        pause;
        
        close;
     end
    
 end