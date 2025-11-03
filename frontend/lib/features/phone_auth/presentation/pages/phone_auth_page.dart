// features/phone_auth/presentation/pages/phone_auth_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/phone_auth_bloc.dart';
import '../widgets/country_code_selector.dart';
import '../widgets/social_login_buttons.dart';
import 'otp_verification_page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state.status == PhoneAuthStatus.otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OtpVerificationPage(
                    phoneNumber: _phoneController.text,
                    countryCode: _selectedCountryCode,
                  ),
            ),
          );
        } else if (state.status == PhoneAuthStatus.authenticated) {
          if (state.status == PhoneAuthStatus.otpSent) {
            Navigator.pushNamed(
              context,
              AppRouter.otpVerification,
              arguments: {
                'phoneNumber': _phoneController.text,
                'countryCode': _selectedCountryCode,
              },
            );
          }
        } else if (state.status == PhoneAuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          // ✅ ADD SingleChildScrollView
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppColors.logoGradient,
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                Text(
                  'Grolio',
                  style: AppTypography.displaySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Code. Grow. Connect.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 48),

                // Phone Number Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Phone number',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Phone Input
                Row(
                  children: [
                    // Country Code Selector
                    CountryCodeSelector(
                      selectedCode: _selectedCountryCode,
                      onCodeSelected: (code) {
                        setState(() {
                          _selectedCountryCode = code;
                        });
                      },
                    ),

                    const SizedBox(width: 12),

                    // Phone Number Input
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTypography.bodyLarge.copyWith(
                            letterSpacing: 1,
                          ),
                          decoration: InputDecoration(
                            hintText: '9874563215',
                            hintStyle: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textTertiary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Continue Button
                BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.status == PhoneAuthStatus.sendingOtp
                            ? null
                            : () {
                          if (_phoneController.text.length >= 10) {
                            context.read<PhoneAuthBloc>().add(
                              PhoneAuthOtpRequested(
                                phoneNumber: _phoneController.text,
                                countryCode: _selectedCountryCode,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state.status == PhoneAuthStatus.sendingOtp
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                            : Text(
                          'Continue',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.borderColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or continue with',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.borderColor)),
                  ],
                ),

                const SizedBox(height: 24),

                // Social Login Buttons
                const SocialLoginButtons(),

                const SizedBox(height: 40),

                // Terms and Privacy
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
