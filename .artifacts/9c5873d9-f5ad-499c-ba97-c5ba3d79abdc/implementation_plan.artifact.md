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

### Fase 4: Registro de Equipos Real (Mockup 4)

#### [MODIFY] [supabase_service.dart](file:///E:/APP-EQUIPOS/lib/services/supabase_service.dart)
- Añadir método `uploadEquipoImage` para subir archivos al bucket `equipos_fotos`.
- Añadir método `registrarEquipo` para insertar el registro en la tabla `equipos`.

#### [MODIFY] [registrar_equipo_screen.dart](file:///E:/APP-EQUIPOS/lib/screens/equipos/registrar_equipo_screen.dart)
- Integrar `image_picker` para capturar fotos con la cámara o galería.
- Añadir `TextEditingController` para capturar: Nombre, Código, Especificaciones y Observaciones.
- Implementar validaciones básicas (campos obligatorios).
- Mostrar indicador de carga (`CircularProgressIndicator`) durante el guardado.

### Fase 5: Flujo de Verificación (Mockups 6 y 7)

#### [NEW] Pantalla de Verificación
- [NEW] [verificar_equipos_screen.dart](file:///E:/APP-EQUIPOS/lib/screens/verificar/verificar_equipos_screen.dart): Lista con pestañas "Pendientes" y "Verificados".
- [NEW] [verificar_form_screen.dart](file:///E:/APP-EQUIPOS/lib/screens/verificar/verificar_form_screen.dart): Formulario para actualizar estado (Bien/Mal).

### Fase 5: Detalle y Estadísticas (Mockups 8 y 9)

#### [NEW] Detalle del Equipo
- [NEW] [detalle_equipo_screen.dart](file:///E:/APP-EQUIPOS/lib/screens/equipos/detalle_equipo_screen.dart): Vista completa con foto y especificaciones.

#### [NEW] Pantalla de Estadísticas
- [NEW] [estadisticas_screen.dart](file:///E:/APP-EQUIPOS/lib/screens/estadisticas/estadisticas_screen.dart): Gráfico de pastel y desglose por categorías.

## Verification Plan

### Automated Tests
- Widget tests para las pantallas principales.
- Unit tests para los servicios de Supabase.

### Manual Verification
- Probar el flujo completo en un emulador Android.
- Verificar la persistencia de datos en el dashboard de Supabase.
