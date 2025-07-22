stateDiagram-v2
    [*] --> ENVIADA: Solicitud de convalidación
    ENVIADA --> RECHAZADA_DI: Rechazo por DI
    ENVIADA --> APROBADA_DI: Aprobación por Departamento de Informática.
    ENVIADA --> ENVIADA_DE: Envío a Dirección de estudio.
    ENVIADA_DE --> APROBADA_DE: Aprobación por Direccion de estudio.
    RECHAZADA_DI --> [*]: Fin
    APROBADA_DI --> [*]: Fin
    ENVIADA_DE --> [*]: Fin
    APROBADA_DE --> [*]: Fin