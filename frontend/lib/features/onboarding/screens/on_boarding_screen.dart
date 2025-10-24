import 'package:flutter/material.dart';
import 'package:frontend/features/auth/screens/sign_in_screen.dart';
import 'package:frontend/common/gradient_button.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/onboarding_page1.dart';
import '../widgets/onboarding_page2.dart';
import '../widgets/onboarding_page3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation bar
            _buildTopNavigation(),
            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: const [
                  OnboardingPage2(),
                  OnboardingPage3(),
                  OnboardingPage1(),
                ],
              ),
            ),
            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back arrow
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: _currentPage > 0 ? AppColors.textPrimary : AppColors.grey,
            ),
            onPressed: _currentPage > 0
                ? () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
                : null,
          ),
          // Smooth Page Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.greyLight,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 8,
            ),
          ),
          // Forward arrow
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: _currentPage < 2 ? AppColors.textPrimary : AppColors.grey,
            ),
            onPressed: _currentPage < 2 ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          if (_currentPage < 2)
            Expanded(
              child: OutlinedButton(
                onPressed: _skipToEnd,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          if (_currentPage < 2) const SizedBox(width: 12),
          Expanded(
            child: GradientButton(
              text: _currentPage == 2 ? 'Get Started' : 'Next',
              onPressed: _nextPage,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
