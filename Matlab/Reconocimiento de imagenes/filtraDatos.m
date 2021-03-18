close all
clear 
clc

%% Añado al path la carpeta con los datos sin filtrar
addpath('../Datos');

%% Leo los datos sin filtrar
load('Datos.mat');
% EXPORTAR A CSV writematrix(DatosFinales,'..\Datos\DatosCSV.csv')

[f c] = size(DatosFinales);

cont = 1;
tam = f;

while ( cont < tam )
    if DatosFinales(cont,4) == 'NO DISPONIBLE'
      DatosFinales(cont,:) = []; 
      tam = tam - 1;
    else
        cont = cont + 1;
    end
end

[f c] = size(DatosFinales);
nombCam = DatosFinales(1,1);
nombCamAnterior = DatosFinales(1,1);
cam = [];

for i=1:f
    nombCam = DatosFinales(i,1);
    if nombCam ~= nombCamAnterior
        save("..\Datos\DatosFiltrados\" + nombCamAnterior + ".mat", "cam")
        cam = [];
    else
        cam = [ cam ; DatosFinales(i,:)];
    end
    
    if i == f
        save("..\Datos\DatosFiltrados\" + nombCamAnterior + ".mat", "cam")
    end
    
    nombCamAnterior = nombCam;
end
