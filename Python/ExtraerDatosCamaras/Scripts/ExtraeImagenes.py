#!/usr/bin/env python
# coding: utf-8

# In[34]:


# -*- coding: utf-8 -*-
import requests
from os.path import join
import os
import datetime


# ## Variables Globles

# In[35]:


DATOS = join(".","Datos")


# ## Funciones Auxiliares

# In[36]:


# Extra la hora actual
def extraer_hora():
    x = datetime.datetime.now()
    ano = ("{0:02}{1:02}{2:02}".format(x.year,x.month,x.day))
    hora = ("{0:02}{1:02}".format(x.hour,x.minute))
    return ano + "_" + hora


# In[37]:


# Descarga la imagen de la camara X en la carpeta X
def descarga_camara(numero):
    url = "http://trafico.sevilla.org/camaras/cam" + str(numero) + ".jpg"
    page = requests.get(url)
    if page.status_code == 200:
        os.makedirs(join(DATOS,'cam' + str(numero)), exist_ok=True)
        local = join(DATOS,"cam" + str(numero), extraer_hora() + "_cam" + str(numero) + ".jpg")
        imagen = page.content
        with open(local, 'wb') as handler:
            handler.write(imagen)
        return True
    else:
        return False


# In[38]:


# Se asegura que sólo hay 10 imagenes en la carpeta
def limpiaCarpeta(camara):
    carpeta = "./Datos/cam" + str(camara)
    listImagenes = os.listdir(carpeta)
    imagenes = len(listImagenes)
    while imagenes > 10:
        os.remove("./Datos/cam" + str(camara) + "/" + listImagenes[0])
        listImagenes.remove(listImagenes[0])
        imagenes = len(listImagenes)


# ## Codigo

# In[42]:


for i in range(1,100):
    # Descarga la imagen en la carpeta
    d = descarga_camara(i)
    
    # Si da cualquier error avisa
    if not d:
        print("Descarga fallida en:",i)
    # Y sino, se asegura que dentro de la carpeta sólo haya 10 imagenes
    else:
        limpiaCarpeta(i)


# In[ ]:




