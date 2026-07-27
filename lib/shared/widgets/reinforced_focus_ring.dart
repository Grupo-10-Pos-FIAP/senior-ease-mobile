import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class ReinforcedFocusRing extends StatefulWidget {
  const ReinforcedFocusRing({
    super.key,
    required this.enabled,
    required this.borderRadius,
    required this.builder,
  });

  final bool enabled;
  final BorderRadius borderRadius;
  final Widget Function(BuildContext context, FocusNode focusNode) builder;

  @override
  State<ReinforcedFocusRing> createState() => _ReinforcedFocusRingState();
}

class _ReinforcedFocusRingState extends State<ReinforcedFocusRing> {
  final _focusNode = FocusNode();
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _focusNode);
    if (!widget.enabled) return child;

    final highlighted = _focusNode.hasFocus || _pressed;
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: highlighted
              ? Border.all(
                  color: AppDesignTokens.colorBlack,
                  width: AppDesignTokens.borderWidthDefault,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
