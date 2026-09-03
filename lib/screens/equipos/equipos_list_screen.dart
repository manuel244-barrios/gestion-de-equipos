import 'package:flutter/material.dart';
import '../../models/equipo.dart';
import '../../services/supabase_service.dart';
import 'registrar_equipo_screen.dart';

class EquiposListScreen extends StatefulWidget {
  const EquiposListScreen({super.key});

  @override
  State<EquiposListScreen> createState() => _EquiposListScreenState();
}

class _EquiposListScreenState extends State<EquiposListScreen> {
  List<Equipo> _equipos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEquipos();
  }

  Future<void> _loadEquipos() async {
    try {
      final equipos = await SupabaseService().getEquipos();
      setState(() {
        _equipos = equipos;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading equipos: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        title: const Text('Equipos', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total de equipos: ${_equipos.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _equipos.length,
                    itemBuilder: (context, index) {
                      final equipo = _equipos[index];
                      return _buildEquipoItem(equipo);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrarEquipoScreen()),
          );
        },
        backgroundColor: const Color(0xFF673AB7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEquipoItem(Equipo equipo) {
    final bool isMal = equipo.estado == EstadoEquipo.mal;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.computer, size: 40, color: Colors.grey),
        ),
        title: Text(
          equipo.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código: ${equipo.codigo}'),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Estado: '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isMal ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isMal ? 'Mal' : 'Bien',
                    style: TextStyle(
                      color: isMal ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
