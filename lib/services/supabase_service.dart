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
}
