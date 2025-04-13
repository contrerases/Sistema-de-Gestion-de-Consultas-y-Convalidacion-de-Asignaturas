# Usa una imagen base de Node.js
FROM node:22-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos package.json y package-lock.json
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia el resto de los archivos de la aplicación
COPY . .

# Compila la aplicación
RUN npm run build

# Expone el puerto 80
EXPOSE 80

# Comando para ejecutar la aplicación
CMD ["npm", "run", "serve"]
