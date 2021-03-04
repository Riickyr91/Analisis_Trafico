%% Calcula las plantillas de manera automatizada 
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

        %% Numero de imagenes para fondo
        numImagenes = 9;

        %% Calculo todas las imagenes que tengo en la camX
        [filas, columnas] = size(fileNames);

        %% Pixeles para encuadrar
        numPixeles = 5;
        desplazamiento = numPixeles * 2;

        %% Tamaño de la plantilla
        P = imread(string(fileNames(1,1)));
        [f c m ] = size(P);
        plantilla = logical(zeros(f - desplazamiento + 1,c  - desplazamiento + 1));

        for i=(numImagenes + 1):50 %Numero de imagenes para crear la plantilla
            Imagen = string(fileNames(1,i));
            I = imread(Imagen);
            
            %% Saco imagen de fondo
            imagen = 1;  
            for contador = i-1:-1:i-numImagenes
                imagenStruct(imagen).image = imread(string(fileNames(1,contador)));   
                imagen = imagen + 1;
            end

            ifondo = calculaFondo(imagenStruct, numImagenes);
            % imshow(ifondo)
            
            [plantillaElegida] = encuadrarImagen(I, ifondo, numPixeles);
            %imshow(plantillaElegida)

            JEli = bwareaopen(plantillaElegida,15);
            %imshow(JEli)
            
            plantilla = plantilla + JEli;

            figure
            imshow(plantilla)
 
        "camara " + cont
        "imagen " + i + " de 50"
        
        end
        
        % Aplicamos cierre morfológico
        W = 20;
        JClose = imclose(plantilla,ones(W,W));
        % imshow(JClose)
        
        %% Guardo las plantillas en las carpetas seleccionadas
        save("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat", "plantilla")        
    end
    
end