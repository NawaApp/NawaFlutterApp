
// Import and configure the Firebase SDK
// These scripts are made available when the app is served or deployed on Firebase Hosting
// If you do not serve/host your project using Firebase Hosting see https://firebase.google.com/docs/web/setup
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in the
// messagingSenderId.
const firebaseConfig = {
    apiKey: "AIzaSyDlSs-rwemEFsRzSE6OvbZp_uuxjvuCeiw",
    authDomain: "nawa-flutter-app.firebaseapp.com",
    projectId: "nawa-flutter-app",
    storageBucket: "nawa-flutter-app.appspot.com",
    messagingSenderId: "828091702220",
    appId: "1:828091702220:web:f495370b31f220de99db69",
    measurementId: "G-84G7WP0J3K"
};

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();