close all
clear 
clc

%% Añado al path la carpeta con todas las imagenes y con todas las funciones 
addpath(genpath('D:\Imagenes_TFG'));
addpath('../Funciones');
DatosFinales = [];

%% Busco todos los nombre de las imagenes de la camX
myPath = 'D:\Imagenes_TFG\cam1'; 
allPhotos = dir(fullfile(myPath,'*.jpg'));
fileNames={allPhotos.name};

%% Numero de imagenes necesarias para la imagen de fondo
numImagenes = 10;

%% Porcentaje de reduccion de imagen
rd = 0.4;

%% Saco las plantillas de la camX
nombre = split(string(fileNames(1,1)),'_');
nomFormato = split(nombre(3),'.');
cam = nomFormato(1);
%Plantillas sacadas a mano
plantilla = getPlantillas(cam);
%Plantillas automatizadas
plantillab = getPlantillasB(cam);

[f c m] = size(plantilla);

% Redimensiono las plantillas si es necesario
if(f > 1000)
    plantilla = imresize(plantilla,rd);
    plantillab = imresize(plantillab,rd);
end

%% Realizo un bucle por el numero de imagenes de la carpeta
[filas, columnas] = size(fileNames);

for i=(numImagenes + 1):columnas  
    %% Selecciono la imagen a analizar
    I = imread(string(fileNames(1,i)));
    
    %% Relleno datos de la camara
    nombre = split(string(fileNames(1,i)),'_');
    datosCamara = [cam, nombre(1,1), nombre(2,1)];
    
    %% Compruebo si la camara esta disponible 
    disponible = camDisponible(I);

    %% Si la camara esta disponible realizo todas las operaciones
    if(disponible)  
        %% Compruebo si tengo que redimensionar la imagen 
        [f c m] = size(I);

        if(f > 1000)
            resize = true;
            I = imresize(I,rd);
        else
            resize = false;
        end
                
        %% Saco imagen de fondo
        imagen = 1;
        for contador = i-1:-1:i-numImagenes     
            if(resize)
                imagenStruct(imagen).image = imresize(imread(string(fileNames(1,contador))), rd);
            else
                imagenStruct(imagen).image = imread(string(fileNames(1,contador)));
            end    
            imagenStruct(imagen).red = imagenStruct(imagen).image(:,:,1);
            imagenStruct(imagen).green = imagenStruct(imagen).image(:,:,2);
            imagenStruct(imagen).blue = imagenStruct(imagen).image(:,:,3);   
        imagen = imagen + 1;
        end
               
        %% Saco dimensiones para crear la imagen de fondo
        [f c m] = size(imagenStruct(1).image);

        ifr = uint8(zeros(f,c));
        ifg = uint8(zeros(f,c));
        ifb = uint8(zeros(f,c));

        r = uint8(zeros(1,numImagenes));
        g = uint8(zeros(1,numImagenes));
        b = uint8(zeros(1,numImagenes));

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

        %% Utilizando plantilla extraida con roipoly
        [ ocupacion1, pElegida1] = getOcupacionA(plantilla, ifondo, I);

        %% Utilizando plantilla con suma de imagenes
        [ ocupacion2, pElegida2] = getOcupacionA(plantillab, ifondo, I);
        
        %% Muestro resultados
        figure('WindowState','maximized');
        subplot(2,2,1), imshow(I);
        title("Imagen original");
        subplot(2,2,2), imshow(ifondo);
        title("Fondo calculado");
        subplot(2,2,3), imshow(pElegida1);
        title("Plantilla elegida. " + ocupacion1 + " %")  
        subplot(2,2,4), imshow(pElegida2);
        title("Plantilla elegida. " + ocupacion2 + " %");

        pause
    
        %% Concateno resultados
        %datosCamara = [datosCamara ocupacion];
        
    %% Si la camara no esta disponible
    else
        %% Concateno datos 'NO DISPONIBLE'
        datosCamara = [ datosCamara [ 'NO DISPONIBLE']]; 
    end

    %% Guardo datos extraidos
    DatosFinales = [DatosFinales ; datosCamara];
    
end

%save Datos.mat DatosFinales
