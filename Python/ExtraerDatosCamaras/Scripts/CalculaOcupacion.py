#!/usr/bin/env python
# coding: utf-8

# In[34]:


import numpy as np
import scipy as sp
import matplotlib.pyplot as plt

# Para listar los archivos de una carpeta
import os
# Para importar archivos .mat
import scipy.io
# Para String to dateTime
import datetime
# 2d to 3d
from numpy import zeros, newaxis
# Para redimensionar
from PIL import Image
# Para abrir y guardar archivos csv
import csv
# Para imagenes binarias
from scipy import ndimage
# Para tic toc
import time
# Para envio de e-mails
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


# ## Manejo de .CSV

# In[35]:


# Crear archivo Datos.csv
def crearFichero():
    myData = [["Cam", "Date", "Ocp"]]
    myFile = open('Datos.csv', 'w', newline="")
    with myFile:
        writer = csv.writer(myFile)
        writer.writerows(myData)


# In[36]:


# Obtiene los datos del archivo Datos.csv
def obtieneFichero():
    fichero = open("./Datos.csv", newline="")
    lector = csv.reader(fichero)
    rownum = 0;
    datos = [];
    for fila in lector:
        datos.append(fila)
    return datos


# In[37]:


# Guarda el archivo Datos en el fichero Datos.csv
def guardarFichero(Datos):
    myFile = open('./Datos.csv', 'w', newline="")
    with myFile:
        writer = csv.writer(myFile)
        writer.writerows(Datos)


# ## Funciones Auxiliares

# In[38]:


# Obtiene las plantillas dada la camara por parámetro
def getPlantillas(cam):
    carpeta = "./Plantillas/" + cam
    listPlantillas = os.listdir(carpeta)
    variable = sp.io.loadmat(carpeta + "/" + listPlantillas[0])
    variable2 = np.array(variable["I_Plantilla"])
    plantillas = variable2[:, :, newaxis]    
    for i in range(1,len(listPlantillas)):
        pltil = sp.io.loadmat(carpeta + "/" + listPlantillas[i])
        pltil2 = np.array(pltil["I_Plantilla"])
        pltil2 = pltil2[:, :, newaxis]
        plantillas = np.concatenate([plantillas, pltil2], axis = 2)
    return plantillas


# In[39]:


# Redimensiona la plantilla pasada por parametro
def redimPlantillaUnica(planti):
    planti2 = np.concatenate([planti, planti], axis = 2)
    planti3 = np.concatenate([planti2, planti], axis = 2)
    tam = (720, 576)
    imagenInicial = Image.fromarray(planti3)
    imagenInicialRed = imagenInicial.resize(tam)
    ArrayRed = np.array(imagenInicialRed)
    a = np.array_split(ArrayRed,3,axis=2)
    return np.array(a[0])


# In[40]:


# Redimensiona el conjunto de plantillas pasadas por parámetros
def redimensionaPlantilla(plantillas):   
    tam = plantillas.shape
    conjuntPlantillas = np.array_split(plantillas,tam[2],axis=2)
    inicial = np.array(conjuntPlantillas[0][:][:])
    plantillaFinal = redimPlantillaUnica(inicial)
    for i in range(1,tam[2]):
        plant = np.array(conjuntPlantillas[i][:][:])
        plantillaFinal = np.concatenate([plantillaFinal, redimPlantillaUnica(plant)], axis = 2)
    return plantillaFinal


# In[41]:


# Visualiza plantillas pasadas por parámetro
def visualizaPlantillas(plantillas):
    tam = plantillas.shape
    a = np.array_split(plantillas,tam[2],axis=2)
    for i in range(0,len(a)):
        plt.figure()
        plt.imshow(a[i][:][:])


# In[42]:


# Redimensiona la imagen pasada por parametro
def redimensionaImagen(imagen):
    tam = (720, 576)
    iEs = Image.fromarray(imagen)
    iEsRed = iEs.resize(tam)
    return np.array(iEsRed)


# In[43]:


# True si la imagen pasada por parámetro es disponible
def camDisponible(iEstudio):
    disp = False
    noDisponible = Image.open('./No_Disponible/NO_DISPONIBLE.jpg')
    tam = noDisponible.size
    iEs = Image.fromarray(iEstudio)
    iEsRed = iEs.resize(tam)
    noArray = np.array(noDisponible)
    iEsArray = np.array(iEsRed)
    dif = iEsArray - noArray
    maximo = np.max(dif)
    if maximo == 0:
        disponible = False
    else:
        disponible = True
    return disponible


# In[44]:


# Devuleve True si se puede calcular el fondo, en caso contrario, significa que tenemos una imagen NO DISPONIBLE
def isFondoDisponible(cam, listImagenes):
    disponible = True
    encontrado = False
    i = 0
    while i < (len(listImagenes) - 1) and encontrado == False:
        disp = camDisponible(plt.imread("./Datos/"+ cam + "/" + listImagenes[i]))
        if disp:
            i += 1
        else:
            encontrado = True
            disponible = False
    return disponible


