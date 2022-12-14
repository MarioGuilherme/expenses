import "package:intl/intl.dart";
import "package:flutter/material.dart";

import '../Models/transaction.dart';
import "../Components/chart_bar.dart";

class Chart extends StatelessWidget {
    Chart(this.recentTransactions);

    final List<Transaction> recentTransactions;

    List<Map<String, Object>> get groupedTransactions {
        return List.generate(7, (index) {
            final weekDay = DateTime.now().subtract(Duration(days: index));

            double totalSum = 0;

            for (int i = 0; i < recentTransactions.length; i++) {
                bool sameDay = recentTransactions[i].date.day == weekDay.day;
                bool sameMonth = recentTransactions[i].date.month == weekDay.month;
                bool sameYear = recentTransactions[i].date.year == weekDay.year;

                if (sameDay && sameMonth && sameYear)
                    totalSum += recentTransactions[i].value;
            }

            return {
                "day": DateFormat.E().format(weekDay)[0],
                "value": totalSum
            };
        }).reversed.toList();
    }

    double get _weekTotalValue => groupedTransactions.fold(0, (sum, transaction) => sum + (transaction["value"] as double));

    @override
    Widget build(BuildContext context) {
        groupedTransactions;
        return Card(
            elevation: 6,
            margin: const EdgeInsets.all(20),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: groupedTransactions.map((transaction) {
                        return Flexible(
                            fit: FlexFit.tight,
                            child: ChartBar(
                                label: transaction["day"].toString(),
                                value: (transaction["value"] as double),
                                percentage: _weekTotalValue == 0 ? 0 : (transaction["value"] as double) / _weekTotalValue
                            )
                        );
                    }).toList()
                )
            )
        );
    }
}