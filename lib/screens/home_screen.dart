import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'equipos/registrar_equipo_screen.dart';
import 'verificar/verificar_equipos_screen.dart';
import 'estadisticas/estadisticas_screen.dart';
import 'main_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> _stats = {'total': 0, 'bien': 0, 'mal': 0, 'pendientes': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final stats = await SupabaseService().getSummaryStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching stats: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text('Inicio', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen general',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EstadisticasScreen()),
                    );
                  },
                  child: _buildSummaryGrid(),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Acciones rápidas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildQuickActions(),
              ],
            ),
          ),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          '${_stats['total']}',
          'Equipos\nregistrados',
          Icons.desktop_windows,
          const Color(0xFFE3F2FD),
          const Color(0xFF1976D2),
        ),
        _buildStatCard(
          '${_stats['bien']}',
          'Equipos\nbien',
          Icons.check_circle_outline,
          const Color(0xFFE8F5E9),
          const Color(0xFF388E3C),
        ),
        _buildStatCard(
          '${_stats['mal']}',
          'Equipos\nmal',
          Icons.cancel_outlined,
          const Color(0xFFFFEBEE),
          const Color(0xFFD32F2F),
        ),
        _buildStatCard(
          '${_stats['pendientes']}',
          'Pendientes\nverificar',
          Icons.warning_amber_rounded,
          const Color(0xFFFFF3E0),
          const Color(0xFFF57C00),
        ),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: iconColor),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: iconColor.withOpacity(0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrarEquipoScreen()),
            );
            if (result == true) _fetchStats();
          },
          child: _buildActionButton('Registrar nuevo equipo', Icons.add_circle, const Color(0xFF673AB7)),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VerificarEquiposScreen()),
            );
            _fetchStats();
          },
          child: _buildActionButton('Verificar equipos', Icons.check_circle, Colors.green),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            // Navegar a la pestaña de equipos en el MainContainer
            // Para simplicidad, podemos navegar a la pantalla directamente o usar el Tab del MainContainer
            // Aquí navegaremos a la pantalla de equipos
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainContainer()),
            );
          },
          child: _buildActionButton('Ver equipos', Icons.list, Colors.blue),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
