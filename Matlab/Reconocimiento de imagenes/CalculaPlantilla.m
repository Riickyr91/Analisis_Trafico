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

        % Matriz donde concateno, es decir, detecto que es una nueva plantilla
        % matriz = 1;
        % I_Plantilla = [];
        numPixeles = 5;
        desplazamiento = numPixeles * 2;

        % Tamaño de la plantilla
        P = imread(string(fileNames(1,1)));
        [f c m ] = size(P);
        plantilla = logical(zeros(f - desplazamiento + 1,c  - desplazamiento + 1));
        %plantillaFilt = logical(zeros(f - desplazamiento + 1,c  - desplazamiento + 1));

        for i=(numImagenes + 1):50
            Imagen = string(fileNames(1,i));
            I = imread(Imagen);
            
            %% Saco imagen de fondo
            imagen = 1;  
            for contador = i-1:-1:i-numImagenes
                imagenStruct(imagen).image = imread(string(fileNames(1,contador)));  
                imagenStruct(imagen).red = imagenStruct(imagen).image(:,:,1);
                imagenStruct(imagen).green = imagenStruct(imagen).image(:,:,2);
                imagenStruct(imagen).blue = imagenStruct(imagen).image(:,:,3);   
                imagen = imagen + 1;
            end

            %% Calculo la mediana de todas las imagenes
            [f, c, m] = size(imagenStruct(1).image);

            r = uint8(zeros(1,numImagenes));
            g = uint8(zeros(1,numImagenes));
            b = uint8(zeros(1,numImagenes));
            
            ifr = uint8(zeros(f,c));
            ifg = uint8(zeros(f,c));
            ifb = uint8(zeros(f,c));

            for fila = 1:f
                for columna = 1:c
                    for k = 1:numImagenes        
                        r(1,k) = imagenStruct(k).red(fila,columna);
                        g(1,k) = imagenStruct(k).green(fila,columna);
                        b(1,k) = imagenStruct(k).blue(fila,columna);        
                    end      
                    ifr(fila,columna) = median(r);
                    ifg(fila,columna) = median(g);
                    ifb(fila,columna) = median(b);   
                end
            end

            %% Creo la imagen de fondo
            ifondo = cat(3,ifr,ifg,ifb);
            % imshow(ifondo)
            
            [plantillaElegida] = encuadrarImagen(I, ifondo, numPixeles);
            %imshow(plantillaElegida)

            %Jfilt = medfilt2(plantillaElegida);
            %imshow(Jfilt);
            %plantilla = plantilla + Jfilt;

            JEli = bwareaopen(plantillaElegida,15);
            %imshow(JEli)
            plantilla = plantilla + JEli;


            %Ir añadiende I_Plantilla(:,:,matriz)
            %Cuando diferencia con la anterior sea mucho matriz ++
            %Crear fondo a modo ventana
            %Añadir por si hubieran desviaciones
            %Comprar que la imagen o plantilla no está ya en la matriz, antes o
            %despues de este bucle

            %IAnterior = I;

            figure
            imshow(plantilla)
        %     title("I = " + i)

        "camara " + cont
        "imagen " + i + " de 50"
        
        end

        %% Leo imagen a analizar

%         figure
%         subplot(1,2,1), imshow(plantilla);
%         subplot(1,2,2), imshow(plantillaFilt);

        numPlantilla = 1;
        
        %% Guardo las plantillas en las carpetas seleccionadas
%         save("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + ".mat", "plantilla")
%         save("D:\Imagenes_TFG\PLANTILLASB\" + cam + "\" + cam + "_Filt" + ".mat", "plantillaFilt")
        
    end
    
end