import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import "dart:math";
import "Components/transaction_form.dart";
import "Components/transaction_list.dart";
import "Components/chart.dart";

import "Models/transaction.dart";

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
    bool _showChart = false;

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

    Widget _getIconButton(IconData icon, Function function) {
        return Platform.isIOS ?
        GestureDetector(onTap: () => function, child: Icon(icon)) :
        IconButton(icon: Icon(icon), onPressed: () => function);
    }

    @override
    Widget build(BuildContext context) {
        final MediaQueryData mediaQuery = MediaQuery.of(context);
        bool isLandscape = mediaQuery.orientation == Orientation.landscape;

        final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
        final chartIcon = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

        final List<Widget> actions = <Widget>[
            if (isLandscape)
                _getIconButton(
                    _showChart ? iconList : chartIcon,
                    () => setState(() => _showChart = !_showChart)
                ),
            _getIconButton(
                Platform.isIOS ? CupertinoIcons.add : Icons.add,
                () => _openTransactionFormModal(context)
            )
        ];

        final AppBar appBar = AppBar(
            title: const Text("Despesas Pessoais"),
            actions: <Widget>[
                if (isLandscape)
                    IconButton(
                        icon: Icon(_showChart ? Icons.list : Icons.show_chart),
                        onPressed: () => setState(() => _showChart = !_showChart)
                    ),
                IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context)
                )
            ]
        );

        final double availableHeigth = mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
        final SafeArea bodyPage = SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        if (_showChart || !isLandscape)
                            Container(
                                height: availableHeigth * (isLandscape ? .7 : .3),
                                child: Chart(_recentTransactions)
                            ),
                        if (!_showChart || !isLandscape)
                            Container(
                                height: availableHeigth * (isLandscape ? 1 : .7),
                                child: TransactionList(_transactions, _removeTransaction
                            ))
                    ]
                )
            )
        );

        return Platform.isIOS
            ? CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    middle: const Text("Despesas Pessoais"),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions
                    )
                ),
                child: bodyPage
            )
            : Scaffold(
                appBar: appBar,
                body: bodyPage,
                floatingActionButton: Platform.isIOS ?
                Container() :
                FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context)
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
            );
    }
}