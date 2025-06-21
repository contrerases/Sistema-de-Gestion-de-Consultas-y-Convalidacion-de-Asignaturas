<template>
  <main class="stats-main">
    <h1 class="stats-title">Estadísticas</h1>
    <div class="stats-content">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Gráfico de barras: Asignaturas más cursadas -->
        <div class="bg-card shadow-md rounded-lg p-5 chart-container">
          <Bar :data="mostCursedSubjectsData" :options="chartOptions" />
        </div>

        <div class="bg-card shadow-md rounded-lg p-5 chart-container">
          <Bar :data="bestRatedWorkshopsData" :options="chartOptions" />
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
        <!-- Gráfico de pastel: Porcentaje de tipos de convalidación -->
        <div class="bg-card shadow-md rounded-lg p-5 chart-container">
          <Pie :data="convalidationTypesData" :options="chartOptions" />
        </div>

         <!-- Gráfico de líneas: Talleres con más participación -->
         <div class="bg-card shadow-md rounded-lg p-5 chart-container">
          <Bar :data="mostParticipatedWorkshopsData" :options="chartOptions" />
        </div>
      </div>
    </div>
  </main>
</template>

<script setup lang="ts">
import { Bar, Line, Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement } from 'chart.js';

// Registrar los componentes de Chart.js
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement);

// Opciones del gráfico
const chartOptions = {
  responsive: true,
  plugins: {
    legend: {
      display: true,
      position: 'top',
    },
  },
};

// Datos para asignaturas más cursadas
const mostCursedSubjectsData = {
  labels: ['Matemáticas', 'Física', 'Química', 'Historia', 'Inglés'],
  datasets: [
    {
      label: 'Número de estudiantes',
      backgroundColor: '#42A5F5',
      data: [120, 90, 75, 60, 50],
    },
  ],
};

// Datos para talleres con más participación
const mostParticipatedWorkshopsData = {
  labels: ['Taller A', 'Taller B', 'Taller C', 'Taller D', 'Taller E'],
  datasets: [
    {
      label: 'Participantes',
      backgroundColor: '#66BB6A',
      data: [200, 150, 180, 120, 100],
    },
  ],
};

// Datos para porcentaje de tipos de convalidación
const convalidationTypesData = {
  labels: ['Interna', 'Externa', 'Taller', 'Proyecto', 'Certificado'],
  datasets: [
    {
      label: 'Porcentaje',
      backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF'],
      data: [30, 25, 20, 15, 10],
    },
  ],
};

// Datos para talleres con mejores notas
const bestRatedWorkshopsData = {
  labels: ['Taller A', 'Taller B', 'Taller C', 'Taller D', 'Taller E'],
  datasets: [
    {
      label: 'Promedio de Notas',
      backgroundColor: '#FFCE56',
      data: [4.5, 4.0, 3.8, 4.2, 3.5],
    },
  ],
};

// Datos para la tabla de convalidaciones
const convalidationsData = [
  { id: 1, courseName: 'Matemáticas', convalidationType: 'Interna', status: 'Aprobada' },
  { id: 2, courseName: 'Física', convalidationType: 'Externa', status: 'Pendiente' },
  { id: 3, courseName: 'Química', convalidationType: 'Interna', status: 'Rechazada' },
  { id: 4, courseName: 'Historia', convalidationType: 'Externa', status: 'Aprobada' },
  { id: 5, courseName: 'Inglés', convalidationType: 'Taller', status: 'Aprobada' },
];
</script>

<style scoped lang="postcss">
.stats-main {
  @apply flex flex-col mx-5 px-10 mt-16 h-screen relative;
}

.stats-title {
  @apply text-5xl font-bold tracking-tight border-b border-border pb-5;
}

.stats-content {
  @apply m-0 pt-10;
}

.chart-container {
  @apply w-full h-96; /* Asegúrate de que los gráficos tengan un tamaño adecuado */
}
</style>
