close all
clear 
clc

P = imread("C:\Users\Ricar\Desktop\20210326_1949_cam8.jpg");

 x = "s";

while x == "s"

%% Recorto zona de interes 
I_Plantilla = roipoly(P);
% imshow(I_Plantilla)

%% Muestro por pantalla
figure
subplot(1,2,1), imshow(P);
subplot(1,2,2), imshow(I_Plantilla)

prompt = '¿Desea volver a hacerla? s | n ';
x = input(prompt, 's')
close all
end

save("C:\Users\Ricar\Desktop\cam8.mat", "I_Plantilla")