import 'package:flutter/foundation.dart';

enum Categoria {
  Comida,
  Transporte,
  Entretenimiento,
  Salud,
  Educacion,
  Hogar,
  Otros,
}

class Gasto {
  String id;
  String descripcion;
  double monto;
  Categoria categoria;
  DateTime fecha;

  Gasto({
    String? id,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    required this.fecha,
  }) : id = id ?? UniqueKey().toString();
}
