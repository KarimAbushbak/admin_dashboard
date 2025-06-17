const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
        const notification = snap.data();
        
        const message = {
            token: notification.token,
            notification: {
                title: notification.title,
                body: notification.body,
            },
            data: notification.data,
        };

        try {
            await admin.messaging().send(message);
            console.log('Successfully sent notification:', notification);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }); 