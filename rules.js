// ========================================
// REGLAS IMPORTANTES DEL PROYECTO
// ========================================

const RULES = {
  // Reglas sobre archivos de entorno
  envFiles: {
    // Los archivos .env están comentados en .gitignore
    // Por eso se pueden crear archivos .env.*
    gitignoreStatus: "Los archivos .env están comentados en .gitignore, por lo que SÍ se pueden crear",
    
    // Docker Compose debe usar SOLO variables del .env
    dockerComposeRule: "El docker-compose.yml debe usar SOLO variables del archivo .env, NO tener valores por defecto",
    
    // Archivos de entorno disponibles
    availableFiles: [
      ".env.dev",
      ".env.prod", 
      ".env.test",
      ".env.example"
    ]
  },
  
  // Reglas sobre Docker
  docker: {
    // No usar valores por defecto en docker-compose
    noDefaults: "NO usar valores por defecto como ${VAR:-default} en docker-compose.yml",
    
    // Usar archivos de entorno específicos
    useEnvFiles: "Usar --env-file .env.development, .env.production, etc.",
    
    // Scripts disponibles
    scripts: [
      "dev.bat - Inicia entorno de desarrollo",
      "prod.bat - Inicia entorno de producción", 
      "test.bat - Inicia entorno de testing",
      "start-env.bat - Selector genérico de entornos"
    ],
    
    // Dockerfiles disponibles
    dockerfiles: {
      client: {
        development: "Dockerfile - Para desarrollo con hot reload",
        production: "Dockerfile.production - Para producción con nginx"
      },
      server: {
        development: "Dockerfile - Para desarrollo con --reload",
        production: "Dockerfile.production - Para producción sin --reload"
      }
    }
  },
  
  // Reglas específicas del usuario
  userRules: [
    "Los archivos .env están comentados en .gitignore, por eso se pueden crear",
    "El docker-compose.yml debe usar SOLO variables del .env, NO tener valores por defecto",
    "Guardar reglas importantes en rules.js a medida que se van diciendo",
    "Elegir Dockerfile según el ambiente: desarrollo vs producción",
    "Usar Dockerfile.production en lugar de Dockerfile.prod para consistencia",
    "En producción usar restart: always, en desarrollo restart: unless-stopped",
    "Usar .dev, .prod y .test para nombres de archivos (no development, production ni testing)"
  ]
};

// Exportar las reglas
module.exports = RULES; 