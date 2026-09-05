import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/equipo.dart';
import '../../services/supabase_service.dart';

class RegistrarEquipoScreen extends StatefulWidget {
  const RegistrarEquipoScreen({super.key});

  @override
  State<RegistrarEquipoScreen> createState() => _RegistrarEquipoScreenState();
}

class _RegistrarEquipoScreenState extends State<RegistrarEquipoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _especificacionesController = TextEditingController();
  final _observacionesController = TextEditingController();
  
  String _estadoActual = 'Bien';
  File? _imageFile;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveEquipo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      String? imageUrl;
      if (_imageFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await SupabaseService().uploadEquipoImage(_imageFile!, fileName);
      }

      final nuevoEquipo = Equipo(
        id: '', // Supabase generará el UUID
        nombre: _nombreController.text.trim(),
        codigo: _codigoController.text.trim(),
        especificaciones: _especificacionesController.text.trim(),
        observaciones: _observacionesController.text.trim(),
        estado: _estadoActual == 'Bien' ? EstadoEquipo.bien : EstadoEquipo.mal,
        createdAt: DateTime.now(),
        imagenUrl: imageUrl,
      );

      await SupabaseService().registrarEquipo(nuevoEquipo);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Equipo registrado con éxito')),
        );
        Navigator.pop(context, true); // Retornar true para indicar que hubo cambios
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _especificacionesController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        title: const Text('Registrar equipo', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isSaving 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagePicker(),
                  const SizedBox(height: 24),
                  _buildLabel('Nombre del equipo'),
                  _buildTextField(_nombreController, 'Ej. Laptop Dell Inspiron 15'),
                  const SizedBox(height: 16),
                  _buildLabel('Código del equipo'),
                  _buildTextField(_codigoController, 'Ej. EQ-001'),
                  const SizedBox(height: 16),
                  _buildLabel('Especificaciones'),
                  _buildTextField(_especificacionesController, 'Ej. Procesador i5, 8GB RAM...', maxLines: 3),
                  const SizedBox(height: 16),
                  _buildLabel('Observaciones'),
                  _buildTextField(_observacionesController, 'Ej. Buen estado general', maxLines: 2),
                  const SizedBox(height: 24),
                  const Text('Estado actual', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Bien',
                        groupValue: _estadoActual,
                        onChanged: (value) => setState(() => _estadoActual = value!),
                      ),
                      const Text('Bien'),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Mal',
                        groupValue: _estadoActual,
                        onChanged: (value) => setState(() => _estadoActual = value!),
                      ),
                      const Text('Mal'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveEquipo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF673AB7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Guardar equipo', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            image: _imageFile != null 
              ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover) 
              : null,
          ),
          child: _imageFile == null 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text('Agregar foto', style: TextStyle(color: Colors.grey[600])),
                ],
              )
            : null,
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
