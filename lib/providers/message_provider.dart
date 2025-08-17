import 'package:flutter/foundation.dart';
import '../utils/mock_data.dart';

class MessageProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messages = {};
  bool _isLoading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get totalUnreadCount => _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);

  MessageProvider() {
    loadConversations();
  }

  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _conversations = MockData.conversations;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Message> getMessagesForConversation(String conversationId) {
    return _messages[conversationId] ?? MockData.getMessagesForConversation(conversationId);
  }

  Future<void> sendMessage(String conversationId, String content) async {
    try {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        senderId: 'current_user',
        senderName: 'You',
        timestamp: DateTime.now(),
        isOwn: true,
      );

      if (_messages[conversationId] == null) {
        _messages[conversationId] = getMessagesForConversation(conversationId);
      }
      
      _messages[conversationId]!.add(newMessage);
      
      // Update conversation's last message
      final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (convIndex != -1) {
        // In a real app, this would be handled by the backend
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendEmergencyAlert(String department, String message) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // In a real app, this would send push notifications to relevant staff
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}