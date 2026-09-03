# Investigación Inicial: Gestión de Equipos

## Objetivos del App
El propósito es gestionar y verificar el estado de equipos en un ambiente específico.
Funcionalidades clave:
- Autenticación de usuarios.
- Listado y búsqueda de equipos.
- Registro de nuevos equipos (incluyendo fotos).
- Proceso de verificación de estado.
- Notificaciones de actividades.
- Estadísticas visuales del inventario.

## Tech Stack Propuesto
- **UI:** Jetpack Compose (Material 3).
- **Lenguaje:** Kotlin.
- **Arquitectura:** MVVM + Clean Architecture.
- **Base de Datos & Auth:** Supabase (PostgreSQL + Auth + Storage).
- **Inyección de Dependencias:** Hilt.
- **Navegación:** Jetpack Navigation (Compose).
- **Carga de Imágenes:** Coil.
- **Red:** Supabase Kotlin SDK (o Ktor/Retrofit si se prefiere manual, pero el SDK es más directo).

## Esquema de Base de Datos (Supabase)

### Tabla: `equipos`
| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `id` | UUID (PK) | Identificador único. |
| `nombre` | Text | Nombre del equipo. |
| `codigo` | Text (Unique) | Código de inventario (ej. EQ-001). |
| `especificaciones`| Text | Detalles técnicos. |
| `observaciones` | Text | Comentarios generales. |
| `estado` | Text | 'Bien' o 'Mal'. |
| `categoria` | Text | 'Informática', 'Audio/Visual', 'Oficina', 'Otros'. |
| `imagen_url` | Text | Link a Supabase Storage. |
| `created_at` | Timestamp | Fecha de registro. |

### Tabla: `verificaciones`
| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `id` | UUID (PK) | |
| `equipo_id` | UUID (FK) | Referencia a `equipos`. |
| `estado_verif` | Text | 'Pendiente' o 'Verificado'. |
| `observaciones` | Text | Notas de la verificación. |
| `fecha` | Timestamp | |

### Tabla: `notificaciones`
| Columna | Tipo | Descripción |
| :--- | :--- | :--- |
| `id` | UUID (PK) | |
| `titulo` | Text | |
| `mensaje` | Text | |
| `tipo` | Text | 'info', 'success', 'warning', 'error'. |
| `fecha` | Timestamp | |
