import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/user.dart';
import '../blocs/post_cubit.dart';
import '../widgets/app_text_field.dart';
import '../widgets/gradient_button.dart';

/// Form opened by the floating button to publish a new post.
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, required this.author});

  final AppUser author;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Taken before the await, so no BuildContext is used after the gap.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final postCubit = context.read<PostCubit>();

    setState(() => _isSubmitting = true);
    try {
      await postCubit.createPost(
        author: widget.author,
        content: _contentController.text,
      );
      navigator.pop(); // the live feed already shows the new post
    } on Failure catch (failure) {
      messenger.showSnackBar(SnackBar(content: Text(failure.message)));
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New post')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.08,
          vertical: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _contentController,
                hint: "What's on your mind?",
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                validator: Validators.postContent,
              ),
              const SizedBox(height: 32),
              GradientButton(
                label: 'Post',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
