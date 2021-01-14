close all
clear 
clc

%% Añado al path la carpeta con todas las imagenes y con todas las funciones 
addpath(genpath('D:\Imagenes_TFG'));

for cont=1:64
    
    if(cont ~= 63)

        %% Busco todos los nombre de las imagenes de la camX 
        cam = "cam" + int2str(cont);
        myPath = "D:\Imagenes_TFG\cam" + int2str(cont); 
        allPhotos = dir(fullfile(myPath,'*.jpg'));
        fileNames = {allPhotos.name};
        
        [f c] = size(fileNames);
        
        for k = 1:c
        
            P = imread(string(fileNames(1,k)));

            x = "s";

            while x == "s"

                %% Recorto zona de interes 
                I_Plantilla = roipoly(P);
                % imshow(I_Plantilla)

                %% Muestro por pantalla
                figure
                subplot(1,2,1), imshow(I);
                subplot(1,2,2), imshow(I_Plantilla)

                "Camara actual" + cam

                prompt = '¿Desea volver a hacerla? s | n ';
                x = input(prompt, 's')

            end

            save("D:\Imagenes_TFG\PLANTILLASW\" + cam + "\" + cam + "_" + k + ".mat", "I_Plantilla")
            
        end
    end
end
