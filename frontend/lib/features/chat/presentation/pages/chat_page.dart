// features/chat/presentation/pages/chat_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Text(
          'Chat Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
