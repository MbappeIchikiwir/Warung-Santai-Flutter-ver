import 'package:flutter/material.dart';
import '../model/post.dart';
import '../api/repository.dart';

class PostProvider with ChangeNotifier {
  final Repository _repository = Repository();
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _nextPageUrl;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasNextPage => _nextPageUrl != null;

  Future<void> fetchPosts({int page = 1}) async {
    if (page == 1) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      final data = await _repository.fetchPosts(page);
      if (page == 1) {
        _posts = data['posts'];
      } else {
        _posts.addAll(data['posts']);
      }
      _nextPageUrl = data['nextPageUrl'];
    } catch (e) {
      // Handle error, e.g., show snackbar or log
      print('Error fetching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_nextPageUrl != null && !_isLoading) {
      // Extract page number from URL, assuming format like '?page=2'
      final uri = Uri.parse(_nextPageUrl!);
      final page = int.tryParse(uri.queryParameters['page'] ?? '1') ?? 1;
      await fetchPosts(page: page);
    }
  }

  Future<bool> insertPost(String title, String content,
      {String? imagePath}) async {
    try {
      // Assuming imagePath is provided, convert to File if needed
      // For simplicity, assuming imagePath is null or handled elsewhere
      return await _repository.insertPost(
          null, title, content); // Adjust as needed
    } catch (e) {
      print('Error inserting post: $e');
      return false;
    }
  }

  Future<bool> updatePost(int id, String title, String content,
      {String? imagePath}) async {
    try {
      return await _repository.updatePost(
          null, title, content, id); // Adjust for image
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  Future<bool> deletePost(int id) async {
    try {
      return await _repository.deletePost(id);
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}
