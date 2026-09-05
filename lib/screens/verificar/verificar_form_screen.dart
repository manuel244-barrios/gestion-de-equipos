import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class VerificarFormScreen extends StatefulWidget {
  final Map<String, dynamic> equipo;
  const VerificarFormScreen({super.key, required this.equipo});

  @override
  State<VerificarFormScreen> createState() => _VerificarFormScreenState();
}

class _VerificarFormScreenState extends State<VerificarFormScreen> {
  late String _estadoSeleccionado;
  final _observacionesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.equipo['estado'] == 'Mal' ? 'Mal' : 'Bien';
  }

  Future<void> _updateStatus() async {
    setState(() => _isSaving = true);
    try {
      await SupabaseService().realizarVerificacion(
        equipoId: widget.equipo['id'],
        nuevoEstado: _estadoSeleccionado,
        observaciones: _observacionesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estado actualizado correctamente')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        title: const Text('Verificar equipo', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSection('Especificaciones', widget.equipo['especificaciones'] ?? 'No especificadas'),
                  const SizedBox(height: 16),
                  _buildSection('Observaciones registradas', widget.equipo['observaciones'] ?? 'Sin observaciones'),
                  const SizedBox(height: 24),
                  const Text('Estado actual', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Bien',
                        groupValue: _estadoSeleccionado,
                        onChanged: (val) => setState(() => _estadoSeleccionado = val!),
                      ),
                      const Text('Bien'),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Mal',
                        groupValue: _estadoSeleccionado,
                        onChanged: (val) => setState(() => _estadoSeleccionado = val!),
                      ),
                      const Text('Mal'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Observaciones de verificación', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _observacionesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ej. Todo funciona correctamente',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF673AB7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Actualizar estado', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            image: widget.equipo['imagen_url'] != null
                ? DecorationImage(image: NetworkImage(widget.equipo['imagen_url']), fit: BoxFit.cover)
                : null,
          ),
          child: widget.equipo['imagen_url'] == null ? const Icon(Icons.image, size: 50, color: Colors.grey) : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.equipo['nombre'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Código: ${widget.equipo['codigo']}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}
