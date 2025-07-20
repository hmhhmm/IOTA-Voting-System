# 🗳️ IOTA Voting Platform

A comprehensive Flutter-based voting and feedback platform built with IOTA technology for secure, decentralized identity management and voting processes.

## 🌟 Features

### 🔐 **Authentication & Identity Management**
- **DID Registration**: Automatic Decentralized Identifier (DID) generation using IOTA Identity
- **Secure Sign-up**: Streamlined registration with DID creation and display
- **Identity Verification**: DID-based authentication system
- **Account Management**: User profile creation and management

### 🗳️ **Voting System**
- **Election Voting**: Participate in national and local elections
- **Policy Voting**: Vote on government policies with yes/no options
- **Receipt Generation**: Secure notarization receipts for all votes
- **Vote History**: Track your voting participation

### 📊 **Analytics & Insights**
- **Voter Analytics**: Comprehensive voting statistics and trends
- **Income Classification**: Pie charts showing voter demographics by income
- **Policy Categories**: Multiple policy categories (Economic, Social, Environmental, etc.)
- **Real-time Data**: Live updates on voting patterns

### 💬 **Feedback System**
- **Policy Feedback**: Submit detailed feedback on government policies
- **Category Selection**: Choose from various policy categories
- **Secure Submission**: IOTA-backed feedback notarization
- **Success Confirmation**: Instant feedback submission confirmation

### 🎨 **Modern UI/UX**
- **Responsive Design**: Optimized for mobile and desktop
- **Material Design 3**: Latest Material Design principles
- **Dark/Light Themes**: Adaptive theming system
- **Smooth Animations**: Fluid transitions and interactions

## 🏗️ Architecture

### **Frontend (Flutter)**
- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: StatefulWidget with Provider pattern
- **Navigation**: Named routes with Navigator 2.0
- **UI Components**: Custom Material Design components
- **Charts**: FL Chart for data visualization

### **Backend (Rust)**
- **Framework**: Axum web framework
- **Language**: Rust
- **Identity**: IOTA Identity for DID management
- **API**: RESTful endpoints with JSON responses
- **CORS**: Cross-origin resource sharing enabled
- **Notarization**: UUID-based receipt generation

## 🚀 Quick Start

### **Prerequisites**
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Rust (for backend)
- Android Studio / VS Code with Flutter extension

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd IOTA
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Rust dependencies**
   ```bash
   cd backend
   cargo build
   ```

4. **Start the backend server**
   ```bash
   cd backend
   cargo run
   ```

5. **Run the Flutter app**
   ```bash
   flutter run
   ```

## 📱 App Flow

### **1. Registration Process**
```
Sign Up Form → DID Generation → Success Screen → Dashboard
```

### **2. Voting Process**
```
Dashboard → Election/Policy Voting → Vote Confirmation → Receipt Display
```

### **3. Feedback Process**
```
Dashboard → Feedback Form → Submission → Success Message
```

### **4. Analytics**
```
Dashboard → Analytics → Charts & Statistics
```

## 🔧 API Endpoints

### **Authentication**
- `POST /did/create` - Generate new DID
- `GET /health` - Health check

### **Voting**
- `POST /vote` - Submit election vote
- `POST /policy_vote` - Submit policy vote

### **Feedback**
- `POST /feedback/submit` - Submit policy feedback

### **Credentials**
- `POST /credential/issue` - Issue identity credentials

## 📊 Features in Detail

### **Election Voting**
- Multiple political party options
- Secure vote submission
- Notarization receipt generation
- Vote confirmation dialog

### **Policy Voting**
- Yes/No voting on policies
- Multiple policy categories:
  - Economic Policies
  - Social Welfare
  - Environmental Protection
  - Healthcare
  - Education
  - Infrastructure
  - Security
  - Technology
  - Delayed Policies
  - Reconstructed Policies

### **Analytics Dashboard**
- Voter participation statistics
- Income-based voter classification
- Policy category breakdown
- Interactive pie charts
- Real-time data visualization

### **Feedback System**
- Policy category selection
- Detailed feedback input
- Character count validation
- Success confirmation
- Auto-navigation

## 🧪 Testing

### **Run Flutter Tests**
```bash
flutter test
```

### **Test Coverage**
- Widget testing for UI components
- App loading and stability tests
- Navigation flow validation
- Form validation testing

## 📁 Project Structure

```
IOTA/
├── lib/
│   ├── main.dart                    # App entry point
│   └── screens/
│       ├── sign_in_screen.dart      # Authentication
│       ├── sign_up_screen.dart      # Registration
│       ├── dashboard_screen.dart    # Main dashboard
│       └── feedback_screen.dart     # Feedback form
├── backend/
│   ├── src/
│   │   └── main.rs                  # Rust backend
│   └── Cargo.toml                   # Rust dependencies
├── test/
│   └── widget_test.dart             # Flutter tests
├── android/                         # Android configuration
├── ios/                            # iOS configuration
├── web/                            # Web configuration
└── pubspec.yaml                    # Flutter dependencies
```

## 🔒 Security Features

- **DID-based Authentication**: Decentralized identity verification
- **IOTA Notarization**: Blockchain-backed vote receipts
- **Secure API Communication**: HTTPS with CORS protection
- **Input Validation**: Comprehensive form validation
- **Error Handling**: Graceful error management

## 🎯 Use Cases

### **Government Agencies**
- Collect citizen feedback on policies
- Monitor voting patterns and demographics
- Ensure secure and transparent voting processes

### **Citizens**
- Participate in democratic processes
- Provide feedback on government policies
- Track voting history and receipts

### **Researchers**
- Access anonymized voting data
- Analyze demographic trends
- Study policy impact

## 🚧 Future Enhancements

### **Planned Features**
- [ ] Real-time notifications
- [ ] Offline voting support
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Blockchain integration for vote storage
- [ ] Mobile app deployment
- [ ] API documentation
- [ ] Unit and integration tests

### **Technical Improvements**
- [ ] State management with Riverpod/Bloc
- [ ] Database integration (PostgreSQL)
- [ ] Authentication middleware
- [ ] Rate limiting
- [ ] Logging and monitoring
- [ ] Docker containerization

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### **Development Guidelines**
- Follow Flutter and Dart style guidelines
- Write tests for new features
- Update documentation
- Ensure code quality with linting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### **Troubleshooting**

**Common Issues:**
1. **Flutter not found**: Ensure Flutter is in your PATH
2. **Backend connection failed**: Check if backend is running on port 8000
3. **Dependencies issues**: Run `flutter clean && flutter pub get`

**Debug Commands:**
```bash
flutter doctor                    # Check Flutter setup
flutter clean                     # Clean build cache
flutter pub get                   # Install dependencies
cargo clean && cargo build        # Clean and rebuild Rust backend
```

### **Getting Help**
- Create an issue for bugs or feature requests
- Check existing issues for solutions
- Review the documentation

## 🙏 Acknowledgments

- **IOTA Foundation** for decentralized identity technology
- **Flutter Team** for the amazing framework
- **Rust Community** for the robust backend ecosystem
- **Material Design** for UI/UX guidelines

---

**Built with ❤️ using Flutter, Rust, and IOTA technology** 