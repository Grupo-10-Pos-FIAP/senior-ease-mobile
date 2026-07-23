import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_text_field.dart';

/// Edit form for the fields "Minhas informações" can show as missing —
/// pre-filled with whatever is already saved. Email and matrícula aren't
/// editable here: email changes need Firebase Auth re-verification, and
/// matrícula is just the account's own uid, not user data.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _disabilityController;
  late final TextEditingController _phoneController;
  DateTime? _birthDate;
  bool _isSaving = false;
  bool _initialized = false;
  String? _nameError;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _disabilityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initFromProfile(UserProfile profile) {
    if (_initialized) return;
    _initialized = true;
    // Covers both the current seed (empty string) and the older placeholder
    // text some existing accounts still carry from before that changed.
    final isPlaceholderName =
        profile.fullName.isEmpty || profile.fullName == 'Complete seu perfil';
    _nameController = TextEditingController(
      text: isPlaceholderName ? '' : profile.fullName,
    );
    _birthDate = profile.birthDate;
    _birthDateController = TextEditingController(
      text: _birthDate != null ? _dateFormat.format(_birthDate!) : '',
    );
    _disabilityController = TextEditingController(
      text: profile.disabilityDescription ?? '',
    );
    _phoneController = TextEditingController(text: profile.phone);
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 60),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _save(BuildContext context, UserProfile current) async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Nome completo é obrigatório.');
      return;
    }
    setState(() {
      _nameError = null;
      _isSaving = true;
    });
    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      birthDate: _birthDate,
      disabilityDescription: _disabilityController.text.trim().isEmpty
          ? null
          : _disabilityController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    try {
      // Must be the Consumer builder's context (below the ChangeNotifierProvider
      // created in this same build() call) — `this.context` (the State's own
      // element) sits ABOVE that provider, so context.read from it never finds it.
      await context.read<ProfileInfoController>().save(updated);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      // Without this, any failure here (e.g. a Firestore write rejected by
      // security rules) left the button stuck spinning forever with no
      // indication anything went wrong — indistinguishable from "not
      // saving" from the user's side.
      debugPrint('Erro ao salvar perfil: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // A separate route, not nested under ProfileShellScreen's own
    // MultiProvider — provide the (GetIt-shared) controller here too, or
    // Consumer below finds no ancestor Provider<ProfileInfoController>.
    return ChangeNotifierProvider<ProfileInfoController>.value(
      value: sl<ProfileInfoController>(),
      child: Consumer<ProfileInfoController>(
        builder: (context, controller, _) {
          final profile = controller.profile;
          if (controller.isLoading || profile == null) {
            return const Scaffold(body: SizedBox.shrink());
          }
          _initFromProfile(profile);

          return Scaffold(
            backgroundColor: AppDesignTokens.colorGray100,
            appBar: SeniorEaseAppBar(
              onProfileTap: () =>
                  Navigator.of(context).pushNamed(RouteNames.profile),
              onLogoutTap: () => confirmAndSignOut(context),
            ),
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  Text(
                    'Editar informações',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeH4,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      color: AppDesignTokens.colorContentDefault,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingXl),
                  AppTextField(
                    label: 'Nome completo',
                    controller: _nameController,
                    errorText: _nameError,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  GestureDetector(
                    onTap: _pickBirthDate,
                    child: AbsorbPointer(
                      child: AppTextField(
                        label: 'Data de nascimento',
                        controller: _birthDateController,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'Possui alguma deficiência? (opcional)',
                    controller: _disabilityController,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'Telefone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: AppDesignTokens.spacingXl),
                  AppButton(
                    label: 'Salvar informações',
                    loading: _isSaving,
                    onPressed: _isSaving ? null : () => _save(context, profile),
                    variant: ButtonVariant.primary,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppButton(
                    label: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                    variant: ButtonVariant.outlined,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
