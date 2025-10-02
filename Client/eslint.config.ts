import vue from 'eslint-plugin-vue';
import typescript from '@typescript-eslint/eslint-plugin';
import parser from '@typescript-eslint/parser';
import vueParser from 'vue-eslint-parser';

export default [
  {
    ignores: [
      'node_modules',
      'dist',
      'coverage',
      '*.min.js',
      '*.bundle.js',
      'public',
      '*.config.js',
      '*.config.ts',
    ],
    files: ['**/*.vue', '**/*.ts', '**/*.tsx', '**/*.js', '**/*.jsx'],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: parser,
        ecmaVersion: 2020, // Permite sintaxis moderna de JS (ES2020)
        sourceType: 'module',
        extraFileExtensions: ['.vue'],
        project: './tsconfig.app.json', // Apunta al tsconfig principal para TypeScript
      },
    },
    plugins: {
      vue,
      '@typescript-eslint': typescript,
    },
    rules: {
      // ===== REGLAS GENERALES =====
      'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off', // Permite console.log en desarrollo, advierte en producción
      'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off', // Permite debugger en desarrollo, advierte en producción
      'prefer-const': 'error', // Fuerza el uso de 'const' cuando la variable no se reasigna
      'no-var': 'error', // Prohíbe el uso de 'var', fuerza 'let' o 'const'
      'no-trailing-spaces': 'error', // Prohíbe espacios en blanco al final de las líneas
      'eol-last': 'error', // Requiere una línea vacía al final del archivo

      // ===== REGLAS DE VUE 3 =====
      // Componentes
      'vue/no-undef-components': [
        'error',
        {
          ignorePatterns: ['router-link', 'router-view', 'Icon', 'ColorMode'], // Solo ignora componentes realmente globales
        },
      ], // Marca error si usas un componente no importado ni registrado
      'vue/multi-word-component-names': 'off', // Permite nombres de componentes de una sola palabra
      'vue/component-name-in-template-casing': ['error', 'PascalCase'], // Fuerza nombres de componentes en PascalCase en template
      'vue/component-definition-name-casing': ['error', 'PascalCase'], // Fuerza nombres de archivos de componentes en PascalCase
      'vue/component-options-name-casing': ['error', 'PascalCase'], // Fuerza nombres de opciones de componentes en PascalCase
      'vue/custom-event-name-casing': ['error', 'camelCase'], // Fuerza nombres de eventos personalizados en camelCase
      'vue/no-unused-components': 'error', // Marca componentes importados pero no usados en el template

      // Template
      'vue/no-unused-vars': 'error', // Marca variables no usadas en el template
      'vue/no-v-html': 'warn', // Advierte sobre v-html (riesgo de XSS)
      'vue/require-default-prop': 'off', // Permite props sin valor por defecto
      'vue/require-prop-types': 'off', // Permite props sin tipo explícito
      'vue/no-unused-properties': [
        'error',
        { groups: ['props', 'data', 'computed', 'methods'] },
      ], // Marca propiedades no usadas
      'vue/no-useless-v-bind': 'error', // Prohíbe v-bind innecesarios (ej: v-bind:id="id" cuando id ya es el valor)
      'vue/padding-line-between-blocks': ['error', 'always'], // Requiere línea vacía entre bloques de código
      'vue/prefer-separate-static-class': 'error', // Fuerza clases estáticas separadas de clases dinámicas
      'vue/define-macros-order': [
        'error',
        {
          // Define el orden de los macros de Vue
          order: ['defineProps', 'defineEmits', 'defineExpose'],
        },
      ],
      'vue/html-comment-content-spacing': ['error', 'always'], // Requiere espacios en comentarios HTML
      'vue/max-attributes-per-line': [
        'error',
        {
          // Limita atributos por línea en templates
          singleline: 3,
          multiline: {
            max: 1,
            allowFirstLine: false,
          },
        },
      ],
      // Script Setup específico
      'vue/no-ref-as-operand': 'error', // Prohíbe usar refs directamente como operandos (necesario en setup)
      'vue/component-api-style': ['error', ['script-setup', 'composition']], // Fuerza script setup y composition API
      'vue/html-indent': ['error', 2], // Fuerza indentación de 2 espacios en templates
      // ===== REGLAS DE TYPESCRIPT =====
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          caughtErrorsIgnorePattern: '^_',
        },
      ], // Marca variables no usadas en TypeScript
      '@typescript-eslint/no-explicit-any': 'warn', // Advierte sobre el uso de 'any' (pierde beneficios de TypeScript)
      // '@typescript-eslint/explicit-function-return-type': 'warn', // Advierte si no defines el tipo de retorno de funciones
      '@typescript-eslint/no-var-requires': 'error', // Prohíbe require() en favor de import
      '@typescript-eslint/prefer-nullish-coalescing': 'error', // Fuerza ?? en lugar de || para valores null/undefined
      '@typescript-eslint/prefer-optional-chain': 'error', // Fuerza ?. en lugar de && para acceso seguro a propiedades
      '@typescript-eslint/no-non-null-assertion': 'warn', // Advierte sobre ! (non-null assertion operator)
    },
  },
];
