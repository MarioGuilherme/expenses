import "dart:io";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class AdaptativeButton extends StatelessWidget {
    final String label;
    final VoidCallback onPressed;

    const AdaptativeButton({Key? key, 
        required this.label,
        required this.onPressed
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Platform.isIOS ?
        CupertinoButton(
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
            child: Text(label),
            padding: const EdgeInsets.symmetric(
                horizontal: 20
            ),
        ) :
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).textTheme.button?.color
                )
            ),
            onPressed: onPressed,
            child: Text(label)
        );
    }
}