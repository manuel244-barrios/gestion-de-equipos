# Plan de Implementación: App Gestión de Equipos (Flutter)

Este plan detalla la migración del proyecto de Kotlin Nativo a **Flutter** para permitir soporte multiplataforma (Android/iOS), manteniendo la integración con **Supabase** y los diseños originales.

## User Review Required

> [!WARNING]
> Procederé a limpiar los archivos de la versión nativa de Android creados anteriormente para evitar conflictos de estructura. El nuevo proyecto será puramente Flutter.

> [!IMPORTANT]
> Seguiremos usando el mismo esquema de base de datos de Supabase que ya configuramos.

## Proposed Changes

### Fase 1: Inicialización de Flutter

#### [NEW] Creación del Proyecto Flutter
- Ejecutar `flutter create .` en el directorio raíz.
- Configurar el nombre del paquete como `com.example.app_equipos`.

#### [NEW] Configuración de Dependencias (`pubspec.yaml`)
Añadiremos las librerías necesarias:
- `supabase_flutter`: Para la base de datos y autenticación.
- `provider` o `riverpod`: Para la gestión de estados.
- `google_fonts`: Para la tipografía.
- `image_picker`: Para tomar fotos de los equipos.
- `fl_chart`: Para las estadísticas (gráficos).

### Fase 2: Estructura y Autenticación

#### [NEW] Arquitectura de Carpetas
- `lib/models`: Modelos de datos (Equipo, Notificación).
- `lib/screens`: Pantallas (Login, Home, Inventory).
- `lib/services`: Lógica de Supabase.
- `lib/widgets`: Componentes reutilizables.

#### [NEW] Pantalla de Login y Registro
Implementación del diseño morado usando `Material 3` en Flutter.

### Fase 3: Funcionalidades Principales

#### [NEW] Dashboard (Inicio)
Cards con resumen de estados (Equipos bien, mal, pendientes).

#### [NEW] Inventario de Equipos
Lista con buscador y filtros.

#### [NEW] Registro de Equipos
Formulario con cámara y subida a Supabase Storage.

### Fase 4: Verificación y Estadísticas

#### [NEW] Pantalla de Verificación
Flujo para cambiar estados de los equipos.

#### [NEW] Pantalla de Estadísticas
Gráfico de pastel y desglose por categorías.

## Verification Plan

### Automated Tests
- Widget tests para las pantallas principales.
- Unit tests para los servicios de Supabase.

### Manual Verification
- Probar el flujo completo en un emulador Android.
- Verificar la persistencia de datos en el dashboard de Supabase.