# In[45]:


# Dada la cam y la lista de las imagenes, te calcula el fondo de ellas gracias a la mediana
def calculaFondo(cam, listImagenes):
    imgsFondo = plt.imread("./Datos/"+ cam + "/" + listImagenes[0])
    tam = imgsFondo.shape
    imgsFondo = imgsFondo[:, :, :, newaxis] 
    trigger = 0
    iAnterior = imgsFondo
    for i in range(1, len(listImagenes) - 1):
        imgF = plt.imread("./Datos/"+ cam + "/" + listImagenes[i])
        imgF = imgF[:, :, :, newaxis] 
        if np.sum((iAnterior - imgF)[:]) == 0:
            trigger += 1
        iAnterior = imgF
        imgsFondo = np.concatenate([imgsFondo, imgF], axis = 3)
    fondo = np.median(imgsFondo, axis = 3).astype(int)
    if trigger > 2:
        mensaje = "Se ha repetido la imagen " + str(trigger) + " veces, puede ser que esté averiada"
        asunto = " Revisar " + str.upper(cam)
        enviaCorreo(asunto, mensaje)
    return fondo


# In[46]:


# Dada las plantillas, la imagen de fondo y la imagen de estudio devuelve la ocupación de esta imagen de estudio
def getOcupacion(plantillas, fondo, iEstudio):
    numPixeles = 3
    # En matlab desviamos 5 pixeles, pero aquí tarda mucho
    diff = encuadraImagen(iEstudio, fondo, numPixeles)

    # Equivalente a bwareaopen
    diffFiltrado = ndimage.binary_opening(diff, structure=np.ones((3,2))).astype(int)
    diffFiltrado = diffFiltrado[:,:,newaxis]

    tam = plantillas.shape
    ocupacion = np.zeros(tam[2]).astype(int)

    # Recorto la plantilla
    plantilla_Min = plantillas[numPixeles:tam[0]-numPixeles,numPixeles:tam[1]-numPixeles, :];
    a = np.array_split(plantilla_Min,tam[2],axis=2)

    for i in range(0, tam[2]):
        # Selecciono la plantilla i-esima
        I_Plantilla = np.array(a[i][:][:]);
        # Recorto la imagen
        I_Recortada = np.logical_and(I_Plantilla, diffFiltrado).astype(int)

        fila, columnas, matriz = I_Recortada.shape

        intervalo = round(fila/10);             

        I_Recortada[1:intervalo,:] = I_Recortada[1:intervalo,:] * 50;
        I_Recortada[intervalo + 1:2 * intervalo,:] = I_Recortada[intervalo + 1:2 * intervalo,:] * 40;
        I_Recortada[2 * intervalo + 1:3 * intervalo,:] = I_Recortada[2 * intervalo + 1:3 * intervalo,:] * 30;
        I_Recortada[3 * intervalo + 1:4 * intervalo,:] = I_Recortada[3 * intervalo + 1:4 * intervalo,:] * 25;
        I_Recortada[4 * intervalo + 1:5 * intervalo,:] = I_Recortada[4 * intervalo + 1:5 * intervalo,:] * 20;
        I_Recortada[5 * intervalo + 1:6 * intervalo,:] = I_Recortada[5 * intervalo + 1:6 * intervalo,:] * 15;
        I_Recortada[6 * intervalo + 1:7 * intervalo,:] = I_Recortada[6 * intervalo + 1:7 * intervalo,:] * 12;
        I_Recortada[7 * intervalo + 1:8 * intervalo,:] = I_Recortada[7 * intervalo + 1:8 * intervalo,:] * 9;
        I_Recortada[8 * intervalo + 1:9 * intervalo,:] = I_Recortada[8 * intervalo + 1:9 * intervalo,:] * 7;
        I_Recortada[9 * intervalo + 1:fila,:] = I_Recortada[9 * intervalo + 1:fila,:] * 5;

        ocupacion[i] = np.sum(I_Recortada[:])

    return np.amax(ocupacion[:])


# In[47]:


# Desplaza la imagen sobre la imagen de fondo para buscar el mejor resultado entre ellos
def encuadraImagen(I, ifondo, numPixeles):
    tam = fondo.shape
    ifondo2 = ifondo[numPixeles:tam[0]-numPixeles, numPixeles:tam[1]-numPixeles,:]
    desplazamiento = numPixeles * 2
    w = float("inf")

    for i in range(0,desplazamiento):
        for j in range(0,desplazamiento):
            Iprueba = I[i:(tam[0]-(desplazamiento-i)),j:(tam[1]-(desplazamiento-j)),:];
            res = Iprueba - ifondo2
            res2 = rgb2gray(res)
            res2[res2 < 70] = 0
            res2[res2 > 0] = 1
            if np.sum(res2[:]) < w:
                plantillaElegida = res2
                w = np.sum(res2[:])
    return plantillaElegida


