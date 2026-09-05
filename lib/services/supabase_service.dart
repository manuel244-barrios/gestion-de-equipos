import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/equipo.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  // Auth methods
  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // Equipment methods
  Future<Map<String, int>> getSummaryStats() async {
    // Para simplificar y asegurar compatibilidad, contamos los resultados de la lista
    final responseTotal = await client.from('equipos').select('id');
    final total = (responseTotal as List).length;

    final responseBien = await client.from('equipos').select('id').eq('estado', 'Bien');
    final bien = (responseBien as List).length;

    final responseMal = await client.from('equipos').select('id').eq('estado', 'Mal');
    final mal = (responseMal as List).length;

    final responsePendientes = await client.from('verificaciones').select('id').eq('estado_verif', 'Pendiente');
    final pendientes = (responsePendientes as List).length;

    return {
      'total': total,
      'bien': bien,
      'mal': mal,
      'pendientes': pendientes,
    };
  }

  Future<List<Equipo>> getEquipos() async {
    final response = await client.from('equipos').select().order('created_at', ascending: false);
    return (response as List).map((json) => Equipo.fromJson(json)).toList();
  }

  Future<String?> uploadEquipoImage(File imageFile, String fileName) async {
    try {
      final String path = await client.storage.from('equipos_fotos').upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      
      // Obtener la URL pública
      return client.storage.from('equipos_fotos').getPublicUrl(fileName);
    } catch (e) {
      print('Error al subir imagen: $e');
      return null;
    }
  }

  Future<void> registrarEquipo(Equipo equipo) async {
    await client.from('equipos').insert(equipo.toJson());
  }

  // Verification methods
  Future<List<Map<String, dynamic>>> getEquiposConVerificacion() async {
    // Obtenemos equipos y sus verificaciones
    final response = await client
        .from('equipos')
        .select('*, verificaciones(estado_verif, fecha_verificacion)')
        .order('created_at', ascending: false);
    
    return response as List<Map<String, dynamic>>;
  }

  Future<void> realizarVerificacion({
    required String equipoId,
    required String nuevoEstado,
    required String observaciones,
  }) async {
    // 1. Actualizar el estado en la tabla 'equipos'
    await client.from('equipos').update({'estado': nuevoEstado}).eq('id', equipoId);

    // 2. Insertar el registro en la tabla 'verificaciones'
    await client.from('verificaciones').insert({
      'equipo_id': equipoId,
      'estado_verif': 'Verificado',
      'observaciones_verif': observaciones,
      'fecha_verificacion': DateTime.now().toIso8601String(),
    });
  }
}
