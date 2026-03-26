import 'package:flutter/material.dart';
import 'package:shop_owner_screen/data/models/blog_dto.dart';
import 'package:shop_owner_screen/data/service/blog_service.dart';
import 'package:shop_owner_screen/presentation/theme/food_order_ui.dart';

class BlogScreen extends StatefulWidget {
  final int userId;

  const BlogScreen({super.key, required this.userId});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogService _service = BlogService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<BlogDto> _blogs = const [];
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBlogs();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadBlogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final blogs = await _service.fetchBlogs();
      if (!mounted) return;
      setState(() {
        _blogs = blogs;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _createBlog() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề và nội dung blog')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final created = await _service.createBlog(
        CreateBlogRequest(
          userId: widget.userId,
          title: title,
          content: content,
        ),
      );
      if (!mounted) return;
      setState(() {
        _blogs = [created, ..._blogs];
        _submitting = false;
      });
      _titleController.clear();
      _contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng blog thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodOrderUi.scaffoldBg,
      appBar: AppBar(title: const Text('Blog cộng đồng')),
      body: RefreshIndicator(
        onRefresh: _loadBlogs,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chia sẻ món ngon hôm nay',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: FoodOrderUi.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        prefixIcon: Icon(Icons.edit_note_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contentController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.article_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: _submitting ? null : _createBlog,
                        icon: _submitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(_submitting ? 'Đang đăng...' : 'Đăng bài'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: FoodOrderUi.textPrimary),
                  ),
                ),
              )
            else if (_blogs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Text(
                    'Chưa có bài viết nào',
                    style: TextStyle(
                        color: FoodOrderUi.textPrimary.withOpacity(0.7)),
                  ),
                ),
              )
            else
              ..._blogs.map((blog) {
                final createdAt = blog.createdAt?.toLocal();
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: FoodOrderUi.textPrimary,
                          ),
                        ),
                        if (createdAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}',
                            style: TextStyle(
                                color:
                                    FoodOrderUi.textPrimary.withOpacity(0.55)),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          blog.content,
                          style: const TextStyle(
                              height: 1.5, color: FoodOrderUi.textPrimary),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
