import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evaluacion/models/gastos.dart';
import 'package:evaluacion/screens/formulario_gastos.dart';
import 'package:evaluacion/screens/resumen_mensual.dart';
import 'package:evaluacion/widgets/gasto_list_item.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final List<Gasto> _gastos = [
    Gasto(
      descripcion: "Café de la mañana",
      monto: 2.50,
      categoria: Categoria.Comida,
      fecha: DateTime.now().subtract(Duration(days: 1)),
    ),
    Gasto(
      descripcion: "Pasaje de autobús",
      monto: 0.50,
      categoria: Categoria.Transporte,
      fecha: DateTime.now().subtract(Duration(days: 1)),
    ),
    Gasto(
      descripcion: "Entrada de cine",
      monto: 7.00,
      categoria: Categoria.Entretenimiento,
      fecha: DateTime.now().subtract(Duration(days: 2)),
    ),
  ];

  Categoria? _filtroCategoria;
  void _agregarGasto(Gasto gasto) {
    setState(() {
      _gastos.add(gasto);
    });
  }

  void _editarGasto(Gasto gastoActualizado) {
    setState(() {
      int index = _gastos.indexWhere((g) => g.id == gastoActualizado.id);
      if (index != -1) {
        _gastos[index] = gastoActualizado;
      }
    });
  }

  void _eliminarGasto(String id) {
    setState(() {
      _gastos.removeWhere((g) => g.id == id);
    });
  }

  void _navegarAFormulario({Gasto? gasto}) async {
    final nuevoGasto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormularioGastos(gasto: gasto)),
    );

    if (nuevoGasto != null) {
      if (gasto != null) {
        _editarGasto(nuevoGasto);
      } else {
        _agregarGasto(nuevoGasto);
      }
    }
  }

  void _navegarAResumen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResumenMensual(gastos: _gastos)),
    );
  }

  double _calcularTotalMesActual() {
    final mesActual = DateTime.now().month;
    final anoActual = DateTime.now().year;

    return _gastos
        .where((g) => g.fecha.month == mesActual && g.fecha.year == anoActual)
        .fold(0.0, (sum, g) => sum + g.monto);
  }

  List<Gasto> _getGastosFiltrados() {
    List<Gasto> gastosFiltrados = _gastos;

    if (_filtroCategoria != null) {
      gastosFiltrados = gastosFiltrados
          .where((g) => g.categoria == _filtroCategoria)
          .toList();
    }

    gastosFiltrados.sort((a, b) => b.fecha.compareTo(a.fecha));
    return gastosFiltrados;
  }

  @override
  Widget build(BuildContext context) {
    final gastosFiltrados = _getGastosFiltrados();
    final totalMes = _calcularTotalMesActual();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor de Gastos'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: _navegarAResumen,
            tooltip: 'Resumen Mensual',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildResumenYFiltros(totalMes),
          Expanded(
            child: gastosFiltrados.isEmpty
                ? Center(
                    child: Text(
                      'No hay gastos registrados.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                : ListView.builder(
                    itemCount: gastosFiltrados.length,
                    itemBuilder: (ctx, index) {
                      final gasto = gastosFiltrados[index];
                      return GastoListItem(
                        gasto: gasto,
                        onDelete: () => _eliminarGasto(gasto.id),
                        onEdit: () => _navegarAFormulario(gasto: gasto),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarAFormulario(),
        tooltip: 'Agregar Gasto',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildResumenYFiltros(double totalMes) {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '€');

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            'Total Gastado este Mes:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            formatter.format(totalMes),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<Categoria?>(
            value: _filtroCategoria,
            hint: Text('Filtrar por categoría...'),
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              DropdownMenuItem<Categoria?>(
                value: null,
                child: Text('Todas las categorías'),
              ),
              ...Categoria.values.map(
                (c) =>
                    DropdownMenuItem<Categoria?>(value: c, child: Text(c.name)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _filtroCategoria = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
