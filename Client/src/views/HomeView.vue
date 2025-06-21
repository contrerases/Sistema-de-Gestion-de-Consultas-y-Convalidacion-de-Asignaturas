<template>
  <div
    class="w-screen h-[800px] max-w-screen-2xl mx-auto rounded-2xl flex flex-row border-2 border-border p-10"
  >
    <!-- Sección de Login -->
    <div class="w-full lg:w-1/4 flex flex-col space-y-4">
      <div
        class="bg-card text-card-foreground rounded-[var(--radius)] shadow p-4"
      >
        <h2 class="text-lg font-bold mb-2">Inicio de Sesión</h2>
        <!-- Formulario de login -->
        <form @submit.prevent="login">
          <label for="username" class="block mb-2">Nombre de Usuario</label>
          <input
            id="username"
            type="text"
            v-model="loginForm.username"
            class="w-full p-2 border rounded-[var(--radius)] bg-input"
            placeholder="Introduce tu nombre de usuario"
          />
          <label for="password" class="block mt-4 mb-2">Contraseña</label>
          <input
            id="password"
            type="password"
            v-model="loginForm.password"
            class="w-full p-2 border rounded-[var(--radius)] bg-input"
            placeholder="Introduce tu contraseña"
          />
          <button
            type="submit"
            class="mt-4 bg-primary text-primary-foreground py-2 px-4 rounded-[var(--radius)] hover:bg-primary/90"
          >
            Iniciar Sesión
          </button>
        </form>
      </div>

      <!-- Sección de Logo -->
      <div
        class="bg-card text-card-foreground rounded-[var(--radius)] shadow p-16 h-full flex justify-center items-center"
      >
        <img src="@/assets/img/DI_IMG.png" alt="Logo de la Universidad" />
      </div>
    </div>

    <!-- Sección de Bienvenida -->
    <div
      class="w-full lg:w-3/4 bg-card text-card-foreground rounded-[var(--radius)] shadow p-6 px-12 ml-6 overflow-auto"
    >
      <h1
        class="text-4xl font-bold mb-4 flex items-center w-full justify-center text-primary py-10 text-center uppercase"
      >
        Bienvenido al Sistema de Gestión de Convalidaciones y Talleres
      </h1>
      <p class="mb-6">
        Este sistema está diseñado para facilitar la gestión de convalidaciones
        y talleres, optimizando los procesos académicos y mejorando la
        experiencia de estudiantes, profesores y administradores.
      </p>

      <!-- Sub-sección de Convalidaciones -->
      <section class="mb-6">
        <h2 class="text-3xl font-bold mb-6 text-primary uppercase">
          Sobre las Convalidaciones
        </h2>
        <p class="mb-6 text-lg text-foreground">
          El sistema permite realizar solicitudes de convalidaciones académicas
          de manera ágil y eficiente. A continuación, se describe cómo
          funcionan:
        </p>

        <!-- Tipos de Cursos Curriculares -->
        <section class="mb-6">
          <h3 class="text-2xl font-semibold mb-4 text-primary">
            Tipos de Cursos Curriculares
          </h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Libres:</strong> Son cursos generales que no están
              restringidos a un área específica. <em>Ejemplos:</em> Libre 1,
              Libre 2, ..., Libre N.
            </li>
            <li>
              <strong>Electivos:</strong> Son cursos opcionales que forman parte
              de la malla curricular. <em>Ejemplos:</em> Electivo 1, Electivo 2,
              ..., Electivo N.
            </li>
            <li>
              <strong>Electivos de Informática:</strong> Son electivos
              específicos impartidos por el departamento de informática.
              <em>Ejemplos:</em> Electivo de Informática 1, Electivo de
              Informática 2, ..., Electivo de Informática N.
            </li>
          </ul>
        </section>

        <!-- Tipos de Convalidaciones -->
        <section class="mb-6">
          <h3 class="text-2xl font-semibold mb-4 text-primary">
            Tipos de Convalidaciones
          </h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Asignaturas de Informática:</strong> Incluyen asignaturas
              y electivos ofrecidos por el departamento de informática.
            </li>
            <li>
              <strong>Asignaturas Externas:</strong> Se refieren a cursos
              realizados en otros departamentos.
            </li>
            <li>
              <strong>Cursos Certificados:</strong> Cursos realizados en
              plataformas online como Udemy o Coursera. <em>Nota:</em> Requieren
              un archivo PDF adicional que certifique la aprobación del curso.
            </li>
            <li>
              <strong>Talleres de INF:</strong> Talleres especiales organizados
              por el departamento de informática.
            </li>
            <li>
              <strong>Proyectos Personales:</strong> Actividades realizadas de
              manera independiente por el estudiante, supervisadas y avaladas
              por un tutor. <em>Nota:</em> Requieren un archivo PDF basado en
              una plantilla del sistema, que describe el proyecto y contiene la
              evaluación del tutor.
            </li>
          </ul>
        </section>

        <!-- Reglas de Convalidación -->
        <section>
          <h3 class="text-2xl font-semibold mb-4 text-primary">
            Reglas de Convalidación
          </h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Libres:</strong> Los cursos de tipo Libre pueden ser
              convalidados por cualquiera de los cinco tipos de convalidaciones:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
                <li>Asignaturas Externas.</li>
                <li>Cursos Certificados.</li>
                <li>Talleres de INF.</li>
                <li>Proyectos Personales.</li>
              </ul>
            </li>
            <li>
              <strong>Electivos:</strong> Los cursos de tipo Electivo pueden ser
              convalidados por:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
                <li>Asignaturas Externas.</li>
              </ul>
            </li>
            <li>
              <strong>Electivos de Informática:</strong> Los cursos de tipo
              Electivo de Informática solo pueden ser convalidados por:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
              </ul>
            </li>
          </ul>
        </section>
      </section>

      <!-- Sub-sección de Talleres -->
      <section>
        <h2 class="text-3xl font-bold mb-6 text-primary uppercase">
          Sobre los talleres
        </h2>
        <p class="mb-4">
          Los talleres de informática permiten a los estudiantes complementar su
          aprendizaje de manera práctica. El sistema facilita:
        </p>
        <ul class="list-disc ml-6">
          <li>
            Creación de talleres por los administradores, detallando el tema, el
            profesor a cargo, y las fechas de inicio y término.
          </li>
          <li>
            Publicación de los talleres por los profesores para que estén
            disponibles a los alumnos.
          </li>
          <li>
            Inscripciones de los alumnos, quienes deben aceptar un compromiso al
            registrarse.
          </li>
          <li>
            Gestión de inscripciones y asignación de notas a los alumnos por
            parte de los administradores.
          </li>
        </ul>
      </section>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { useAuthStore } from "@/shared/stores/auth_store"; // Importa el auth store
