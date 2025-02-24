import 'package:flutter/material.dart';
import 'package:flutterofflinecash/Statemanagement/Provider.dart';
import 'package:provider/provider.dart';


class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (postProvider.posts.isEmpty) {
            return Center(
              child: Text(
                postProvider.isOffline ? "No Internet. Showing cached data." : "No Data Available.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            itemCount: postProvider.posts.length,
            separatorBuilder: (context, index) => Divider(
              thickness: 1.5,
              color: Colors.grey.shade300,
            ),
            itemBuilder: (context, index) {
              var post = postProvider.posts[index];
              return Card(
                elevation: 5, // Shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        post.body,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
