# Tareas: Proyecto Gestión de Equipos (Flutter)

## Fase 1: Inicialización y Configuración
- [x] Limpiar archivos del proyecto nativo
- [x] Ejecutar `flutter create`
- [x] Configurar `pubspec.yaml` con dependencias
- [x] Crear estructura de carpetas (`lib/models`, `screens`, `services`, etc.)
- [x] Inicializar Supabase en `main.dart`

## Fase 2: Autenticación
- [x] Implementar `SupabaseService` para Auth
- [x] UI: Pantalla de Login
- [x] UI: Pantalla de Registro
- [ ] Lógica de navegación y manejo de sesión (Persistencia)

## Fase 3: Dashboard y Gestión de Equipos
- [x] Definir modelos de datos (`Equipo`)
- [x] Implementar CRUD de Equipos con Supabase (Lectura básica)
- [x] UI: Pantalla de Inicio (Resumen con tarjetas)
- [x] UI: Lista de Equipos
- [ ] UI: Detalle de Equipo

## Fase 4: Registro de Equipos Real (Mockup 4)
- [x] Configurar Bucket `equipos_fotos` en Supabase (Acción del usuario)
- [x] Implementar `uploadEquipoImage` en `SupabaseService`
- [x] Implementar `registrarEquipo` en `SupabaseService`
- [x] Actualizar `RegistrarEquipoScreen`:
    - [x] Agregar controladores de texto y validaciones
    - [x] Implementar selector de imagen con `image_picker`
    - [x] Lógica de guardado y manejo de estados (Cargando/Error)
- [ ] Probar registro completo con foto

## Fase 5: Flujo de Verificación (Mockups 6 y 7)
- [ ] UI: `VerificarEquiposScreen` con Tabs (Pendientes/Verificados)
- [ ] UI: `VerificarFormScreen` (Radio buttons + Notas)
- [ ] Lógica: Actualizar estado del equipo en Supabase

## Fase 6: Detalle y Estadísticas (Mockups 8 y 9)
- [ ] UI: `DetalleEquipoScreen` (Vista completa)
- [ ] UI: `EstadisticasScreen` (Gráfico de Pastel con `fl_chart`)
- [ ] Pulido final y validaciones
