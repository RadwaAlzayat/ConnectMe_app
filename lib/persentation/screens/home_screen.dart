import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/post_cubit.dart';
import '../blocs/post_state.dart';
import '../widgets/error_message_view.dart';
import '../widgets/post_card.dart';
import 'creat_post_screen.dart';

/// The community feed.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser user;

  void _openCreatePost(BuildContext context) {
    // A pushed screen is NOT a child of this one, so it cannot find PostCubit
    // by itself: BlocProvider.value hands it the same instance.
    final postCubit = context.read<PostCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: postCubit,
          child: CreatePostScreen(author: user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidePadding = MediaQuery.sizeOf(context).width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New post',
        onPressed: () => _openCreatePost(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) => switch (state) {
          PostInitial() ||
          PostLoading() => const Center(child: CircularProgressIndicator()),
          PostError(:final message) => ErrorMessageView(
            message: message,
            onRetry: () => context.read<PostCubit>().watchPosts(),
          ),
          PostLoaded(:final posts) =>
            posts.isEmpty
                ? const Center(
                    child: Text('No posts yet. Be the first to post!'),
                  )
                : ListView.separated(
                    // Extra bottom space so the last card is not under the button.
                    padding: EdgeInsets.fromLTRB(
                      sidePadding,
                      16,
                      sidePadding,
                      96,
                    ),
                    itemCount: posts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) => PostCard(post: posts[index]),
                  ),
        },
      ),
    );
  }
}
