# LangApp 🗣️ - Boost Your Soft Skills with AI

![Uploading ChatGPT Image Apr 11, 2025, 08_06_02 PM.png…]()

## 📱 About LangApp

LangApp is a cutting-edge Flutter application designed to enhance your soft skills through interactive learning. Focusing on vocabulary expansion, speaking fluency, and pronunciation accuracy, LangApp leverages the power of Gemini AI to create personalized learning experiences.

## ✨ Features

### 🧠 Smart Learning
- **AI-Generated MCQs**: Tailored questions based on your skill level
- **Dynamic Difficulty**: Automatically adjusts challenge level based on performance
- **Pronunciation Analysis**: Get instant feedback on your speech patterns

### 📊 Performance Tracking
- **Comprehensive Analytics**: View your progress across all skill areas
- **Streak Counters**: Stay motivated with daily learning streaks
- **Skill Mapping**: Visual representation of your strengths and areas for improvement

### 🏆 Leaderboards & Community
- **Global Rankings**: Compare your progress with learners worldwide
- **Category Champions**: Separate leaderboards for vocabulary, speaking, and pronunciation
- **Achievement Badges**: Unlock special recognitions for consistent performance

### 📜 Activity History
- **Session Replays**: Review past learning activities
- **Progress Timeline**: Track your improvement over time
- **Performance Insights**: AI-powered suggestions for focused improvement

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (2.10.0 or higher)
- Dart (2.16.0 or higher)
- Android Studio / VS Code
- Gemini API key
- Firebase account setup

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/soft_app.git
```

2. Navigate to project directory
```bash
cd soft_app
```

3. Install dependencies
```bash
flutter pub get
```

4. Add your Gemini API key
   - Create `.env` file in the `assets/` directory
   - Add your API key:
   ```
   GEMINI_API_KEY=your_api_key_here
   ```

5. Set up Firebase
   - Make sure `google-services.json` is placed in the android/app directory
   - Ensure Firebase configuration is set up in `lib/firebase_options.dart`

6. Run the app
```bash
flutter run
```

## 🧩 Project Structure

```
lib/
├── firebase_options.dart      # Firebase configuration
├── main.dart                  # Application entry point
├── model/
│   └── genAi.dart            # Gemini AI integration model
├── pages/
│   ├── completionPage.dart   # Lesson completion screen
│   ├── dashboardPage.dart    # Main dashboard
│   ├── lessonPage.dart       # Learning content screen
│   ├── loginPage.dart        # Authentication screen
│   ├── profilePage.dart      # User profile
│   ├── quizPage.dart         # Quiz interface
│   └── scorePage.dart        # Results and performance
├── provider/
│   ├── mainProvider.dart     # Main state management
│   └── modelProvider.dart    # AI model provider
└── widget/
    ├── customCalendar.dart   # Activity tracking calendar
    ├── customCharts.dart     # Performance visualizations
    ├── customDrawer.dart     # App navigation drawer
    └── heatMapWidget.dart    # Activity heatmap visualization
```

## 📊 Visualize Your Progress

LangApp doesn't just help you learn—it helps you track your improvement with:

- **Heat Maps**: Visualize your daily activity patterns
- **Custom Charts**: Track progress across different skill categories
- **Calendar Integration**: See your learning journey over time

## 🔄 How It Works

1. **Login & Profile Setup**: Create your personalized learning account
2. **Dashboard Overview**: Access your learning modules from the main hub
3. **Lesson Experience**: Engage with AI-powered content tailored to your level
4. **Quiz Challenges**: Test your knowledge through dynamically generated questions
5. **Performance Analysis**: Review your score and areas for improvement
6. **Completion Tracking**: Monitor your overall progress and achievements

## 🛠️ Technology Stack

- **Frontend**: Flutter & Dart
- **AI Integration**: Gemini API for content generation
- **Backend & Authentication**: Firebase
- **State Management**: Provider
- **Environment Management**: Flutter dotenv
- **Analytics**: Custom tracking with Firebase Analytics

## 🔐 Privacy & Security

- User data is securely stored in Firebase
- All communications with Gemini API are encrypted
- Personal learning data remains private and protected

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## 🙏 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Gemini AI](https://ai.google.dev/)
- [Firebase](https://firebase.google.com/)
- [Flutter dotenv](https://pub.dev/packages/flutter_dotenv)
