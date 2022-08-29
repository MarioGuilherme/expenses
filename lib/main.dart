import "package:flutter/material.dart";

import "dart:math";
import "Components/transaction_form.dart";
import "Components/transaction_list.dart";
import "Components/chart.dart";

import 'Models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: MyHomePage(),
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.amber,
                fontFamily: "Quicksand",
                textTheme: ThemeData.light().textTheme.copyWith(
                    titleMedium: const TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                ),
                appBarTheme: const AppBarTheme(
                    titleTextStyle: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                )
            )
        );
    }
}

class MyHomePage extends StatefulWidget {
    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final List<Transaction> _transactions = [];

    List<Transaction> get _recentTransactions => _transactions.where((transaction) => transaction.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();

    void _addTransaction(String title, double value, DateTime date) {
        final newTransaction = Transaction(
            id: Random().nextDouble().toString(),
            title: title,
            value: value,
            date: date
        );
        setState(() => _transactions.add(newTransaction));
        Navigator.of(context).pop();
    }

    void _removeTransaction(String id) => setState(() => _transactions.removeWhere((transaction) => transaction.id == id));

    void _openTransactionFormModal(BuildContext context) {
        showModalBottomSheet(
            context: context,
            builder: (_) => TransactionForm(_addTransaction)
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text("Despesas Pessoais"),
                actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _openTransactionFormModal(context)
                    )
                ]
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        Chart(_recentTransactions),
                        TransactionList(_transactions, _removeTransaction)
                    ]
                )
            ),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _openTransactionFormModal(context)
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
        );
    }
}