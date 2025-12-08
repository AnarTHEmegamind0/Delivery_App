import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/constants.dart';
import '../core/main_navigation.dart';
import '../core/utils.dart';
import '../core/design_system/components/app_button.dart';
import '../core/design_system/components/app_input.dart';
import '../core/design_system/tokens/colors.dart';
import '../core/design_system/tokens/typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSendCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color is handled by Theme (AppTheme.darkTheme/lightTheme)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // App Title
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingS),
              
              // Driver Label
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: Text(
                    AppConstants.driverApp,
                    style: AppTypography.button.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Phone Input Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Phone Number Field
                    AppInput(
                      controller: _phoneController,
                      hintText: AppConstants.phoneNumberHint,
                      keyboardType: TextInputType.phone,
                      prefixText: '+976  ',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Утасны дугаараа оруулна уу';
                        }
                        if (!AppUtils.isValidPhoneNumber(value)) {
                          return 'Зөв утасны дугаар оруулна уу';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Send Code Button
                    AppButton(
                      label: AppConstants.sendCode,
                      onPressed: _handleSendCode,
                      isLoading: _isLoading,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Helper Text
                    Text(
                      AppConstants.enterCode,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
    );
  }
}
