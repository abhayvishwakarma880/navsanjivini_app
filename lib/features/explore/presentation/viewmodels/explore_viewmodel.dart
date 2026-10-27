import 'package:flutter/foundation.dart';
import '../../domain/entities/guide_article.dart';

class ExploreViewModel extends ChangeNotifier {
  String _selectedCategory = 'All';

  final List<GuideArticle> _articles = const [
    GuideArticle(
      id: '1',
      title: 'Understanding Anxiety & Panic',
      summary: 'Why our body responds with anxiety and practical grounding methods to regain calm.',
      category: 'Anxiety',
      readingTimeMinutes: 4,
    ),
    GuideArticle(
      id: '2',
      title: 'Sleep Hygiene & Restful Nights',
      summary: 'Science-backed evening routines to ease racing thoughts before bedtime.',
      category: 'Sleep',
      readingTimeMinutes: 5,
    ),
    GuideArticle(
      id: '3',
      title: 'The Art of Setting Gentle Boundaries',
      summary: 'How saying no protects your mental peace and emotional bandwidth.',
      category: 'Self-Care',
      readingTimeMinutes: 3,
    ),
  ];

  String get selectedCategory => _selectedCategory;
  List<GuideArticle> get articles => _selectedCategory == 'All'
      ? _articles
      : _articles.where((a) => a.category == _selectedCategory).toList();

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}

