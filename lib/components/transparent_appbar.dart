import 'package:flutter/material.dart';
import 'package:nusantara_recipe/comments.dart';

class TransparentAppbar extends StatelessWidget {
  final double opacityColor;
  final Color buttonColor;

  const TransparentAppbar({super.key, this.opacityColor = 0.2, this.buttonColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(opacityColor),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: buttonColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: (){Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CommentsRecipe())
            );
            }, icon: const Icon(Icons.chat)
          ),
        )
      ],
      centerTitle: true,
    );
  }
}
