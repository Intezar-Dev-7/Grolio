// features/phone_auth/presentation/pages/otp_verification_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/phone_auth_bloc.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    setState(() {
      _remainingSeconds = 60;
    });
    _startTimer();
    context.read<PhoneAuthBloc>().add(
      PhoneAuthOtpRequested(
        phoneNumber: widget.phoneNumber,
        countryCode: widget.countryCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthBloc, PhoneAuthState>(
      listener: (context, state) {
        if (state.status == PhoneAuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false,);
        } else if (state.status == PhoneAuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Invalid OTP'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          // ✅ ADD SingleChildScrollView
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  'Verify your number',
                  style: AppTypography.displaySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                RichText(
                  text: TextSpan(
                    text: 'We sent a code to ',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: '${widget.countryCode} ${widget.phoneNumber}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ✅ UPDATED: OTP Input with proper colors
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 56,
                    fieldWidth: 48,
                    // ✅ Background colors
                    activeFillColor: AppColors.surfaceDark,
                    inactiveFillColor: AppColors.surfaceDark,
                    selectedFillColor: AppColors.surfaceDark,
                    // ✅ Border colors
                    activeColor: AppColors.primaryGreen,
                    inactiveColor: AppColors.borderColor,
                    selectedColor: AppColors.primaryGreen,
                    // ✅ Border width
                    activeBorderWidth: 2,
                    inactiveBorderWidth: 1,
                    selectedBorderWidth: 2,
                  ),
                  cursorColor: AppColors.primaryGreen,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // ✅ Text color
                  textStyle: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.transparent, // ✅ Important!
                  onCompleted: (code) {
                    context.read<PhoneAuthBloc>().add(
                      PhoneAuthOtpVerified(code),
                    );
                  },
                  onChanged: (value) {},
                ),

                const SizedBox(height: 32),

                // Resend OTP
                Center(
                  child: _remainingSeconds > 0
                      ? Text(
                    'Resend code in $_remainingSeconds seconds',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  )
                      : TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      'Resend OTP',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Verify Button
                BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.status == PhoneAuthStatus.verifyingOtp
                            ? null
                            : () {
                          if (_otpController.text.length == 6) {
                            context.read<PhoneAuthBloc>().add(
                              PhoneAuthOtpVerified(_otpController.text),
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
                        child: state.status == PhoneAuthStatus.verifyingOtp
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
                          'Verify',
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
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
