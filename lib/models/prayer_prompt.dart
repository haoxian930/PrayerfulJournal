class PrayerPrompt {

  PrayerPrompt({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.isActive = true,
  });

  factory PrayerPrompt.fromMap(Map<String, dynamic> map) {
    return PrayerPrompt(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      isActive: map['is_active'] == 1,
    );
  }
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isActive;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'is_active': isActive ? 1 : 0,
    };
  }

  // Default prayer prompts to seed the database
  static List<PrayerPrompt> get defaultPrompts => [
    PrayerPrompt(
      id: 'prompt_1',
      title: 'Gratitude',
      content: 'What are three specific things you\'re grateful for today? Take time to thank God for His faithfulness in these areas.',
      category: 'Daily',
    ),
    PrayerPrompt(
      id: 'prompt_2',
      title: 'Guidance',
      content: 'Ask God for wisdom and direction in a current decision you\'re facing. Listen for His gentle voice.',
      category: 'Wisdom',
    ),
    PrayerPrompt(
      id: 'prompt_3',
      title: 'Others',
      content: 'Pray for someone in your life who needs encouragement, healing, or God\'s intervention.',
      category: 'Intercession',
    ),
    PrayerPrompt(
      id: 'prompt_4',
      title: 'Confession',
      content: 'Reflect on areas where you fall short and ask for God\'s forgiveness and strength to grow.',
      category: 'Personal',
    ),
    PrayerPrompt(
      id: 'prompt_5',
      title: 'Worship',
      content: 'Spend time praising God for who He is - His character, His love, His power, and His goodness.',
      category: 'Worship',
    ),
    PrayerPrompt(
      id: 'prompt_6',
      title: 'Scripture Meditation',
      content: 'Read a verse or passage and ask God how He wants to speak to you through His Word today.',
      category: 'Scripture',
    ),
    PrayerPrompt(
      id: 'prompt_7',
      title: 'Future Dreams',
      content: 'Share your hopes and dreams with God. Ask Him to align your desires with His will.',
      category: 'Vision',
    ),
    PrayerPrompt(
      id: 'prompt_8',
      title: 'Global Perspective',
      content: 'Pray for a nation, people group, or global issue. Ask God to work in ways only He can.',
      category: 'Global',
    ),
    PrayerPrompt(
      id: 'prompt_9',
      title: 'Family & Relationships',
      content: 'Pray for peace, understanding, and God\'s blessing over your relationships and family.',
      category: 'Relationships',
    ),
    PrayerPrompt(
      id: 'prompt_10',
      title: 'Strength for Today',
      content: 'Ask God for the strength, courage, and peace you need to face today\'s challenges.',
      category: 'Daily',
    ),
  ];
}
