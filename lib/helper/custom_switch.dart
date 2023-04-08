import 'package:flutter/material.dart';

import 'colors.dart';

class StyledSwitch extends StatefulWidget {
  final void Function() onToggled;
  final bool isSelect;

  const StyledSwitch({Key? key, required this.onToggled, this.isSelect = true}) : super(key: key);

  @override
  State<StyledSwitch> createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  // bool isToggled = false;
  double size = 25;
  double innerPadding = 0;

  @override
  void initState() {
    innerPadding = size / 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onToggled();
      },
      child: AnimatedContainer(
        height: 25,
        width: 50,
        padding: EdgeInsets.all(innerPadding),
        alignment: widget.isSelect ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: widget.isSelect ? Colors.orange.shade50 : Colors.grey.shade300,
        ),
        child: Container(
          width: size - innerPadding * 2,
          height: size - innerPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: widget.isSelect ? AppColors.orange : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
