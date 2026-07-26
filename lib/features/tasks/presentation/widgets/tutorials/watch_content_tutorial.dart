import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/guided_tutorial_header.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class WatchContentTutorial extends StatefulWidget {
  const WatchContentTutorial({super.key, required this.stepLabel});

  final String stepLabel;

  @override
  State<WatchContentTutorial> createState() => _WatchContentTutorialState();
}

class _WatchContentTutorialState extends State<WatchContentTutorial> {
  bool _isPlaying = false;
  double _progress = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handlePlay() {
    if (_isPlaying && _progress >= 100) {
      setState(() => _progress = 0);
    }
    setState(() => _isPlaying = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_progress >= 100) {
          timer.cancel();
          _progress = 100;
        } else {
          _progress += 10;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final done = _isPlaying && _progress >= 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GuidedTutorialHeader(
          hint:
              'Assista ao vídeo com calma. Use o botão de play para começar e '
              'ajuste o volume se precisar.',
        ),
        Padding(
          padding: EdgeInsets.all(AppDesignTokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.stepLabel,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeH4,
                  fontWeight: AppDesignTokens.fontWeightBold,
                  color: AppDesignTokens.colorContentPrimary,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingLg),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppDesignTokens.colorGray800,
                  borderRadius: BorderRadius.circular(
                    AppDesignTokens.borderRadiusDefault,
                  ),
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(
                        child: done
                            ? Icon(
                                Icons.check_circle,
                                color: AppDesignTokens.colorWhite,
                                size: 48,
                              )
                            : IconButton(
                                onPressed: _handlePlay,
                                iconSize: 56,
                                color: AppDesignTokens.colorWhite,
                                icon: const Icon(Icons.play_circle_filled),
                                tooltip: _isPlaying
                                    ? 'Reproduzindo vídeo'
                                    : 'Reproduzir vídeo de exemplo',
                              ),
                      ),
                    ),
                    if (_isPlaying)
                      LinearProgressIndicator(
                        value: _progress / 100,
                        minHeight: 6,
                        backgroundColor: AppDesignTokens.colorGray700,
                        color: AppDesignTokens.colorPrimary,
                      ),
                  ],
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                'Na atividade real, você também pode pausar e voltar com os '
                'controles do vídeo.',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  height: AppDesignTokens.lineHeightBody,
                  color: AppDesignTokens.colorContentSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
