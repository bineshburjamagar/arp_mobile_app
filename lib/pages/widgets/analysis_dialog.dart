import 'package:flutter/material.dart';

import '../../config/colors.dart';

class AnalysisResultDialog extends StatelessWidget {
  final bool isDepressed;
  final String resultClassification;
  final String confidenceScore;
  final Color resultColor;
  final VoidCallback onDone;

  const AnalysisResultDialog({
    super.key,
    required this.isDepressed,
    required this.resultClassification,
    required this.confidenceScore,
    required this.resultColor,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final resultTitle = isDepressed
        ? 'Analysis Result: Needs Attention'
        : 'Analysis Result: Clear';
    final resultMessage = isDepressed
        ? 'The text analysis detected patterns associated with a higher risk profile. Please consider speaking with a professional or contact our helpline resources immediately.'
        : 'The text analysis indicates a low risk profile today. Continue monitoring your well-being.';
    final resultIcon = isDepressed
        ? Icons.sentiment_dissatisfied_rounded
        : Icons.sentiment_satisfied_alt_rounded;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      title: Text(
        resultTitle,
        style: TextStyle(color: resultColor, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Icon and Classification
          Icon(resultIcon, color: resultColor, size: 70),
          const SizedBox(height: 8),
          Text(
            resultClassification,
            style: TextStyle(
              color: resultColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),

          // 2. Confidence Score Chip
          Chip(
            label: Text(
              'Confidence: $confidenceScore',
              style: TextStyle(color: AppColors.pureWhite),
            ),
            backgroundColor: resultColor.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          const SizedBox(height: 20),

          // 3. Main Message
          Text(
            resultMessage,
            style: TextStyle(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDone(); // Call the reset callback
          },
          child: Text(
            'Done',
            style: TextStyle(
              color: AppColors.primaryTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
