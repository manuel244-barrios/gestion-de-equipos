import 'package:flutter/material.dart';

class RegistrarEquipoScreen extends StatefulWidget {
  const RegistrarEquipoScreen({super.key});

  @override
  State<RegistrarEquipoScreen> createState() => _RegistrarEquipoScreenState();
}

class _RegistrarEquipoScreenState extends State<RegistrarEquipoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _estadoActual = 'Bien';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePlaceholder(),
              const SizedBox(height: 24),
              _buildTextField('Nombre del equipo', 'Ej. Laptop Dell Inspiron 15'),
              const SizedBox(height: 16),
              _buildTextField('Código del equipo', 'Ej. EQ-001'),
              const SizedBox(height: 16),
              _buildTextField('Especificaciones', 'Ej. Procesador i5, 8GB RAM...', maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField('Observaciones', 'Ej. Buen estado general', maxLines: 2),
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
                  onPressed: () {
                    // Lógica para guardar en Supabase (Próxima sesión)
                    Navigator.pop(context);
                  },
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

  Widget _buildImagePlaceholder() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('Agregar foto', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
