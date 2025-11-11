import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evaluacion/models/gastos.dart';

class ResumenMensual extends StatelessWidget {
  final List<Gasto> gastos;

  const ResumenMensual({super.key, required this.gastos});

  Map<Categoria, double> _calcularDesglosePorCategoria(List<Gasto> gastosMes) {
    final Map<Categoria, double> desglose = {};
    for (var categoria in Categoria.values) {
      desglose[categoria] = 0.0;
    }

    for (var gasto in gastosMes) {
      desglose.update(gasto.categoria, (value) => value + gasto.monto);
    }

    desglose.removeWhere((key, value) => value == 0);

    return desglose;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');
    final mesActual = DateTime.now().month;
    final anoActual = DateTime.now().year;

    final gastosMes = gastos
        .where((g) => g.fecha.month == mesActual && g.fecha.year == anoActual)
        .toList();

    final totalMes = gastosMes.fold(0.0, (sum, g) => sum + g.monto);

    final desglose = _calcularDesglosePorCategoria(gastosMes);

    return Scaffold(
      appBar: AppBar(title: Text('Resumen del Mes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Total Gastado este Mes:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    formatter.format(totalMes),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 40),
            Text(
              'Desglose por Categoría:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Expanded(
              child: desglose.isEmpty
                  ? Center(child: Text('No hay gastos este mes.'))
                  : ListView(
                      children: desglose.entries.map((entry) {
                        return Card(
                          child: ListTile(
                            leading: Icon(_getIconForCategory(entry.key)),
                            title: Text(entry.key.name),
                            trailing: Text(formatter.format(entry.value)),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
}
