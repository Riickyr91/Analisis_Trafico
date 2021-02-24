%% Lee las plantillas calculadas automaticamente
% Las plantillas predefinidas no tienen aplicado ni bwareaopen ni imclose
close all
clear 
clc
 
addpath(genpath('D:\Imagenes_TFG'));
 
for i=1:64
     
    if(i ~= 63)

       cam = "cam" + int2str(i);
       load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat");
              
       figure('WindowState','maximized');
       imshow(plantilla);
       title(cam + " Sin filtrar")
       
       pause;
            
    end
   
end