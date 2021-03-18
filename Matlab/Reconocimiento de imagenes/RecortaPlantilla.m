%% Este script recorta las plantillas de todas las camaras una a una (a mano)
close all
clear 
clc

%% Añado al path la carpeta con todas las imagenes y con todas las funciones 
addpath(genpath('D:\Imagenes_TFG'));
addpath('../Funciones');

for cont=1:64 
    if(cont ~= 63)

        %% Busco todos los nombre de las imagenes de la camX 
        cam = "cam" + int2str(cont);
        myPath = "D:\Imagenes_TFG\cam" + int2str(cont); 
        allPhotos = dir(fullfile(myPath,'*.jpg'));
        fileNames = {allPhotos.name};
        
        por = 100;
        
        num = 1;
        
        [f c] = size(fileNames);
        
        for k = 1:c 
            "Camara actual " + cam
            "Imagen actual " + k
            try
                P = imread(string(fileNames(1,k)));

                disponible = camDisponible(P);

                if (disponible)

                    %% Calculo la diferencia con la plantilla/Imagen anterior para ver si es necesario o no
                    if (k > 1)
                       pAnterior = imread(string(fileNames(1,k-1))); 
                       if( camDisponible(pAnterior)) 
                           por = plantillaNecesaria(P, pAnterior, cam);
                       else
                           por = 100;
                       end
                    end

                    %% Si la diferencia es significativa recorto la plantilla
                    if(por > 2)
                        figure('WindowState','maximized');
                        imshow(P);
                        w = "n";
                        prompt = '¿Desea hacer la plantilla de esta imagen? s | n ';
                        w = input(prompt, 's');
                        close all;
                        if ( w == "s" )
                            x = "s";
                            while x == "s" 
                                %% Recorto zona de interes 
                                figure('WindowState','maximized');
                                I_Plantilla = roipoly(P);

                                %% Muestro por pantalla
                                figure('WindowState','maximized');
                                subplot(1,2,1), imshow(P);
                                subplot(1,2,2), imshow(I_Plantilla)

                                prompt = '¿Desea volver a hacerla? s | n ';
                                x = input(prompt, 's')
                            end
                            close all;
                            save("D:\Imagenes_TFG\PLANTILLAS\" + cam + "\" + cam + "_" + num + ".mat", "I_Plantilla")
                            num = num + 1;
                        end
                    end
                end
            catch
            
            % Capturo el error de la lectura de imagenes
            
            end
        end
    end
end
