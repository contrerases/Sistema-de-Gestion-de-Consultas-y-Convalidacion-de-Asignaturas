// Environment Configuration
// Lee las variables de entorno y las exporta como constantes

// API Configuration
export const API_CONFIG = {
  BASE_URL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api',
  TIMEOUT: parseInt(import.meta.env.VITE_API_TIMEOUT || '10000'),
  RETRY_ATTEMPTS: parseInt(import.meta.env.VITE_API_RETRY_ATTEMPTS || '3'),
} as const

// App Configuration
export const APP_CONFIG = {
  NAME: import.meta.env.VITE_APP_NAME || 'Sistema de Gestión',
  VERSION: import.meta.env.VITE_APP_VERSION || '1.0.0',
  ENVIRONMENT: import.meta.env.MODE || 'development',
  DEBUG: import.meta.env.DEV || false,
} as const

// Auth Configuration
export const AUTH_CONFIG = {
  TOKEN_KEY: import.meta.env.VITE_AUTH_TOKEN_KEY || 'auth_token',
  USER_KEY: import.meta.env.VITE_AUTH_USER_KEY || 'auth_user',
  REFRESH_TOKEN_KEY: import.meta.env.VITE_AUTH_REFRESH_TOKEN_KEY || 'refresh_token',
  TOKEN_EXPIRY: parseInt(import.meta.env.VITE_AUTH_TOKEN_EXPIRY || '3600'), // 1 hora
} as const

// Feature Flags
export const FEATURE_FLAGS = {
  ENABLE_NOTIFICATIONS: import.meta.env.VITE_ENABLE_NOTIFICATIONS === 'true',
  ENABLE_ANALYTICS: import.meta.env.VITE_ENABLE_ANALYTICS === 'true',
  ENABLE_DEBUG_MODE: import.meta.env.VITE_ENABLE_DEBUG_MODE === 'true',
} as const

// Pagination Configuration
export const PAGINATION_CONFIG = {
  DEFAULT_PAGE_SIZE: parseInt(import.meta.env.VITE_DEFAULT_PAGE_SIZE || '10'),
  MAX_PAGE_SIZE: parseInt(import.meta.env.VITE_MAX_PAGE_SIZE || '100'),
  PAGE_SIZE_OPTIONS: [10, 25, 50, 100],
} as const

// File Upload Configuration
export const FILE_UPLOAD_CONFIG = {
  MAX_FILE_SIZE: parseInt(import.meta.env.VITE_MAX_FILE_SIZE || '5242880'), // 5MB
  ALLOWED_FILE_TYPES: import.meta.env.VITE_ALLOWED_FILE_TYPES?.split(',') || [
    'application/pdf'
  ],
  UPLOAD_ENDPOINT: import.meta.env.VITE_UPLOAD_ENDPOINT || '/upload',
} as const

// Validation Configuration
export const VALIDATION_CONFIG = {
  PASSWORD_MIN_LENGTH: parseInt(import.meta.env.VITE_PASSWORD_MIN_LENGTH || '8'),
  PASSWORD_REQUIRE_UPPERCASE: import.meta.env.VITE_PASSWORD_REQUIRE_UPPERCASE === 'true',
  PASSWORD_REQUIRE_NUMBERS: import.meta.env.VITE_PASSWORD_REQUIRE_NUMBERS === 'true',
  PASSWORD_REQUIRE_SPECIAL_CHARS: import.meta.env.VITE_PASSWORD_REQUIRE_SPECIAL_CHARS === 'true',
} as const 