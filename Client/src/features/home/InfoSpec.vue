<template>
  <div class="w-full  bg-card text-card-foreground rounded-[var(--radius)] shadow p-6 px-12 ml-6 overflow-auto">
    <h1 class="text-4xl font-bold mb-4 flex items-center w-full justify-center text-primary py-10 text-center uppercase">Bienvenido al Sistema de Gestión de Convalidaciones y Talleres</h1>
    <p class="mb-6">
      Este sistema está diseñado para facilitar la gestión de convalidaciones y talleres, optimizando los procesos académicos
      y mejorando la experiencia de estudiantes, profesores y administradores.
    </p>

    <!-- Sub-sección de Convalidaciones -->
    <section class="mb-6">
        <h2 class="text-3xl font-bold mb-6 text-primary uppercase">Sobre las Convalidaciones</h2>
        <p class="mb-6 text-lg text-foreground">
          El sistema permite realizar solicitudes de convalidaciones académicas de manera ágil y eficiente. A continuación, se describe cómo funcionan:
        </p>
      
        <!-- Tipos de Cursos Curriculares -->
        <section class="mb-6">
          <h3 class="text-2xl font-semibold mb-4 text-primary ">Tipos de Cursos Curriculares</h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Libres:</strong> Son cursos generales que no están restringidos a un área específica.  
              <em>Ejemplos:</em> Libre 1, Libre 2, ..., Libre N.
            </li>
            <li>
              <strong>Electivos:</strong> Son cursos opcionales que forman parte de la malla curricular.  
              <em>Ejemplos:</em> Electivo 1, Electivo 2, ..., Electivo N.
            </li>
            <li>
              <strong>Electivos de Informática:</strong> Son electivos específicos impartidos por el departamento de informática.  
              <em>Ejemplos:</em> Electivo de Informática 1, Electivo de Informática 2, ..., Electivo de Informática N.
            </li>
          </ul>
        </section>
      
        <!-- Tipos de Convalidaciones -->
        <section class="mb-6">
          <h3 class="text-2xl font-semibold mb-4 text-primary ">Tipos de Convalidaciones</h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Asignaturas de Informática:</strong> Incluyen asignaturas y electivos ofrecidos por el departamento de informática.
            </li>
            <li>
              <strong>Asignaturas Externas:</strong> Se refieren a cursos realizados en otros departamentos.
            </li>
            <li>
              <strong>Cursos Certificados:</strong> Cursos realizados en plataformas online como Udemy o Coursera.  
              <em>Nota:</em> Requieren un archivo PDF adicional que certifique la aprobación del curso.
            </li>
            <li>
              <strong>Talleres de INF:</strong> Talleres especiales organizados por el departamento de informática.
            </li>
            <li>
              <strong>Proyectos Personales:</strong> Actividades realizadas de manera independiente por el estudiante, supervisadas y avaladas por un tutor.  
              <em>Nota:</em> Requieren un archivo PDF basado en una plantilla del sistema, que describe el proyecto y contiene la evaluación del tutor.
            </li>
          </ul>
        </section>
      
        <!-- Reglas de Convalidación -->
        <section>
          <h3 class="text-2xl font-semibold mb-4 text-primary ">Reglas de Convalidación</h3>
          <ul class="list-disc ml-6 text-foreground">
            <li>
              <strong>Libres:</strong> Los cursos de tipo Libre pueden ser convalidados por cualquiera de los cinco tipos de convalidaciones:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
                <li>Asignaturas Externas.</li>
                <li>Cursos Certificados.</li>
                <li>Talleres de INF.</li>
                <li>Proyectos Personales.</li>
              </ul>
            </li>
            <li>
              <strong>Electivos:</strong> Los cursos de tipo Electivo pueden ser convalidados por:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
                <li>Asignaturas Externas.</li>
              </ul>
            </li>
            <li>
              <strong>Electivos de Informática:</strong> Los cursos de tipo Electivo de Informática solo pueden ser convalidados por:
              <ul class="list-disc ml-6">
                <li>Asignaturas de Informática.</li>
              </ul>
            </li>
          </ul>
        </section>
      </section>
      

    <!-- Sub-sección de Talleres -->
    <section>
      <h2 class="text-3xl font-bold mb-6 text-primary uppercase">  Sobre los talleres</h2>
      <p class="mb-4">
        Los talleres de informática permiten a los estudiantes complementar su aprendizaje de manera práctica. El sistema facilita:
      </p>
      <ul class="list-disc ml-6">
        <li>Creación de talleres por los administradores, detallando el tema, el profesor a cargo, y las fechas de inicio y término.</li>
        <li>Publicación de los talleres por los profesores para que estén disponibles a los alumnos.</li>
        <li>Inscripciones de los alumnos, quienes deben aceptar un compromiso al registrarse.</li>
        <li>Gestión de inscripciones y asignación de notas a los alumnos por parte de los administradores.</li>
      </ul>
    </section>
  </div>
      
</template>