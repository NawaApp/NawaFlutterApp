// Import and configure the Firebase SDK
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

firebase.initializeApp(firebaseConfig);

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
