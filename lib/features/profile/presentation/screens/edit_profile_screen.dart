import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/shared/lib/format_phone.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';
import 'package:senior_ease/shared/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _registrationCodeController;
  late final TextEditingController _disabilityController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  DateTime? _birthDate;
  bool _isSaving = false;
  bool _initialized = false;
  String? _nameError;
  String? _birthDateError;
  String? _emailError;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _registrationCodeController.dispose();
    _disabilityController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initFromProfile(UserProfile profile) {
    if (_initialized) return;
    _initialized = true;
    final isPlaceholderName =
        profile.fullName.isEmpty || profile.fullName == 'Complete seu perfil';
    _nameController = TextEditingController(
      text: isPlaceholderName ? '' : profile.fullName,
    );
    _birthDate = profile.birthDate;
    _birthDateController = TextEditingController(
      text: _birthDate != null ? _dateFormat.format(_birthDate!) : '',
    );
    _registrationCodeController = TextEditingController(
      text: profile.registrationCode,
    );
    _disabilityController = TextEditingController(
      text: profile.disabilityDescription ?? '',
    );
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(
      text: formatPhoneMask(profile.phone),
    );
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
        _birthDateError = null;
      });
    }
  }

  bool _validate() {
    var valid = true;
    String? nameError;
    String? birthError;
    String? emailError;
    String? phoneError;

    if (_nameController.text.trim().isEmpty) {
      nameError = 'Nome completo é obrigatório';
      valid = false;
    }

    if (_birthDate == null) {
      birthError = 'Informe sua data de nascimento.';
      valid = false;
    } else {
      final now = DateTime.now();
      var age = now.year - _birthDate!.year;
      if (now.month < _birthDate!.month ||
          (now.month == _birthDate!.month && now.day < _birthDate!.day)) {
        age--;
      }
      if (age < 1 || age > 120) {
        birthError = 'Idade deve estar entre 1 e 120 anos';
        valid = false;
      }
    }

    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      emailError = 'E-mail inválido';
      valid = false;
    }

    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.isEmpty) {
      phoneError = 'Telefone é obrigatório';
      valid = false;
    } else if (phoneDigits.length < 10) {
      phoneError = 'Telefone inválido';
      valid = false;
    }

    setState(() {
      _nameError = nameError;
      _birthDateError = birthError;
      _emailError = emailError;
      _phoneError = phoneError;
    });
    return valid;
  }

  Future<void> _save(BuildContext context, UserProfile current) async {
    if (!_validate()) return;

    setState(() => _isSaving = true);
    final disabilityText = _disabilityController.text.trim();
    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      birthDate: _birthDate,
      disabilityDescription: disabilityText.isEmpty ? null : disabilityText,
      clearDisability: disabilityText.isEmpty,
      email: _emailController.text.trim(),
      phone: formatPhoneMask(_phoneController.text),
    );
    try {
      await context.read<ProfileInfoController>().save(updated);
      if (!context.mounted) return;
      await AppDialog.success(
        context,
        title: 'Salvo com sucesso!',
        description: 'Informações salvas com sucesso.',
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Erro ao salvar perfil: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível salvar suas informações. Tente novamente.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileInfoController>.value(
      value: sl<ProfileInfoController>(),
      child: Consumer<ProfileInfoController>(
        builder: (context, controller, _) {
          final profile = controller.profile;
          if (controller.isLoading || profile == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Carregando informações…',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    color: AppDesignTokens.colorContentSecondary,
                  ),
                ),
              ),
            );
          }
          _initFromProfile(profile);

          return Scaffold(
            backgroundColor: AppDesignTokens.colorGray100,
            appBar: SeniorEaseAppBar(
              onLogoTap: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false),
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
                    'Informações da conta',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeH4,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      color: AppDesignTokens.colorContentDefault,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  Text(
                    'Consulte e atualize seus dados pessoais. A idade é '
                    'calculada a partir da data de nascimento.',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      height: AppDesignTokens.lineHeightBody,
                      color: AppDesignTokens.colorContentSecondary,
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
                        hintText: 'DD/MM/AAAA',
                        helperText: _birthDateError == null
                            ? 'Digite dia, mês e ano.'
                            : null,
                        errorText: _birthDateError,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'Matrícula',
                    controller: _registrationCodeController,
                    enabled: false,
                    helperText: 'Não pode ser alterada.',
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'Possui alguma deficiência?',
                    controller: _disabilityController,
                    hintText: 'Ex.: Baixa visão',
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'E-mail',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppTextField(
                    label: 'Telefone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: '(00) 00000-0000',
                    helperText: _phoneError == null
                        ? 'Digite apenas os números.'
                        : null,
                    errorText: _phoneError,
                    onChanged: (value) {
                      final masked = formatPhoneMask(value);
                      if (masked != value) {
                        _phoneController.value = TextEditingValue(
                          text: masked,
                          selection: TextSelection.collapsed(
                            offset: masked.length,
                          ),
                        );
                      }
                      if (_phoneError != null) {
                        setState(() => _phoneError = null);
                      }
                    },
                  ),
                  SizedBox(height: AppDesignTokens.spacingXl),
                  AppButton(
                    label: 'Não, manter como está',
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    variant: ButtonVariant.outlined,
                    leadingIcon: const Icon(Icons.close),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppButton(
                    label: _isSaving ? 'Salvando…' : 'Salvar informações',
                    loading: _isSaving,
                    onPressed: _isSaving
                        ? null
                        : () => _save(context, profile),
                    variant: ButtonVariant.primary,
                    leadingIcon: const Icon(Icons.save_outlined),
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
