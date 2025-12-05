import 'package:flutter/material.dart';
import 'package:mindmirror_flutter/pages/widgets/question_card_widget.dart';
import '../../config/colors.dart';
import '../../config/questions.dart';
import '../widgets/helpline_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Renamed State class
}

class _HomeScreenState extends State<HomeScreen> {
  static final int _questionCount = QuestionsList.questions.length;

  final PageController _pageController = PageController();

  final Map<int, String> _answers = {};

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _questionCount; i++) {
      _answers[i] = '';
    }
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _combineAnswers() {
    return _answers.entries
        .map((e) => "${QuestionsList.questions[e.key]}: ${e.value}")
        .join('\n---\n');
  }

  void _resetState() {
    setState(() {
      _currentPage = 0;
      for (int i = 0; i < _questionCount; i++) {
        _answers[i] = '';
      }
      _pageController.jumpToPage(0);
    });
    debugPrint("App state reset. Ready for next entry.");
  }

  void _handleNext() {
    if (_currentPage < _questionCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else {
      // Logic for final submission
      final combinedText = _combineAnswers();
      debugPrint("Submission initiated. Combined Text:\n$combinedText");

      // TODO: Replace this with your actual API call.
      // Simulating API call and result: randomly returns true/false
      final isDepressed = DateTime.now().second.isEven;

      _showResultDialog(isDepressed); // Show the dynamic result dialog
    }
  }

  /// Handles navigation to the previous card.
  void _handlePrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  /// Shows the final analysis result UI (Depressed/Not Depressed).
  void _showResultDialog(bool isDepressed) {
    final resultTitle = isDepressed
        ? 'Analysis Result: Caution'
        : 'Analysis Result: Clear';
    final resultMessage = isDepressed
        ? 'The text analysis detected patterns associated with a higher risk profile. Please consider speaking with a professional or contact our helpline resources immediately.'
        : 'The text analysis indicates a low risk profile today. Continue monitoring your well-being.';
    final resultColor = isDepressed
        ? AppColors.crisisRed
        : AppColors.secondaryEmerald;
    final resultIcon = isDepressed
        ? Icons.sentiment_dissatisfied_rounded
        : Icons.sentiment_satisfied_alt_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            resultTitle,
            style: TextStyle(color: resultColor, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(resultIcon, color: resultColor, size: 60),
              const SizedBox(height: 16),
              Text(
                resultMessage,
                style: TextStyle(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetState(); // Reset state and return to Q1
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
      },
    );
  }

  void _showHelplineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HelplineDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Daily Check-in'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.pureWhite,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.phone_in_talk,
              color: AppColors.crisisRed,
              size: 28,
            ),
            tooltip: 'Access Crisis Helpline Resources',
            onPressed: _showHelplineDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${_currentPage + 1} of $_questionCount',
                  style: TextStyle(
                    color: AppColors.primaryTeal,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / _questionCount,
                  backgroundColor: AppColors.borderLight,
                  color: AppColors.primaryTeal,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // --- Sliding Question Cards (PageView) ---
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _questionCount,
              itemBuilder: (context, index) {
                return QuestionCardWidget(index: index, answers: _answers);
              },
            ),
          ),

          _buildNavigationFooter(),
        ],
      ),
    );
  }

  /// Builds the previous/next button row.
  Widget _buildNavigationFooter() {
    final bool isLastPage = _currentPage == _questionCount - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          OutlinedButton.icon(
            onPressed: _currentPage > 0 ? _handlePrevious : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Previous"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryTeal,
              side: BorderSide(color: AppColors.primaryTeal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: _handleNext,
            icon: Icon(isLastPage ? Icons.send : Icons.arrow_forward),
            label: Text(isLastPage ? "Submit & Analyze" : "Next Question"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastPage
                  ? AppColors.secondaryEmerald
                  : AppColors.primaryTeal,
              foregroundColor: AppColors.pureWhite,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}
