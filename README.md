MindMirror - Mobile App

MindMirror is a cross-platform mobile application built with Flutter designed to screen for linguistic markers of depression in user-generated text. It serves as the frontend client for the "Depression Detection via NLP" research project.

📱 Features

Interactive Interface: A paginated questionnaire (PageView) for collecting detailed user input across 5 prompts.

Real-Time Analysis: Sends user text to a local Django API backend for instant NLP inference.

Clear Results: Displays a preliminary screening result ("Depressed" or "Non-Depressive") along with a probabilistic "Confidence Score".

Privacy-First: Implements persistent state management (Sqflite) for informed consent/disclaimer acknowledgement, but stores NO personal analysis data.

Support Resources: Integrated helpline resources page for immediate assistance.

🛠️ Tech Stack

Framework: Flutter (Dart)

State Management: setState (Local)

Local Storage: sqflite (For disclaimer status)

Networking: dio package

UI Components: smooth_page_indicator, Material 3 Design

📸 Screenshots

Disclaimer Screen
<img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/2397b09a-e299-4b91-9264-860ad6122a33" />

Questionnaire
<img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/dc9c4fab-1265-4545-942e-321baee521e6" />

Analysis Result
<img width="940" height="529" alt="image" src="https://github.com/user-attachments/assets/70bef311-87d3-4cbb-9801-6409f3126975" />


🚀 Getting Started

Prerequisites

Flutter SDK installed on your machine.

A connected Android Emulator or Physical Device.

The MindMirror Backend (Django) running locally (https://github.com/bineshburjamagar/arpbackend).

Installation

Clone the repository:

git clone https://github.com/bineshburjamagar/arp_mobile_app.git
cd mindmirror-flutter


Install dependencies:

flutter pub get


Configure API Endpoint:

Open lib/main.dart.

Locate the apiUrl variable.

Update the IP address to match your computer's local IP address (required for Android emulators to see your localhost).

// Example for Android Emulator
final String apiUrl = "[http://192.168.1.](http://192.168.1.)X:8000/analyze/";


Run the App:

flutter run


⚠️ Important Note on Backend

This Flutter app requires the accompanying Django REST API to be running to perform any analysis. The app sends HTTP POST requests to the configured endpoint and expects a JSON response containing the prediction and confidence score.

📄 License

This project was developed for academic research purposes at York St John University.
