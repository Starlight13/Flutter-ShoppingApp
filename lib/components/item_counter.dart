import 'package:flutter/material.dart';
import 'package:shopping_app/components/buttons/square_button.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    required this.onChange,
    this.initialCount,
    this.size = 30.0,
    Key? key,
  }) : super(key: key);

  final int? initialCount;
  final Function(int) onChange;
  final double size;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter>
    with SingleTickerProviderStateMixin {
  late int qty;
  bool isPlus = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _plusOffsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.5, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ),
  );

  late final Animation<Offset> _minusOffsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.5, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
        setState(() {});
      }
    });

    qty = widget.initialCount ?? 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareButton(
          buttonSize: widget.size,
          onPressed: () {
            if (qty - 1 >= 1) {
              setState(() {
                isPlus = false;
              });
              _controller.forward();
              widget.onChange(--qty);
            }
          },
          buttonColor: Colors.white,
          child: const Icon(
            Icons.remove,
            color: Colors.teal,
          ),
        ),
        SlideTransition(
          position: isPlus ? _plusOffsetAnimation : _minusOffsetAnimation,
          child: SizedBox(
            width: widget.size + 10.0,
            child: Text(
              '$qty',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
        ),
        SquareButton(
          buttonSize: widget.size,
          onPressed: () {
            setState(() {
              isPlus = true;
            });
            _controller.forward();
            widget.onChange(++qty);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
