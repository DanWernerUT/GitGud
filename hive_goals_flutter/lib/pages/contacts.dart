import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/services/chat_db_helpter.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:hive_goals_flutter/pages/messages.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;
  final TextEditingController _newContactController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }
  
  @override
  void dispose() {
    _newContactController.dispose();
    super.dispose();
  }
  
  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      List<Map<String, dynamic>> contacts = await ChatDBHelper.instance.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading contacts: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load contacts')),
      );
    }
  }
  
  Future<void> _addContact() async {
    final name = _newContactController.text.trim();
    if (name.isEmpty) return;
    
    try {
      await ChatDBHelper.instance.addContact(name);
      _newContactController.clear();
      await _loadContacts();
      
      // Hide keyboard
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      print('Error adding contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact')),
      );
    }
  }
  
  void _showAddContactDialog() {
    _newContactController.clear(); // Clear the text field
    double dialogWidth = MediaQuery.of(context).size.width - 60;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add New Contact',
            style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
          ),
          content: SizedBox(
            width: dialogWidth,
            child: TextField(
              controller: _newContactController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter contact name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: HiveColors.platinum),
                ),
                filled: true,
                fillColor: HiveColors.platinum,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addContact(),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HiveColors.darkPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addContact,
              child: Text('Add'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
  
  void _navigateToChatPage(Map<String, dynamic> contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(contact: contact),
      ),
    ).then((_) {
      _loadContacts();
    });
  }

  Future<void> _clearAllData() async {
    // Clear contacts and messages
    await ChatDBHelper.instance.clearContacts();
    await ChatDBHelper.instance.clearMessages();
    
    // Reload the contacts
    _loadContacts();
    
    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All messages and contacts have been cleared')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width - 60;
    
    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Center(
          child: SizedBox(
            width: contentWidth,
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Contacts',style: HiveStyle.boldTitle.copyWith(color: HiveColors.darkPurple),),
              actions: [
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: HiveColors.platinum,
                        radius: 25,
                      ),
                      // Icon button
                      IconButton(
                        icon: Icon(Icons.person_add, color: HiveColors.darkPurple),
                        onPressed: _showAddContactDialog,
                        tooltip: 'Add Contact',
                        constraints: BoxConstraints(),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear_all, color: HiveColors.darkPurple),
                  onPressed: _clearAllData, // Call the clear method
                  tooltip: 'Clear All Data',
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _contacts.isEmpty
                  ? Center(
                      child: Text(
                        "No contacts yet. Add your first contact!",
                        style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            itemCount: _contacts.length,
                            itemBuilder: (context, index) {
                              final contact = _contacts[index];
                              final unreadCount = contact['unread_count'] ?? 0;
                              
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: InkWell(
                                  onTap: () => _navigateToChatPage(contact),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: HiveColors.platinum,
                                          child: Icon(Icons.person, color: HiveColors.darkPurple, size: 28),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                contact['name'],
                                                style: HiveStyle.boldBody.copyWith(
                                                  color: HiveColors.darkPurple,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (contact['last_message'] != null)
                                                Text(
                                                  contact['last_message'],
                                                  style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (unreadCount > 0)
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            margin: EdgeInsets.only(left: 4),
                                            decoration: BoxDecoration(
                                              color: HiveColors.darkPurple,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              unreadCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 80), // Adds space at the bottom
                      ],
                    ),
          ),
        ),
    );
  }
}
