close all
clear 
clc
 
addpath(genpath('D:\Imagenes_TFG'));

i = 5;

cam = "cam" + int2str(i);
load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat");
load("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + "_Filt" + ".mat");

    W = 20;
    plantillaFiltB = imclose(plantillaFilt,ones(W,W));
    imshow(plantillaFiltB)

imagen = 1;

figure
subplot(2,3,imagen), imshow(plantillaFilt);
title("Imagen Original")

imagen = imagen + 1;

for i=4:4:20
    W = i;
    plantillaFiltB = imclose(plantillaFilt,ones(W,W));
    subplot(2,3,imagen), imshow(plantillaFiltB);
    title("Tamaño de la vecindad " + W)
    
    imagen = imagen + 1;
end




