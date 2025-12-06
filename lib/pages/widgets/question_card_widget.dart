import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../config/questions.dart';

class QuestionCardWidget extends StatelessWidget {
  final int index;
  final String initialAnswer;
  final ValueChanged<String> onAnswerChanged; // NEW CALLBACK

  const QuestionCardWidget({
    super.key,
    required this.index,
    required this.initialAnswer,
    required this.onAnswerChanged, // NEW REQUIRED PARAMETER
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.pureWhite,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Text
              Text(
                // Use the mocked QuestionsList
                QuestionsList.questions[index],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Answer Input Field
              Expanded(
                child: TextFormField(
                  key: ValueKey('input_$index'),
                  // Use initialAnswer prop passed from parent
                  initialValue: initialAnswer,
                  onChanged: (text) {
                    // FIX: Notify the parent state via the callback
                    onAnswerChanged(text);
                  },
                  maxLines: null, // Allows multiline input
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Write your reflective thoughts here...',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primaryTeal,
                        width: 2,
                      ),
                    ),
                    fillColor: AppColors.backgroundLight,
                    filled: true,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
