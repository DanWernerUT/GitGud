// messages_widget.dart
import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:hive_goals_flutter/models/message_model.dart';

class MessagesWidget extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  
  const MessagesWidget({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return messages.isEmpty
        ? Center(
            child: Text(
              "No messages yet. Start the conversation!",
              style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
            ),
          )
        : ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessageItem(context, message);
            },
          );
  }

  Widget _buildMessageItem(BuildContext context, Message message) {
    final bool isMe = message.isSentByMe;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? HiveColors.darkPurple : HiveColors.platinum,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: HiveStyle.boldBody.copyWith(
                color: isMe ? Colors.white : HiveColors.darkPurple,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDateTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    
    if (messageDate == today) {
      return 'Today, $timeStr';
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday, $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}, $timeStr';
    }
  }
}