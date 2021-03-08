close all
clear 
clc

%% Localizo el path con la carpeta con los datos filtrados sin normalizar
addpath('../Datos/DatosFiltrados');

myPath = '../Datos/DatosFiltrados'; 
allCams = dir(fullfile(myPath,'*.mat'));
fileNames={allCams.name};

load(string(fileNames(1,1)));
minimo = min(str2double(cam(:,4)));
maximo = max(str2double(cam(:,4)));

a = normalize(str2double(cam(:,4)), 'range');
a = a * 100;

x = sort(str2double(cam(:,4)), 'descend');