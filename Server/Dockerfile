# Usa una imagen base de Python completa que incluye más dependencias
FROM python:3.9

# Establece el directorio de trabajo
WORKDIR /app

# Copia el archivo de requisitos primero (mejor aprovechamiento de la caché)
COPY requirements.txt .

# Instala las dependencias sin guardar caché
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto de los archivos de la aplicación
COPY . .

# Expone el puerto para la API
EXPOSE 8000

# Comando para ejecutar el script de inicio
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
