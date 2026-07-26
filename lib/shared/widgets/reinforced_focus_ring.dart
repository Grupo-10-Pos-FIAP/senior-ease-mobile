import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

/// Wraps a focusable/pressable widget with a black outline offset by 1px
/// from the component, shown only while focused or pressed — the visual
/// half of "Feedback visual reforçado". [builder] must attach the given
/// [FocusNode] to the wrapped widget (via its `focusNode` parameter) so
/// this ring knows when it's focused.
///
/// Deliberately avoids sharing a [WidgetStatesController] with the child:
/// Flutter's own button widgets write to that controller synchronously
/// while mounting, and reacting to that with `setState` here would try to
/// rebuild this element while it's still building, triggering a
/// "setState called during build" (`!_dirty`) crash. `FocusNode` and
/// pointer events only fire from real user interaction, after the current
/// build has finished, so they don't have that hazard.
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
