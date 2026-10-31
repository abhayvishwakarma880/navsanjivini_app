import 'package:flutter/material.dart';

class ResourceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final title = resource['title'] as String;
    final category = resource['category'] as String;
    final readTime = resource['readTime'] as String;
    final takeaways = (resource['takeaways'] as List<String>?) ?? [];
    final sections = (resource['sections'] as List<Map<String, String>>?) ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FCF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FCF9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF123C32)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category & Read Time
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F2EC),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF165A47),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    readTime,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF5E7369),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF123C32),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 18),

              // Key Takeaways Box
              if (takeaways.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F2EC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFD2E6DC)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF165A47), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Key Takeaways',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF123C32),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...takeaways.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(color: Color(0xFF165A47), fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4D6D63),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
              ],

              // Sections
              ...sections.map(
                (sec) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sec['heading'] ?? '',
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF123C32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sec['body'] ?? '',
                        style: const TextStyle(
                          fontSize: 14.2,
                          color: Color(0xFF2C3E37),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
