import "package:flutter/material.dart";
import "../Models/transaction.dart";
import "./transaction_item.dart";

class TransactionList extends StatelessWidget {
    final List<Transaction> transactions;
    final void Function(String) onRemove;

    TransactionList(this.transactions, this.onRemove);

    @override
    Widget build(BuildContext context) {
        return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => Column(
                children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                        "Nenhuma Transação Cadastrada!",
                        style: Theme.of(context).textTheme.titleMedium
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: constraints.maxHeight * .6,
                        child: Image.asset(
                            "assets/images/waiting.png",
                            fit: BoxFit.cover
                        )
                    )
                ]
            )
        )
        :
        ListView(
            children: transactions.map((transaction) =>
                TransactionItem(
                key: ValueKey(transaction.id),
                transaction: transaction,
                onRemove: onRemove
                )
            ).toList()
        );
    }
}