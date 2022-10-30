import 'package:expenses/Components/adaptative_datepicker.dart';
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "adaptative_button.dart";
import "adaptative_textfield.dart";
import "adaptative_datepicker.dart";

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

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: Card(
                elevation: 5,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        right: 10,
                        left: 10,
                        bottom: 10 + MediaQuery.of(context).viewInsets.bottom
                    ),
                    child: Column(
                        children: <Widget>[
                            AdaptativeTextField(
                                label: "Título",
                                controller: _titleController,
                                onSubmitted: (_) => _submitForm()
                            ),
                            AdaptativeTextField( 
                                label: "Valor (R\$)",
                                controller: _valueController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onSubmitted: (_) => _submitForm()
                            ),
                            AdaptativeDatePicker(
                                selectedDate: _selectedDate,
                                onDateChanged: (newDate) => setState(() => _selectedDate = newDate)
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    AdaptativeButton(
                                        label: "Nova transação",
                                        onPressed: _submitForm
                                    )
                                ]
                            )
                        ]
                    )
                )
          )
        );
    }
}