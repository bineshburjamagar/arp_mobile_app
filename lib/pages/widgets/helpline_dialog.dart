import 'package:flutter/material.dart';

import '../../config/colors.dart';

class HelplineDialog extends StatelessWidget {
  const HelplineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.phone_in_talk, color: AppColors.crisisRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Crisis & Helpline Resources',
              style: TextStyle(
                color: AppColors.crisisRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'If you are in a crisis or feel unsafe, please reach out immediately. This app is not a substitute for emergency services.',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          const Text(
            'Emergency Services (Local)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Dial 911 (US/Canada) or your local emergency number.',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crisis Hotline (e.g., US)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'Dial 988 (Suicide & Crisis Lifeline)',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'For UK: Call 111 or Samaritans (116 123).',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Close',
            style: TextStyle(color: AppColors.primaryTeal),
          ),
        ),
      ],
    );
  }
}
