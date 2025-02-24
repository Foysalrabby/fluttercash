import 'package:flutter/material.dart';
import 'package:flutterofflinecash/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';


class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _isOffline = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != ConnectivityResult.none;

    if (hasInternet) {
      try {
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

        if (response.statusCode == 200) {
          List<dynamic> jsonData = jsonDecode(response.body);
          _posts = jsonData.map((item) => PostModel.fromJson(item)).toList();

          // Store data in Hive for offline use
          var box = Hive.box('postsBox');
          box.put('cachedPosts', _posts);
        }
      } catch (e) {
        print("Error fetching posts: $e");
      }
    } else {
      // Load cached data
      _isOffline = true;
      var box = Hive.box('postsBox');
      if (box.containsKey('cachedPosts')) {
        _posts = List<PostModel>.from(box.get('cachedPosts'));
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
