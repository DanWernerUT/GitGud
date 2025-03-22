import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/services/chat_db_helpter.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:hive_goals_flutter/models/message_model.dart';
import 'package:hive_goals_flutter/widgets/messages_widget.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> contact;
  
  const ChatPage({
    required this.contact,
    super.key,
  });
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMessages() async {
    try {
      List<Map<String, dynamic>> messages = await ChatDBHelper.instance.getMessages(widget.contact['id']);
      setState(() {
        _messages = messages.map((map) => Message.fromMap(map)).toList();
      });
      
      // Mark received messages as read
      await ChatDBHelper.instance.markMessagesAsRead(widget.contact['id']);
      
      // Scroll to bottom after messages load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      // print('Error loading messages: $e');
    }
  }
  
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isSending) return;
    
    setState(() {
      _isSending = true;
    });
    
    try {
      // Clear the input field right away for better UX
      _messageController.clear();
      
      // Send the message
      await ChatDBHelper.instance.sendMessage(
        widget.contact['id'],
        messageText,
        DateTime.now(),
      );
      
      if (!mounted) return;  // Check if still mounted after async operation
      
      // Reload messages to show the sent message
      await _loadMessages();
      
      // For demo purposes, simulate a reply after 2 seconds
      // You would remove this in a real app with actual message exchange
      Future.delayed(Duration(seconds: 2), () async {
        await ChatDBHelper.instance.receiveDummyMessage(
          widget.contact['id'],
          "This is an automated reply to: \"$messageText\"",
        );
        
        if (!mounted) return;  // Check if still mounted after async operation
        await _loadMessages();
      });
    } catch (e) {
      // print('Error sending message: $e');
      if (!mounted) return;  // Check if still mounted after async operation
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    } finally {
      if (mounted) {  // Check if still mounted before calling setState
        setState(() {
          _isSending = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: AppBar(
        backgroundColor: HiveColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: HiveColors.darkPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: HiveColors.platinum,
              child: Icon(Icons.person, color: HiveColors.darkPurple, size: 30),
            ),
            SizedBox(width: 10),
            Text(
              widget.contact['name'],
              style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessagesWidget(
              messages: _messages,
              scrollController: _scrollController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: HiveColors.platinum,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: HiveColors.darkPurple,
                  child: IconButton(
                    icon: _isSending 
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}