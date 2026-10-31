import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_spacing.dart';
import '../viewmodels/explore_viewmodel.dart';
import '../widgets/guide_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ExploreViewModel();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore Self-Help Library'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: AppSpacing.screenPadding,
          itemCount: viewModel.articles.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final article = viewModel.articles[index];
            return GuideCard(
              article: article,
              onTap: () {
                // View guide details
              },
            );
          },
        ),
      ),
    );
  }
}
