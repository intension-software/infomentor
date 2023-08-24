import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infomentor/backend/fetchUser.dart'; // Import the UserData class and fetchUser function

class TypeData {
  String id;
  String commentIndex;
  String type;

  TypeData({
    required this.id,
    required this.commentIndex,
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
