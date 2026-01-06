import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindmirror_flutter/api/api_base.dart';
import 'package:mindmirror_flutter/api/endpoint.dart';
import 'package:mindmirror_flutter/pages/widgets/question_card_widget.dart';
import '../../config/colors.dart';
import '../../config/questions.dart';
import '../widgets/analysis_dialog.dart';
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

  bool _isLoading = false;
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
    return _answers.values.join();
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

  bool _validateAnswers() {
    return _answers.values.any((answer) => answer.trim().isNotEmpty);
  }

  void _handleNext() async {
    // MARKED ASYNC
    if (_currentPage < _questionCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else {
      // 1. VALIDATION CHECK
      if (!_validateAnswers()) {
        // Show SnackBar for validation failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Please reflect and provide input for at least one question.",
              style: TextStyle(color: AppColors.pureWhite),
            ),
            backgroundColor: AppColors.primaryTeal,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return; // Stop execution
      }

      final combinedText = _combineAnswers();
      log(
        "Submission initiated. Combined Text length: ${combinedText.length}",
        name: 'SUBMISSION',
      );

      // 2. API CALL WITH ERROR HANDLING
      setState(() {
        _isLoading = true;
      });
      try {
        var result = await ApiBase.postRequest(
          data: {"text": combinedText},
          path: Endpoint().predictUrl,
        );

        // Assume result.data is the Map<String, dynamic> response from the API wrapper
        final Map<String, dynamic> apiResponse =
            result.data as Map<String, dynamic>;

        log("API Response Data: $apiResponse", name: 'API_CALL');

        // 3. SHOW DIALOG
        setState(() {
          _isLoading = false;
        });
        _showResultDialog(apiResponse);
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        log('API Error: $e', name: 'API_CALL_ERROR');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to analyze entry. Please check your connection.',
              style: TextStyle(color: AppColors.pureWhite),
            ),
            backgroundColor: AppColors.crisisRed,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
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

  void _showResultDialog(Map<String, dynamic> apiResponse) {
    // Extract new data from the simulated API response
    final bool isDepressed = apiResponse['is_depressed'] as bool;
    final String resultClassification = apiResponse['result'] as String;
    final String confidenceScore = apiResponse['confidence'] as String;

    final resultColor = isDepressed
        ? AppColors.crisisRed
        : AppColors.secondaryEmerald;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnalysisResultDialog(
          isDepressed: isDepressed,
          resultClassification: resultClassification,
          confidenceScore: confidenceScore,
          resultColor: resultColor,
          onDone: _resetState, // Pass the _resetState method as the callback
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

      body: Stack(
        children: [
          Column(
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

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _questionCount,
                  itemBuilder: (context, index) {
                    return QuestionCardWidget(
                      index: index,
                      initialAnswer: _answers[index]!,
                      onAnswerChanged: (newText) {
                        // This is the callback that updates the parent's state
                        setState(() {
                          _answers[index] = newText;
                        });
                      },
                    );
                  },
                ),
              ),

              _buildNavigationFooter(),
            ],
          ),
          _isLoading
              ? Container(
                  color: const Color.fromARGB(105, 43, 39, 39),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.secondaryEmerald,
                      color: AppColors.lightTeal,
                    ),
                  ),
                )
              : Container(),
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