# In[48]:


# Devuelve una imagen a color en una en blanco y negro
def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.2989, 0.5870, 0.1140])


# In[49]:


# Tic
def tic():
    return time.time()


# In[50]:


# Toc
def toc(t):
    print(time.time() - t)


# In[51]:


# Envia un correo electrónico 
def enviaCorreo(asunto, mensaje):
    # Correo de acceso al servidor
    MY_ADDRESS = "AnalisisCamarasSevilla@gmail.com"
    # Password de acceso a la cuenta de email
    PASSWORD = "Ricardo1991"

    # Configurar el servidor de correo
    s = smtplib.SMTP(host='smtp.gmail.com', port=587) # servidor y puerto
    s.starttls() # Conexion tls
    s.login(MY_ADDRESS, PASSWORD) # Iniciar sesion con los datos de acceso al servidor SMTP

    # Crear el Mensaje
    msg = MIMEMultipart()
    message = mensaje

    # Configurar los parametros del mensaje
    msg['From']=MY_ADDRESS
    msg['To']= "AnalisisCamarasSevilla@gmail.com"
    msg['Subject']= asunto

    # Agregar el texto del mensaje al mensaje
    msg.attach(MIMEText(message, 'plain'))

    # Enviar el mensaje
    s.send_message(msg)
    del msg

    # Finalizar sesion SMTP
    s.quit()


# ## Codigo

# In[52]:


# Para controlar el tiempo que tarda ( unos 122 segundos con 63 camaras)
#t = tic()

# Obtengo los datos del csv
try :
    datos = obtieneFichero()
except:
    crearFichero()
    datos = obtieneFichero()

# Numero de imagenes necesarias para la imagen de fondo
numImagenes = 9
    
for cont in range(1,67):
    if cont != 63:
        # Camara actual
        cam = "cam" + str(cont)

        # Listo las imagenes que hay en la carpeta
        carpeta = "./Datos/" + cam
        listImagenes = os.listdir(carpeta)

        # Compruebo si hay imagenes suficientes para calcular el fondo
        if len(listImagenes) > numImagenes:

            # Extraigo las plantillas de la camX
            plantillas = getPlantillas(cam)

            # Visualizo las plantillas
            # visualizaPlantillas(plantillas)

            # Dimensiones de las plantillas array
            size = plantillas.shape

            # Redimensiono plantillas si es necesario
            if size[0] > 576:
                plantillas = redimensionaPlantilla(plantillas)
                redimensionar = True
            else:
                redimensionar = False
                
            # Lo encapsulo en un try-catch por si da error de lectura
            try:
                # Leo la imagen de estudio
                iEstudio = plt.imread(carpeta+"/"+listImagenes[-1])
                # plt.imshow(iEstudio)

                if redimensionar:
                    iEstudio = redimensionaImagen(iEstudio)

                # Covierto fecha y hora en un String 
                nombre = listImagenes[-1].split("_")
                fecha_Hora = nombre[0]+nombre[1]

                # Podemos guardarlo como dateTime
                #fecha_Hora = datetime.datetime.strptime(nombre[0]+nombre[1], '%Y%m%d%H%M')

                # Compruebo si está disponible
                disponible = camDisponible(iEstudio)

                if disponible:
                    fondoDisponible = isFondoDisponible(cam, listImagenes)
                    if fondoDisponible:           
                        # Calcula el fondo
                        fondo = calculaFondo(cam, listImagenes)
                        # plt.imshow(fondo)
                    
                        if redimensionar:
                            fondo = redimensionaImagen(fondo.astype(np.uint8))

                        # Calculo ocupacion
                        ocupacion = getOcupacion(plantillas, fondo, iEstudio)

                        datoInsetar = [cam, str(fecha_Hora), str(ocupacion)]
                        # Inserto los datos nuevos
                        datos.append(datoInsetar)
                    else:
                        print("Fondo NO Disponible")
                        datoInsetar = [cam, fecha_Hora, "Fondo NO Disponible"]
                        # Inserto los datos nuevos
                        datos.append(datoInsetar)
                else:
                    print("Imagen No Disponible")
                    datoInsetar = [cam, fecha_Hora, "Cam NO Disponible"]
                    # Inserto los datos nuevos
                    datos.append(datoInsetar)
            except:
                mensaje = "Ha ocurrido un error inesperado en la ejecución del script"
                asunto = " Revisar " + str.upper(cam)
                enviaCorreo(asunto, mensaje)
                print("Error en " + str(cam))
        else:
            print("No hay imagenes suficientes para crear el fondo")

# Guardo el fichero con los nuevos datos
guardarFichero(datos)

# Para controlar el tiempo que tarda ( unos 122 segundos con 63 camaras)
#toc(t)


# %%
