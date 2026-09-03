enum EstadoEquipo { bien, mal }

enum CategoriaEquipo { informatica, audioVisual, oficina, otros }

class Equipo {
  final String id;
  final String nombre;
  final String codigo;
  final String? especificaciones;
  final String? observaciones;
  final EstadoEquipo estado;
  final String? categoria;
  final String? imagenUrl;
  final DateTime createdAt;

  Equipo({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.especificaciones,
    this.observaciones,
    required this.estado,
    this.categoria,
    this.imagenUrl,
    required this.createdAt,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      especificaciones: json['especificaciones'],
      observaciones: json['observaciones'],
      estado: json['estado'] == 'Mal' ? EstadoEquipo.mal : EstadoEquipo.bien,
      categoria: json['categoria'],
      imagenUrl: json['imagen_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'codigo': codigo,
      'especificaciones': especificaciones,
      'observaciones': observaciones,
      'estado': estado == EstadoEquipo.mal ? 'Mal' : 'Bien',
      'categoria': categoria,
      'imagen_url': imagenUrl,
    };
  }
}
