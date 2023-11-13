import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/userController.dart'; // Import the UserData class and fetchUser function

class TypeData {
  String id;
  String commentIndex;
  String answerIndex;
  String type;

  TypeData({
    required this.id,
    required this.commentIndex,
    required this.answerIndex,
    required this.type,
  });
}

class NotificationsData {
  String content;
  Timestamp date;
  String title;
  TypeData type;
  String user;

  NotificationsData({
    required this.content,
    required this.date,
    required this.title,
    required this.type,
    required this.user,
  });
}

Future<List<NotificationsData>> fetchNotifications(UserData userData) async {
  try {
    CollectionReference notificationsRef =
        FirebaseFirestore.instance.collection('notifications');

    // Filter notifications based on the user's notifications list
    List<String> userNotificationIds = userData.notifications.map((n) => n.id).toList();

    if (userNotificationIds.isEmpty) {
      return [];
    }

    Query notificationsQuery = notificationsRef.where(FieldPath.documentId, whereIn: userNotificationIds);

    QuerySnapshot snapshot = await notificationsQuery.get();

    List<NotificationsData> notifications = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Extracting the type data
      Map<String, dynamic> typeDataMap = data['type'] as Map<String, dynamic>;
      TypeData typeData = TypeData(
        id: typeDataMap['id'] ?? '',
        commentIndex: typeDataMap['commentIndex'] ?? '',
        answerIndex: typeDataMap['answerIndex'] ?? '',
        type: typeDataMap['type'] ?? '',
      );

      return NotificationsData(
        content: data['content'] ?? '',
        date: data['date'] ?? '',
        title: data['title'] ?? '',
        type: typeData,
        user: data['user'] ?? '',
      );
    }).toList();

    return notifications;
  } catch (e) {
    print('Error fetching notifications: $e');
    throw Exception('Failed to fetch notifications');
  }
}

Future<void> sendNotification(List<String> userIds, String content, String title, TypeData type) async {
  try {
    final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
    CollectionReference notificationsRef = FirebaseFirestore.instance.collection('notifications');
    
    DocumentReference notificationDocRef = await notificationsRef.add({
      'content': content,
      'date': Timestamp.now(),
      'title': title,
      'type': {
        'id': type.id,
        'commentIndex': type.commentIndex,
        'answerIndex': type.answerIndex,
        'type': type.type,
      },
    });

    String notificationId = notificationDocRef.id;

    for (String userId in userIds) {
      UserData userData = await fetchUser(userId);
      
      // Here we are casting each notification entry to <String, Object> to satisfy Firestore
      List<Map<String, Object>> notificationsList = userData.notifications.map((notification) {
        return {
          'id': notification.id,
          'seen': notification.seen,
        } as Map<String, Object>; // Explicitly cast as <String, Object>
      }).toList();

      // Add the new notification also as <String, Object>
      notificationsList.add({
        'id': notificationId,
        'seen': false,
      } as Map<String, Object>);

      // Update the user's notifications list in the database
      await usersRef.doc(userId).update({
        'notifications': notificationsList
      });
    }
  } catch (e) {
    print('Error sending notifications: $e');
    throw Exception('Failed to send notifications');
  }
}

