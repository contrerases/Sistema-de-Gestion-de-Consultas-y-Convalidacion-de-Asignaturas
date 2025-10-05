---
applyTo: '**'
---

## PERFIL

- Nivel: **Desarrollador Junior**

## PREFERENCIAS Y RESTRICCIÓN FUNCIONAL

- El código generado debe ser lo más **simple**, **óptimo** y **legible** posible.
- El código debe **hacer únicamente** lo que se solicita; evitar _features_, abstracciones o dependencias adicionales.
- Preferir **claridad** y **Mantenibilidad** sobre trucos o micro-optimizaciones innecesarias.
- Comentar decisiones no obvias y patrones específicos del proyecto.
- Documentar el "por qué" cuando el "qué" no sea evidente.
- Para desarrolladores junior: agregar contexto en lógica compleja.
- Para preguntas simples, adjuntar breve documentación si es requerida, y un pequeño ejemplo de uso simple, que no esté relacionado con el contexto de la app.
- No documentar con MD amenos que se indique explicitamente.
- Solo usar documentacion oficial o fuentes altamente confiables.

## PROCESO ANTES DE GENERAR CÓDIGO

- No escribir codigo a menos que se pida explicitamente.
- Antes de escribir código, se debe presentar una **guía de pasos (plan de acción)** que incluya:

1. **Qué se hará**: lista ordenada de pasos ejecutables, en cuanto al algoritmo que se codificara, no al proceso de respuesta de la ia.
2. **Por qué se elige cada paso**: decisión técnica y justificación breve.
3. **Alternativas consideradas**: explicar por qué se descartaron.
4. **Impacto**: describir efectos en rendimiento, legibilidad y seguridad por cada decisión.

La guía debe ser clara, con formato visiblemente cómodo, concisa y sin ambigüedades.

## REGLAS DE TONO, FORMATO Y EXCLUSIÓN

- **Eliminar**: énfasis, relleno, exageraciones, peticiones suaves, transiciones conversacionales innecesarias, apéndices de llamado a la acción.
- **Responder**: al nivel técnico del contexto sin perder claridad.
- **Priorizar**: frases directas y contundentes; información ejecutable sobre narrativa.
- **Evitar**: redundancia emocional innecesaria.
- **Mantener**: neutralidad profesional sin frialdad extrema.
- **Permitir**: preguntas técnicamente necesarias para eliminar ambigüedad crítica.
- **Incluir**: clarificaciones que prevengan implementaciones incorrectas.
- **Terminar**: después de entregar información completa y verificable, con paso de verificación cuando sea relevante.
- **Objetivo**: información precisa, ejecutable y autosuficiente.

## REGLAS DE COMPONENTES VUE

- Crear los componentes los mas reutilizables posible.
- Codigo claro y consiso.
- Uso de slots y props
- Usar estrictamente Tailwind y sus clases, usar colores y variables definidas en index.css dentro de assets.
- Crear clase semantica en el componente, y luego a esta clase aplicar tailwind con la directiva @apply. Solo usar css, cuando se requiera oportuno.
- Modularizar todo lo posible, los componentes deben ser lo mas atomicos posibles.
- Usar archivos de configuracion o ayuda de ser nesesario.

## SQL RULES
- Para archivos sql sigue el siguiente patron:
- Nombres de las tablas sin alias y siempre en mayus, por ejemplo, TABLA.atributo.
- Si se requiere hacer cambios estrucutrales, modificar los archivos bases directamente. No usar ALTER TABLE
---
