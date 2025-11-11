import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:evaluacion/models/gastos.dart';

class FormularioGastos extends StatefulWidget {
  final Gasto? gasto;

  const FormularioGastos({super.key, this.gasto});

  @override
  _FormularioGastosState createState() => _FormularioGastosState();
}

class _FormularioGastosState extends State<FormularioGastos> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  late TextEditingController _montoController;
  Categoria _categoriaSeleccionada = Categoria.Comida;
  DateTime _fechaSeleccionada = DateTime.now();

  bool get _modoEdicion => widget.gasto != null;
  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(
      text: widget.gasto?.descripcion,
    );
    _montoController = TextEditingController(
      text: widget.gasto?.monto.toString(),
    );
    _categoriaSeleccionada = widget.gasto?.categoria ?? Categoria.Comida;
    _fechaSeleccionada = widget.gasto?.fecha ?? DateTime.now();
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      final nuevoGasto = Gasto(
        id: widget.gasto?.id,
        descripcion: _descripcionController.text,
        monto: double.parse(_montoController.text),
        categoria: _categoriaSeleccionada,
        fecha: _fechaSeleccionada,
      );
      Navigator.of(context).pop(nuevoGasto);
    }
  }

  Future<void> _presentarDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (pickedDate != null && pickedDate != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicion ? 'Editar Gasto' : 'Agregar Gasto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // [cite: 51]
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    prefixText: '€ ',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un monto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un número válido';
                    }
                    if (double.parse(value) <= 0) {
                      return 'El monto debe ser mayor a cero';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Categoria>(
                  value: _categoriaSeleccionada,
                  decoration: InputDecoration(labelText: 'Categoría'),
                  items: Categoria.values.map((Categoria categoria) {
                    return DropdownMenuItem<Categoria>(
                      value: categoria,
                      child: Text(categoria.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _categoriaSeleccionada = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fecha: ${DateFormat.yMd('es_ES').format(_fechaSeleccionada)}',
                    ),
                    TextButton(
                      onPressed: _presentarDatePicker,
                      child: Text('Seleccionar Fecha'),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _guardarFormulario,
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
