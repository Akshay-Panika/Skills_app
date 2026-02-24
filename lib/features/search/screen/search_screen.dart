import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const Color primaryColor = Color(0xFF1565C0); // Deep Blue
  static const Color accentColor = Color(0xFF00897B);  // Teal

  final List<String> recentSearches = const [
    'Python for beginners',
    'UI UX design',
    'Digital Marketing',
    'Data Science',
    'Flutter development',
  ];

  final List<Map<String, dynamic>> recommendations = const [
    {
      'title': 'Top-rated Python & Machine Learning courses near you',
      'icon': Icons.code,
      'color': Color(0xFFE3F2FD),
      'iconColor': Color(0xFF1565C0),
    },
    {
      'title': 'Explore Graphic Design skills from expert tutors',
      'icon': Icons.brush,
      'color': Color(0xFFE8F5E9),
      'iconColor': Color(0xFF2E7D32),
    },
    {
      'title': 'Find local & online English Speaking coaches',
      'icon': Icons.record_voice_over,
      'color': Color(0xFFFFF3E0),
      'iconColor': Color(0xFFE65100),
    },
  ];

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Coding &\nTech', 'icon': Icons.laptop_mac},
    {'label': 'Design &\nCreative', 'icon': Icons.palette},
    {'label': 'Language\nLearning', 'icon': Icons.translate},
    {'label': 'Business &\nFinance', 'icon': Icons.trending_up},
    {'label': 'Music &\nArts', 'icon': Icons.music_note},
    {'label': 'Health &\nFitness', 'icon': Icons.fitness_center},
    {'label': 'Science &\nMaths', 'icon': Icons.science},
    {'label': 'Teaching &\nTutoring', 'icon': Icons.school},
    {'label': 'Photography\n& Video', 'icon': Icons.camera_alt},
    {'label': 'Personal\nDevelopment', 'icon': Icons.self_improvement},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationBar(),
                  const SizedBox(height: 16),
                  _buildRecentSearches(),
                  const SizedBox(height: 16),
                  _buildRecommendations(),
                  const SizedBox(height: 16),
                  _buildCategories(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent.withOpacity(0.16),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 14,
        left: 12,
        right: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App name row
          Row(
            children:  [
              Icon(Icons.menu_book_rounded, color: Colors.blueAccent, size: 22),
              SizedBox(width: 8),
              Text(
                'SkillHub',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Search row
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.blueAccent, size: 24)),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.search, color: Color(0xFF888888), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Find Courses, Skills, Tutors...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const Icon(Icons.mic, color: Color(0xFF888888), size: 20),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Container(
              //   height: 44,
              //   width: 44,
              //   decoration: BoxDecoration(
              //     color: accentColor,
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              //   child: const Icon(Icons.tune, color: Colors.white, size: 22),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Location / Mode Bar ──────────────────────────────────────────────────
  Widget _buildLocationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent, width: 0.3),
        borderRadius: BorderRadius.circular(6),
        color: Colors.lightBlueAccent.withOpacity(0.16),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Hadapsar, Pune',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '🌐  Online & Offline',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Recent Searches ──────────────────────────────────────────────────────
  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map(_buildTag).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC)),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, size: 14, color: Color(0xFF888888)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  // ─── Recommendations ──────────────────────────────────────────────────────
  Widget _buildRecommendations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Based on your learning interests',
            style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 178,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) => _buildRecCard(recommendations[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecCard(Map<String, dynamic> rec) {
    return Container(
      width: 148,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon banner
          Container(
            height: 94,
            width: double.infinity,
            decoration: BoxDecoration(
              color: rec['color'] as Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(rec['icon'] as IconData, size: 48, color: rec['iconColor'] as Color),
              ],
            ),
          ),

          // Text
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 6, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    rec['title'] as String,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                      height: 1.4,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 16, color: primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Categories ───────────────────────────────────────────────────────────
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                mainAxisExtent:100
            ),
            itemCount: categories.length,
            itemBuilder: (_, index) => _buildCategoryItem(categories[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.16),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              cat['icon'] as IconData,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cat['label'] as String,
            textAlign: TextAlign.center,
            style:  TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
                height: 1.2,
                color: Colors.grey.shade700
            ),
          ),
        ],
      ),
    );
  }
}