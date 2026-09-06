import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/supabase_service.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await SupabaseService().getFullStats();
      setState(() {
        _data = stats;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stats: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        title: const Text('Estadísticas', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumen de estados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildPieChart(),
                  const SizedBox(height: 40),
                  const Text('Equipos por categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildCategoryList(),
                ],
              ),
            ),
    );
  }

  Widget _buildPieChart() {
    final summary = _data['summary'] as Map<String, int>;
    final total = summary['total'] ?? 0;
    final bien = summary['bien'] ?? 0;
    final mal = summary['mal'] ?? 0;
    final pendientes = summary['pendientes'] ?? 0;
    final verificados = _data['verificados'] ?? 0;

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              sections: [
                PieChartSectionData(color: Colors.green, value: bien.toDouble(), radius: 20, showTitle: false),
                PieChartSectionData(color: Colors.red, value: mal.toDouble(), radius: 20, showTitle: false),
                PieChartSectionData(color: Colors.orange, value: pendientes.toDouble(), radius: 20, showTitle: false),
                PieChartSectionData(color: Colors.blue, value: verificados.toDouble(), radius: 20, showTitle: false),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$total', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('Total', style: TextStyle(color: Colors.grey)),
            ],
          ),
          Positioned(
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(Colors.green, 'Bien ($bien)'),
                _buildLegendItem(Colors.red, 'Mal ($mal)'),
                _buildLegendItem(Colors.orange, 'Pendientes ($pendientes)'),
                _buildLegendItem(Colors.blue, 'Verificados ($verificados)'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = _data['categories'] as Map<String, int>;
    if (categories.isEmpty) return const Text('No hay datos por categoría');

    return Column(
      children: categories.entries.map((entry) {
        IconData icon;
        switch (entry.key.toLowerCase()) {
          case 'informática':
            icon = Icons.computer;
            break;
          case 'audio/visual':
            icon = Icons.videocam;
            break;
          case 'oficina':
            icon = Icons.business_center;
            break;
          default:
            icon = Icons.more_horiz;
        }

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: ListTile(
            leading: Icon(icon, color: Colors.grey[600]),
            title: Text(entry.key),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
