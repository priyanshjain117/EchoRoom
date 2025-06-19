# 📢 EchoRoom - Real-time Room-based Chat App with Push Notifications

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white" alt="Express" />
</div>

<br />

EchoRoom is a **real-time, room-based chat application** built using **Flutter** and **Firebase**, where users can join rooms, exchange messages, and receive **instant push notifications** when new messages are sent in rooms they are subscribed to.

> 🔔 **Push notifications are sent via a custom Node.js backend using Firebase Cloud Messaging (FCM)**, integrated seamlessly with Firestore and Firebase Authentication.

---

## ✨ Features

<table>
  <tr>
    <td>🔐</td>
    <td><strong>Firebase Authentication</strong> for secure user login and signup</td>
  </tr>
  <tr>
    <td>🗂️</td>
    <td><strong>Room-based chat system</strong> — users can join or leave chat rooms dynamically</td>
  </tr>
  <tr>
    <td>🧠</td>
    <td><strong>Firestore</strong> for real-time message syncing</td>
  </tr>
  <tr>
    <td>🔔</td>
    <td><strong>Push Notifications</strong> sent only to users in the respective chat room</td>
  </tr>
  <tr>
    <td>💬</td>
    <td>Clean and responsive <strong>Flutter UI</strong></td>
  </tr>
</table>

---

## 🛠️ Tech Stack

| **Technology** | **Purpose** |
|----------------|-------------|
| **Flutter** | Frontend mobile app development |
| **Firebase Auth** | User authentication and authorization |
| **Firestore** | Real-time NoSQL database for messages |
| **Firebase Cloud Messaging (FCM)** | Push notification delivery |
| **Node.js + Express** | Backend server for FCM integration |
| **Firebase Admin SDK** | Server-side Firebase operations |

---

## 📲 Screenshots

<div align="center">
  <img src="screenshots/chat_room.png" width="250" alt="Chat Room" />
  <img src="screenshots/notification.png" width="250" alt="Push Notification" />
</div>

---

## 📦 Project Structure

```
echoRoom/
│
├── chat_app/                 # Flutter mobile application
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── helper/             # credentials for api key
│   │   ├── screens/            # UI screens
│   │   └── widgets/            # UI widgets for re-useability
│   └── pubspec.yaml            # Flutter dependencies
│
├── server/                     # Node.js backend
│   ├── server.js               # Express server setup and FCM notification handler
│   └── package.json            # Node.js dependencies
│
└── README.md                   # Project documentation
└── LICENSE                   # Project LICENSE
```

---

## 🔧 Setup Instructions

### 🔹 **Flutter App Setup**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/priyanshjain117/EchoRoom.git
   cd echoRoom/chat_app
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Add Firebase configuration files:**
   - `google-services.json` (for Android)
   - `GoogleService-Info.plist` (for iOS)

4. **Enable Firebase services in Console:**
   - ✅ Firebase Authentication (Email/Password)
   - ✅ Firestore Database
   - ✅ Cloud Messaging

5. **Run the Flutter app:**
   ```bash
   flutter run
   ```

### 🔹 **Node.js Backend Setup**

1. **Navigate to server directory:**
   ```bash
   cd echoRoom/backend
   ```

2. **Install Node.js dependencies:**
   ```bash
   npm install
   ```

3. **Add Firebase Admin SDK credentials:**
   - Download `service-account.json` from [Firebase Console > Project Settings > Service Accounts]
   - Place it in the `backend/` directory

4. **Configure FCM service:**
   - Update `fcmService.js` with your Firebase project credentials

5. **Start the backend server:**
   ```bash
   npm start
   ```

---

## 🔔 How Push Notifications Work

### **Token Storage:**
When a user logs in, their FCM token is stored in Firestore:    
```dart
Future<void> _setUpFirebaseMessage() async {
    await fcm.requestPermission();
    final fcmToken = await fcm.getToken();
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    print(fcmToken);

    if (user != null && fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmToken': fcmToken,
      });
    }
  }
```

### **Backend Sends Notification:**
```javascript
const message = {
            tokens: tokens,
            notification: {
                title,
                body
            }
        };

const response = await admin.messaging().sendEachForMulticast(message);
```

The backend listens to Firestore changes or receives POST requests and sends targeted push notifications to users subscribed to specific room topics.

---

## 🧪 Future Improvements

- [ ] **Unread message counter** per room
- [ ] **Typing indicators** for active users
- [ ] **Role-based room access** (admin, moderator, member)
- [ ] **File and image attachments**
- [ ] **Web app version** using Flutter Web
- [ ] **Dark mode** theme support
- [ ] **Message reactions** and replies
- [ ] **User presence** indicators (online/offline)

---

## 🤝 Contributing

Contributions are **welcome**! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

For major changes, please open an issue first to discuss what you'd like to change.

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License © 2025 [Your Name]
```

---

## 📬 Contact & Support

If you have questions, suggestions, or want to collaborate:

<div align="center">
  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/your-profile)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:your.email@example.com)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/your-username)

</div>

---

<div align="center">
  <strong>⭐ If you found this project helpful, please give it a star! ⭐</strong>
</div>