import { reactive } from "vue";
import { useRouter } from "vue-router";

// Instancia del auth store
const authStore = useAuthStore();
const router = useRouter();

// Definimos los valores reactivos para el formulario de inicio de sesión
const loginForm = reactive<{
  username: string;
  password: string;
}>({
  username: "",
  password: "",
});

// Método para manejar el inicio de sesión
const login = (): void => {
  if (loginForm.username === "admin" && loginForm.password === "1234") {
    authStore.setUser(
      1, // ID del usuario
      "admin", // Nombre de usuario
      "admin@example.com", // Correo electrónico
      "Administrador del Sistema", // Nombre completo
      "11111111-1", // RUT
      "admin",
      null // Rol
    );
    router.push({ name: "Administrador" });
    console.log(authStore.email);
  } else if (
    loginForm.username === "student" &&
    loginForm.password === "1234"
  ) {
    authStore.setUser(
      1, // ID del usuario
      "Camilo Contreras", // Nombre de usuario
      "camilo@example.com", // Correo electrónico
      "Camilo Contreras", // Nombre completo
      "20369538-1", // RUT
      "student",
      "201873063-7"
    );
    router.push({ name: "Estudiante" });
  } else {
    alert("Credenciales incorrectas. Intenta nuevamente.");
  }
};
</script>
