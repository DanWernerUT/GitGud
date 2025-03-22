import 'package:flutter/material.dart';
import 'package:hive_goals_flutter/res/hive_colors.dart';
import 'package:hive_goals_flutter/res/hive_style.dart';
import 'package:hive_goals_flutter/widgets/top_nav.dart';
import 'package:hive_goals_flutter/services/connections_db_helper.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  List<Map<String, dynamic>> _posts = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Mind';

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final posts = await ConnectionsDBHelper.instance.getPosts();
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width - 60; // Maximum width (with padding)

    return Scaffold(
      backgroundColor: HiveColors.background,
      appBar: TopAppBar(title: "Connections"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center( // Center the search text field
                child: Container(
                  width: dialogWidth, // Set maximum width
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Topic...",
                      fillColor: HiveColors.platinum,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center( // Center the button
                child: Container(
                  width: dialogWidth, // Set maximum width
                  child: ElevatedButton(
                    onPressed: () => _showCreatePostDialog(dialogWidth),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HiveColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "+ Create Post",
                      style: TextStyle(color: HiveColors.darkPurple),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
             Row(
                mainAxisAlignment: MainAxisAlignment.center, // Align to the start of the row
                children: [
                  _buildCategoryChip("Education"),
                  SizedBox(width: 10), // Add spacing between the tags
                  _buildCategoryChip("Fitness"),
                  SizedBox(width: 10), // Add spacing between the tags
                  _buildCategoryChip("Mind"),
                ],
              ),
              SizedBox(height: 20),
              // Use shrinkWrap to avoid overflow in the ListView
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: _posts.length + 1, // Increase the itemCount by 1
                itemBuilder: (context, index) {
                  // Check if the index is the last item
                  if (index == _posts.length) {
                    return SizedBox(height: 50); // Add SizedBox after the last post
                  }

                  return _buildPostCard(
                    _posts[index]['title'],
                    _posts[index]['description'],
                    _posts[index]['category'],
                    _posts[index]['comments'],
                    dialogWidth, // Don't forget to pass dialogWidth
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return SizedBox(
      child: Chip(
        label: Text(label),
        backgroundColor: HiveColors.platinum,
      ),
    );
  }

  Widget _buildPostCard(String title, String description, String category, int comments, double dialogWidth) {
    return SizedBox(
      width: dialogWidth, // Apply maximum width here
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding if needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(description),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryTag(category, dialogWidth), // Pass dialogWidth to category tag
                  _buildCommentTag(comments, dialogWidth), // Pass dialogWidth to comment tag
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category, double dialogWidth) {
    return Container(
      width: dialogWidth / 3, // Adjust width to avoid stretching too much
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HiveColors.yellow,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCommentTag(int comments, double dialogWidth) {
    return Container(
      width: dialogWidth / 3, // Adjust width to avoid stretching too much
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HiveColors.yellow,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text("$comments Comments", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _showCreatePostDialog(double dialogWidth) {
    _titleController.clear();
    _descriptionController.clear();
    _selectedCategory = 'Mind';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create New Post',
            style: HiveStyle.boldBody.copyWith(color: HiveColors.darkPurple),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center( // Center the text field in the dialog
                child: SizedBox(
                  width: dialogWidth, // Set maximum width
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter post title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center( // Center the text field in the dialog
                child: SizedBox(
                  width: dialogWidth, // Set maximum width
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter post description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newCategory) {
                  setState(() {
                    _selectedCategory = newCategory!;
                  });
                },
                items: <String>['Mind', 'Education', 'Fitness']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createPost() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty) {
      return;
    }

    try {
      await ConnectionsDBHelper.instance.addPost(title, description, _selectedCategory, 0);
      _titleController.clear();
      _descriptionController.clear();
      Navigator.of(context).pop(); // Close the dialog
      _loadPosts(); // Reload posts
    } catch (e) {
      print('Error creating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create post')));
    }
  }
}
