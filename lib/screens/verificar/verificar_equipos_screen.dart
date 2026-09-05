import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import 'verificar_form_screen.dart';
import '../equipos/detalle_equipo_screen.dart';
import '../../models/equipo.dart';
import 'package:intl/intl.dart';

class VerificarEquiposScreen extends StatefulWidget {
  const VerificarEquiposScreen({super.key});

  @override
  State<VerificarEquiposScreen> createState() => _VerificarEquiposScreenState();
}

class _VerificarEquiposScreenState extends State<VerificarEquiposScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _equipos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await SupabaseService().getEquiposConVerificacion();
      setState(() {
        _equipos = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading verification data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = _equipos.where((e) {
      final verifs = e['verificaciones'] as List;
      return verifs.isEmpty || verifs.any((v) => v['estado_verif'] == 'Pendiente');
    }).toList();

    final verificados = _equipos.where((e) {
      final verifs = e['verificaciones'] as List;
      return verifs.isNotEmpty && verifs.any((v) => v['estado_verif'] == 'Verificado');
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF673AB7),
          title: const Text('Verificar equipos', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Pendientes (${pendientes.length})'),
              Tab(text: 'Verificados (${verificados.length})'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildList(pendientes, isPendiente: true),
                        _buildList(verificados, isPendiente: false),
                      ],
                    ),
                  ),
                  _buildConsejoCard(),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> list, {required bool isPendiente}) {
    if (list.isEmpty) {
      return Center(child: Text(isPendiente ? 'No hay equipos pendientes' : 'No hay equipos verificados'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final date = DateTime.parse(item['created_at']);
        final formattedDate = DateFormat('dd/MM/yyyy').format(date);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(item['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código: ${item['codigo']}'),
                Text('Registrado: $formattedDate'),
              ],
            ),
            trailing: isPendiente
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Pendiente',
                      style: TextStyle(color: Color(0xFFF57C00), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  )
                : const Icon(Icons.check_circle, color: Colors.green),
            onTap: isPendiente
                ? () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerificarFormScreen(equipo: item),
                      ),
                    );
                    if (result == true) _loadData();
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleEquipoScreen(equipo: Equipo.fromJson(item)),
                      ),
                    );
                  },
          ),
        );
      },
    );
  }

  Widget _buildConsejoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Color(0xFFF57C00)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Consejo', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF57C00))),
                Text(
                  'Verifica cada equipo y actualiza su estado según corresponda.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
