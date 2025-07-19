# GovVote - Citizen Feedback Platform

A Flutter application for citizens to provide feedback on government policies using IOTA technology for secure notarization.

## Features

### 🔐 Sign In Screen
- Modern, gradient-based UI design
- DID (Decentralized ID) input with validation
- Loading state with progress indicator
- Form validation for proper DID format
- Secure authentication simulation

### 🏠 Dashboard Screen
- Welcome section with user greeting
- Interactive action cards for different features
- **Give Policy Feedback** - Navigates to feedback form
- **View Voting History** - Shows "coming soon" message
- **View Analytics** - Shows "coming soon" message
- Sign out functionality
- Beautiful card-based layout with shadows

### 🗳️ Feedback Screen
- Policy category selection dropdown
- Multi-line feedback input with validation
- Submit button with loading state
- Success message with IOTA notarization confirmation
- Form auto-clear after successful submission
- Security information card

## App Flow

1. **Sign In** → Enter DID → Navigate to Dashboard
2. **Dashboard** → Select "Give Policy Feedback" → Navigate to Feedback
3. **Feedback** → Fill form → Submit → Success message → Return to Dashboard
4. **Dashboard** → Sign Out → Return to Sign In

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone or download the project**
   ```bash
   cd IOTA
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Testing the App

1. **Sign In Screen**: 
   - Enter any DID starting with "did:" (e.g., `did:iota:example:123456789`)
   - Click "Sign In" to proceed

2. **Dashboard Screen**:
   - Click "Give Policy Feedback" to go to feedback form
   - Click "View Voting History" or "View Analytics" to see coming soon messages
   - Click the logout icon to return to sign in

3. **Feedback Screen**:
   - Select a policy category from the dropdown
   - Enter feedback (minimum 10 characters)
   - Click "Submit Feedback" to see the success message
   - Form will clear automatically after submission

## Technical Details

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **UI**: Material Design 3 with custom theming
- **Navigation**: Named routes with Navigator
- **State Management**: StatefulWidget for local state
- **Validation**: Form validation with custom rules
- **Styling**: Custom gradients, shadows, and rounded corners

## Future Enhancements

- Integration with actual IOTA Identity for DID verification
- IOTA Notarization module integration for feedback storage
- Real-time analytics and voting history
- Push notifications for new policies
- Offline support with local storage

## Project Structure

```
lib/
├── main.dart                 # App entry point and routing
└── screens/
    ├── sign_in_screen.dart   # Authentication screen
    ├── dashboard_screen.dart # Main dashboard
    └── feedback_screen.dart  # Feedback submission
```

## Troubleshooting

If you encounter any issues:

1. **Flutter doctor**: Run `flutter doctor` to check your setup
2. **Clean build**: Run `flutter clean && flutter pub get`
3. **Hot reload**: Use `r` in terminal or hot reload button in IDE
4. **Restart**: Use `R` in terminal or hot restart button in IDE

## Contributing

This is a demo application showcasing Flutter UI/UX best practices with IOTA integration concepts. Feel free to extend the functionality or improve the design! 