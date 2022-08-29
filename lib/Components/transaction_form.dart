import "package:flutter/material.dart";
import "package:intl/intl.dart";

class TransactionForm extends StatefulWidget {
    final void Function(String, double, DateTime) onSubmit;

    TransactionForm(this.onSubmit);

    @override
    State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _valueController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    void _submitForm() {
        final String title = _titleController.text;
        final double value = double.tryParse(_valueController.text) ?? 0;

        if (title.isEmpty || value <= 0)
            return;

        widget.onSubmit(title, value, _selectedDate);
    }

    _showDatePicker() {
        showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now()
        ).then((pickedDate) {
            if (pickedDate == null)
                return;

            setState(() => _selectedDate = pickedDate);
        });
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 5,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    children: <Widget>[
                        TextField(
                            controller: _titleController,
                            onSubmitted: (_) => _submitForm(),
                            decoration: const InputDecoration(
                                labelText: "Título"
                            )
                        ),
                        TextField(
                            controller: _valueController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onSubmitted: (_) => _submitForm(),
                            decoration: const InputDecoration(
                                labelText: "Valor (R\$)"
                            )
                        ),
                        SizedBox(
                            height: 70,
                            child: Row(
                                children: <Widget>[
                                    Expanded(
                                        child: Text(
                                            "Data selecionada: ${DateFormat("dd/MM/y").format(_selectedDate)}"
                                        )
                                    ),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Theme.of(context).primaryColor
                                        ),
                                        onPressed: _showDatePicker,
                                        child: const Text(
                                            "Selecionar Data",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                    )
                                ]
                            )
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                                ElevatedButton (
                                    style: TextButton.styleFrom(
                                        primary: Colors.white,
                                        backgroundColor: Theme.of(context).primaryColor
                                    ),
                                    onPressed: _submitForm,
                                    child: const Text("Nova transação")
                                )
                            ]
                        )
                    ]
                )
            )
        );
    }
}