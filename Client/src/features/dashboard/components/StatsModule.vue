<template>
  <div class="flex flex-col space-y-6 p-6">
    <div class="flex items-center justify-between">
      <h1 class="text-3xl font-bold text-foreground">Estadísticas</h1>
      <p class="text-muted-foreground">Resumen de actividades del departamento</p>
    </div>

    <!-- Primera fila de gráficos -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <Card class="p-6">
        <div class="mb-4">
          <h3 class="text-lg font-semibold text-foreground mb-2">
            Asignaturas más cursadas
          </h3>
          <p class="text-sm text-muted-foreground">
            Distribución de estudiantes por asignatura
          </p>
        </div>
        <div class="h-80">
          <Bar :data="mostCursedSubjectsData" :options="chartOptions" />
        </div>
      </Card>

      <Card class="p-6">
        <div class="mb-4">
          <h3 class="text-lg font-semibold text-foreground mb-2">
            Talleres con mejores calificaciones
          </h3>
          <p class="text-sm text-muted-foreground">
            Promedio de notas por taller
          </p>
        </div>
        <div class="h-80">
          <Bar :data="bestRatedWorkshopsData" :options="chartOptions" />
        </div>
      </Card>
    </div>

    <!-- Segunda fila de gráficos -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <Card class="p-6">
        <div class="mb-4">
          <h3 class="text-lg font-semibold text-foreground mb-2">
            Tipos de convalidación
          </h3>
          <p class="text-sm text-muted-foreground">
            Distribución porcentual por tipo
          </p>
        </div>
        <div class="h-80">
          <Pie :data="convalidationTypesData" :options="chartOptions" />
        </div>
      </Card>

      <Card class="p-6">
        <div class="mb-4">
          <h3 class="text-lg font-semibold text-foreground mb-2">
            Talleres con más participación
          </h3>
          <p class="text-sm text-muted-foreground">
            Número de participantes por taller
          </p>
        </div>
        <div class="h-80">
          <Bar :data="mostParticipatedWorkshopsData" :options="chartOptions" />
        </div>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Bar, Line, Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement } from 'chart.js'


// Registrar los componentes de Chart.js
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)

// Opciones del gráfico
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top' as const,
    },
  },
}

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
}

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
}

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
}

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
}
</script>

<style scoped>
/* Estilos adicionales si se requieren */
</style>
