import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:warung_santai/model/food_item.dart';
import 'package:warung_santai/screen/add_edit_post_screen.dart';
import '../api/repository.dart';
import '../component/post_view.dart';
import '../model/post.dart';
import 'food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({
    super.key,
    required this.title,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> categories = [
    {'name': 'Breakfast', 'image': 'assets/bx-egg-fried.png'},
    {'name': 'Nasi', 'image': 'assets/bx-bowl-rice.png'},
    {'name': 'Gorengan', 'image': 'assets/bx-taco.png'},
    {'name': 'Minuman', 'image': 'assets/bx-coffee-cup.png'},
    {'name': 'Camilan', 'image': 'assets/bx-icecream.png'},
  ];

  final List<Map<String, dynamic>> popularItems = [
    {'name': 'Nasi Goreng', 'image': 'assets/nasgor.jpg', 'price': 15000},
    {'name': 'Batagor', 'image': 'assets/batagor.jpg', 'price': 10000},
  ];

  final ScrollController _scrollController = ScrollController();
  final Repository _apiService = Repository();

  final List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePosts();
      }
    });
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.fetchPosts(_currentPage);
      // log(result['posts'].toString());
      setState(() {
        _currentPage++;
        _posts.addAll(result['posts']);
        _hasMore = result['nextPageUrl'] != null;
      });
    } catch (e) {
      // print(e);
      // throw Exception(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.fetchPosts(_currentPage);
      setState(() {
        _currentPage++;
        _posts.addAll(result['posts']);
        _hasMore = result['nextPageUrl'] != null;
      });
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePost(int postId) async {
    try {
      final response = await _apiService.deletePost(postId);
      if (response) {
        setState(() {
          _posts.removeWhere((post) => post.id == postId);
        });
        _loadMorePosts();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/menu.png', // Pastikan nama file sesuai
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                _currentPage = 1;
                _posts.clear();
                _hasMore = true;
                await _loadPosts();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _header()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _searchBar()),
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(child: _categories()),

                  // CRUD LIST
                  _buildPostListSliver(),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditPostScreen(),
                ),
              );
              if (result == true) {
                _currentPage = 1;
                _posts.clear();
                _hasMore = true;
                _loadPosts();
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  SliverList _buildPostListSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == _posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final post = _posts[index];

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                post.title?.substring(0, 1).toUpperCase() ?? "?",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              post.title ?? "",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              post.description ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditPostScreen(
                          post: post,
                        ),
                      ),
                    );

                    if (result == true) {
                      _currentPage = 1;
                      _posts.clear();
                      _hasMore = true;
                      await _loadPosts();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deletePost(post.id!),
                ),
              ],
            ),
          );
        },
        childCount: _posts.length + (_hasMore ? 1 : 0),
      ),
    );
  }

  Widget _header() {
    return Text(
      'Selamat Datang di Warung Santai!',
      style: GoogleFonts.poppins(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari makanan favoritmu...',
        prefixIcon: Icon(Icons.search, color: Colors.green[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }

  Widget _categories() {
    return SizedBox(
      height: 130, // Diperluas sedikit untuk akomodasi teks
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Menggunakan ukuran minimum
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    categories[index]['image']!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Flexible(
                  // Membuat teks fleksibel
                  child: Text(
                    categories[index]['name']!,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis, // Potong teks panjang
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostListold() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _posts.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final post = _posts[index];

        log(post.toString());

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.filled(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {},
              child: Stack(
                children: [
                  PostView(post: post),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditPostScreen(),
                          ),
                        );

                        if (result == true) {
                          _currentPage = 1;
                          _posts.clear();
                          _hasMore = true;
                          _loadPosts();
                        }
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: IconButton(
                      onPressed: () => _deletePost(post.id!),
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
