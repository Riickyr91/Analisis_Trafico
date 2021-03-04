close all
clear 
clc

%% Añado al path la carpeta con todas las imagenes y con todas las funciones 
addpath(genpath('D:\Imagenes_TFG'));
addpath('../Funciones');
DatosFinales = [];

for cont=1:1
    if(cont ~= 63)

        %% Busco todos los nombre de las imagenes de la camX
        cam = "cam" + int2str(cont);
        myPath = "D:\Imagenes_TFG\cam" + int2str(cont); 
        allPhotos = dir(fullfile(myPath,'*.jpg'));
        fileNames={allPhotos.name};

        %% Numero de imagenes necesarias para la imagen de fondo
        numImagenes = 9;

        %% Porcentaje de reduccion de imagen
        rd = 0.4;

        %% Utilizado para cuando salgamos de No disponible avanzamos numImagenes para calculo de fondo
        salta = false;
        
        %% Saco las plantillas de la camX
        nombre = split(string(fileNames(1,1)),'_');
        nomFormato = split(nombre(3),'.');
        cam = nomFormato(1);
        %Plantillas sacadas a mano
        plantilla = getPlantillas(cam);
        %Plantillas automatizadas
        % plantillab = getPlantillasB(cam);

        [f c m] = size(plantilla);

        % Redimensiono las plantillas si es necesario
        if(f > 1000)
            plantilla = imresize(plantilla,rd);
        %     plantillab = imresize(plantillab,rd);
        end

        %% Realizo un bucle por el numero de imagenes de la carpeta
        [filas, columnas] = size(fileNames);
    
        i = (numImagenes + 1);
        
        while (i <= columnas)
            %% Capturo error por archivo corrupto
            try
                %% Selecciono la imagen a analizar
                I = imread(string(fileNames(1,i)));

                %% Relleno datos de la camara
                nombre = split(string(fileNames(1,i)),'_');
                datosCamara = [cam, nombre(1,1), nombre(2,1)];

                %% Compruebo si la camara esta disponible 
                disponible = camDisponible(I);

                %% Si la camara esta disponible realizo todas las operaciones
                if(disponible)  
                    %% Si la anterior es no Disponible
                    if (salta)
                        i = i + numImagenes + 1;
                        I = imread(string(fileNames(1,i)));
                        nombre = split(string(fileNames(1,i)),'_');
                        datosCamara = [cam, nombre(1,1), nombre(2,1)];
                        salta = false;
                    end
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
                        imagen = imagen + 1;
                    end

                    %% Creo la imagen de fondo
                    ifondo = calculaFondo(imagenStruct, numImagenes);
                    % imshow(ifondo)

                    %% Utilizando plantilla extraida con roipoly
                    [ocupacion] = getOcupacionA(plantilla, ifondo, I);

                    %% Muestro resultados
                    figure('WindowState','maximized');
                    subplot(1,2,1), imshow(I);
                    title("Imagen original " + ocupacion);
                    subplot(1,2,2), imshow(ifondo);
                    title("Fondo calculado");
                    
                    pause;
                    close;

                    %% Concateno resultados
                    datosCamara = [datosCamara ocupacion];

                %% Si la camara no esta disponible
                else
                    %% Concateno datos 'NO DISPONIBLE'
                    datosCamara = [ datosCamara [ 'NO DISPONIBLE']]; 
                    salta = true;
                end

                %% Guardo datos extraidos
                DatosFinales = [DatosFinales ; datosCamara];

                "camara " + cont
                "imagen " + i + " de " + columnas
            
            catch
            
            % Capturo el error de la lectura de imagenes
            "Error imagen " + string(fileNames(1,i))
            
            end
            
            % Aumento iterador
            i = i + 1;
            
        end
    end
end

%save ../Datos/Datos.mat DatosFinales
