import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/equipo.dart';

class DetalleEquipoScreen extends StatelessWidget {
  final Equipo equipo;

  const DetalleEquipoScreen({super.key, required this.equipo});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy - h:mm a').format(equipo.createdAt);
    final bool isMal = equipo.estado == EstadoEquipo.mal;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        elevation: 0,
        title: const Text('Detalle del equipo', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipo.nombre,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Código: ${equipo.codigo}',
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(isMal),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildInfoSection('Especificaciones', equipo.especificaciones ?? 'No especificadas'),
                  const SizedBox(height: 24),
                  _buildInfoSection('Observaciones registradas', equipo.observaciones ?? 'Sin observaciones'),
                  const SizedBox(height: 24),
                  _buildInfoSection('Fecha de registro', formattedDate, icon: Icons.calendar_today),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: equipo.imagenUrl != null
            ? DecorationImage(image: NetworkImage(equipo.imagenUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: equipo.imagenUrl == null
          ? const Icon(Icons.computer, size: 100, color: Colors.grey)
          : null,
    );
  }

  Widget _buildStatusChip(bool isMal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isMal ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isMal ? 'Mal' : 'Bien',
        style: TextStyle(
          color: isMal ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: const Color(0xFF673AB7)),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
        ),
      ],
    );
  }
}
