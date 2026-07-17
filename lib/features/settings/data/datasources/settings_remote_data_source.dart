import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';

abstract class SettingsRemoteDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid);

  @override
  Future<AppSettings> getSettings() async {
    final doc = await _userDoc.get();
    final preferences = doc.data()?['preferences'] as Map<String, dynamic>?;
    if (preferences == null) return AppSettings.defaults();

    return AppSettings(
      fontSize: _labelFromIndex(
        AppSettings.fontSizeOptions,
        preferences['fontSize'] as num?,
      ),
      contrastLevel: _labelFromIndex(
        AppSettings.contrastLevelOptions,
        preferences['contrast'] as num?,
      ),
      navigationMode: preferences['interfaceMode'] == 'simple'
          ? 'Simples'
          : 'Avançado',
      spacing: _labelFromIndex(
        AppSettings.spacingOptions,
        preferences['spacing'] as num?,
      ),
      enhancedVisualFeedback:
          preferences['reinforcedVisualFeedback'] as bool? ?? false,
      criticalActionConfirmation:
          preferences['confirmCriticalActions'] as bool? ?? true,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _userDoc.set({
      'preferences': {
        'fontSize': _indexFromLabel(
          AppSettings.fontSizeOptions,
          settings.fontSize,
        ),
        'contrast': _indexFromLabel(
          AppSettings.contrastLevelOptions,
          settings.contrastLevel,
        ),
        'interfaceMode': settings.navigationMode == 'Simples'
            ? 'simple'
            : 'standard',
        'spacing': _indexFromLabel(
          AppSettings.spacingOptions,
          settings.spacing,
        ),
        'reinforcedVisualFeedback': settings.enhancedVisualFeedback,
        'confirmCriticalActions': settings.criticalActionConfirmation,
      },
    }, SetOptions(merge: true));
  }

  String _labelFromIndex(List<String> options, num? index) {
    final position = (index?.toInt() ?? 1) - 1;
    if (position < 0 || position >= options.length) return options.first;
    return options[position];
  }

  int _indexFromLabel(List<String> options, String label) {
    final position = options.indexOf(label);
    return position == -1 ? 1 : position + 1;
  }
}
