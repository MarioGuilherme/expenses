import 'dart:math';

import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../Models/transaction.dart";

class TransactionItem extends StatefulWidget {
    final Transaction transaction;
    final void Function(String p1) onRemove;

    const TransactionItem({
        Key? key,
        required this.transaction,
        required this.onRemove,
    }) : super(key: key);

    @override
    State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
    static const List<Color> colors = [
        Colors.red,
        Colors.purple,
        Colors.orange,
        Colors.blue,
        Colors.black
    ];

    late Color _backgroundColor;

    @override
    void initState() {
        final int i = Random().nextInt(5);
        _backgroundColor = colors[i];
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5
            ),
            child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: _backgroundColor,
                    radius: 30,
                    child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text("R\$${widget.transaction.value.toStringAsFixed(2)}")
                        )
                    )
                ),
                title: Text(
                    widget.transaction.title,
                    style: Theme.of(context).textTheme.titleMedium
                ),
                subtitle: Text(
                    DateFormat("d MMM y").format(widget.transaction.date)
                ),
                trailing: MediaQuery.of(context).size.width > 480
                ? TextButton.icon(
                    onPressed: () => widget.onRemove(widget.transaction.id),
                    icon: const Icon(Icons.delete),
                    label: const Text("Excluir"),
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).errorColor
                    )
                )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => widget.onRemove(widget.transaction.id)
                )
            )
        );
    }
}