# Reglas de Estilo y Organización del Proyecto

## Reglas para el código SQL

1. **Organización de archivos y secciones**
   - Las restricciones SQL deben organizarse por nombre de tabla.
   - Dentro de cada tabla, agrupar en subsecciones: claves foráneas, claves únicas y validación de datos.
   - Las claves foráneas deben estar ordenadas correctamente en el archivo de claves foráneas.

2. **Convenciones de nombres**
   - Los campos identificadores deben llamarse `<nombre>_id` (ejemplo: `USER_ID`).
   - Las claves foráneas deben nombrarse como `id_<tabla>` (ejemplo: `id_user`).
   - Evitar el uso de alias de tablas.
   - Siempre referenciar las tablas con su nombre completo en mayúsculas (ejemplo: `TABLA.columna`).

3. **Estructura y edición**
   - No usar `ALTER TABLE`; en su lugar, modificar directamente el archivo `structure.sql`.
   - Mantener la organización existente de la estructura de la base de datos.

4. **Documentación y comentarios**
   - Incluir resúmenes al inicio de los archivos.
   - Los comentarios y la documentación deben ser breves y no verbosos.
   - Agrupar el contenido por tablas y por tipo, con descripciones breves de claves foráneas, restricciones, procedimientos y triggers.

5. **Constantes**
   - Los valores constantes deben definirse como constantes, preferentemente usando ENUMs (por ejemplo, tipos de notificación predeterminados).

---

## Reglas para el código en general

1. **Separación de responsabilidades**
   - Diferenciar claramente las responsabilidades de la base de datos, la API y el front-end.
   - Los comentarios y la información deben referirse solo a su área correspondiente.

2. **Nombres y convenciones**
   - Seguir las convenciones de nombres establecidas para cada área (por ejemplo, en SQL, ver arriba).

3. **Documentación**
   - Prefiere resúmenes y comentarios breves, evitando la verbosidad innecesaria.

4. **Constantes y enums**
   - Definir valores constantes como constantes o enums, según corresponda.

5. **Edición y mantenimiento**
   - Mantener la organización y estructura existente de los archivos.
   - No realizar cambios que rompan la coherencia del proyecto.
