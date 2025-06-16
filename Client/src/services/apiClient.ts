// src/services/apiClient.ts
import axios from 'axios';

// 1. Crear una instancia de Axios con la configuración base.
//    Vite expone las variables de .env en `import.meta.env`.
const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  }
});

// 2. (Opcional pero recomendado) Interceptor para añadir el token JWT a cada petición.
//    Esto centraliza la lógica de autenticación.
apiClient.interceptors.request.use(
  config => {
    // Obtén el token de donde lo almacenes (localStorage, Pinia store, etc.)
    const token = localStorage.getItem('authToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

export default apiClient;
