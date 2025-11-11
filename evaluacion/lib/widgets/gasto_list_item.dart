import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evaluacion/models/gastos.dart';

class GastoListItem extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GastoListItem({
    super.key,
    required this.gasto,
    required this.onDelete,
    required this.onEdit,
  });

  IconData _getIconForCategory(Categoria categoria) {
    switch (categoria) {
      case Categoria.Comida:
        return Icons.fastfood;
      case Categoria.Transporte:
        return Icons.directions_bus;
      case Categoria.Entretenimiento:
        return Icons.movie;
      case Categoria.Salud:
        return Icons.local_hospital;
      case Categoria.Educacion:
        return Icons.school;
      case Categoria.Hogar:
        return Icons.home;
      case Categoria.Otros:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(
            _getIconForCategory(gasto.categoria),
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          gasto.descripcion,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${gasto.categoria.name} - ${DateFormat.yMd('es_ES').format(gasto.fecha)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatter.format(gasto.monto),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue.shade700),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.shade700),
              onPressed: onDelete,
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ),
    );
  }
}
