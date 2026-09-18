import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumericPad({super.key, required this.onNumberSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildRow(context, [1, 2, 3]),
          buildRow(context, [4, 5, 6]),
          buildRow(context, [7, 8, 9]),
          buildRow(context, [-2, 0, -1]), // -2 = empty space, -1 = backspace
        ],
      ),
    );
  }

  Widget buildRow(BuildContext context, List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) {
        if (number == -2) return buildEmptySpace();
        if (number == -1) return buildBackspace();
        return buildNumber(number);
      }).toList(),
    );
  }

  Widget buildNumber(int number) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick(); // Add light vibration feedback
          onNumberSelected(number);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(6),
          height: 53,
          width: 65,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspace() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onNumberSelected(-1);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(6),
          height: 53,
          width: 65,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFff6a00), Color(0xFFee0979)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 4),
              )
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.backspace,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptySpace() {
    return const Expanded(
      child: SizedBox(height: 65, width: 65),
    );
  }
}
