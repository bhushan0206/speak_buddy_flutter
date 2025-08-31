import '../models/story_models.dart';

class DemoStoryData {
  static List<StoryChapter> getDemoChapters() {
    return [
      StoryChapter(
        id: 'chapter_1',
        title: 'The Magic Forest Adventure',
        description:
            'Begin your journey in the enchanted forest where words come to life!',
        content: '''
Once upon a time, in a magical forest filled with talking trees and friendly animals, there lived a brave little explorer named Alex. 

Alex loved to discover new places and make new friends. One sunny morning, Alex decided to explore the deepest part of the forest where the oldest and wisest trees lived.

As Alex walked through the forest, the trees whispered secrets and the animals shared stories. But to understand them, Alex needed to learn the special words of the forest.

"Hello, little explorer!" said a wise old oak tree. "To unlock the forest's magic, you must practice saying these special words: hello, friend, magic, and forest."

Alex was excited to learn these words and began practicing them with the help of the forest's magical creatures.
        ''',
        choices: [
          StoryChoice(
            id: 'choice_1_1',
            text: 'Practice saying "hello" to the trees',
            nextChapterId: 'chapter_2',
            requiredWords: ['hello'],
            response: 'Great choice! Let\'s practice saying "hello" together.',
          ),
          StoryChoice(
            id: 'choice_1_2',
            text: 'Ask the animals about the word "friend"',
            nextChapterId: 'chapter_2',
            requiredWords: ['friend'],
            response:
                'Excellent idea! The animals will help you learn about friendship.',
          ),
        ],
        targetWords: ['hello', 'friend', 'magic', 'forest'],
        difficulty: 1,
        characterId: 'wizard',
        metadata: {
          'background': 'forest',
          'timeOfDay': 'morning',
          'weather': 'sunny',
        },
      ),
      StoryChapter(
        id: 'chapter_2',
        title: 'Meeting the Forest Friends',
        description:
            'Learn about friendship and practice your new words with the forest animals!',
        content: '''
Alex chose to practice the special words and soon met a friendly rabbit named Luna and a wise owl named Oliver.

"Hello, Luna!" Alex said with a big smile.

"Hello, Alex!" Luna replied, hopping with joy. "You said that perfectly! Now let's learn about being a good friend."

Oliver the owl flew down from his tree and said, "A friend is someone who cares about you, helps you, and makes you happy. Can you say 'friend'?"

Alex practiced saying "friend" several times until it sounded just right.

"Magic!" exclaimed Luna. "You're learning so quickly! The forest is happy to have such a wonderful new friend."
        ''',
        choices: [
          StoryChoice(
            id: 'choice_2_1',
            text: 'Practice saying "magic" with Luna',
            nextChapterId: 'chapter_3',
            requiredWords: ['magic'],
            response: 'Wonderful! Luna will help you master the word "magic".',
          ),
          StoryChoice(
            id: 'choice_2_2',
            text: 'Learn more about the forest with Oliver',
            nextChapterId: 'chapter_3',
            requiredWords: ['forest'],
            response:
                'Great choice! Oliver knows all about the forest and its secrets.',
          ),
        ],
        targetWords: ['hello', 'friend', 'magic', 'forest'],
        difficulty: 2,
        characterId: 'wizard',
        metadata: {
          'background': 'forest_clearing',
          'timeOfDay': 'morning',
          'weather': 'sunny',
          'characters': ['luna', 'oliver'],
        },
      ),
      StoryChapter(
        id: 'chapter_3',
        title: 'The Forest Celebration',
        description:
            'Celebrate your success and discover the power of friendship and magic!',
        content: '''
Alex had learned all the special words: hello, friend, magic, and forest. The forest creatures were so proud!

"Hello, everyone!" Alex called out to the forest.

"Hello, Alex!" all the animals replied together.

"You are truly a great friend to us all," said Luna.

"The magic of your words has brought joy to our forest," added Oliver.

Alex felt wonderful knowing that words had the power to create friendship and bring magic to life.
        ''',
        choices: [
          StoryChoice(
            id: 'choice_3_1',
            text: 'Start a new adventure',
            nextChapterId: 'chapter_1',
            requiredWords: ['adventure'],
            response: 'Great idea! Every adventure begins with a single word.',
          ),
          StoryChoice(
            id: 'choice_3_2',
            text: 'Practice more words',
            nextChapterId: 'chapter_1',
            requiredWords: ['practice'],
            response: 'Practice makes perfect! Let\'s learn more words together.',
          ),
        ],
        targetWords: ['hello', 'friend', 'magic', 'forest'],
        difficulty: 3,
        characterId: 'wizard',
        metadata: {
          'background': 'forest_celebration',
          'timeOfDay': 'afternoon',
          'weather': 'sunny',
          'characters': ['luna', 'oliver', 'trees'],
        },
      ),
    ];
  }

  static List<AICharacter> getDemoCharacters() {
    return [
      AICharacter(
        id: 'wizard',
        name: 'Wizard Willow',
        description: 'A wise and friendly wizard who guides children through magical adventures',
        personality: 'Patient, encouraging, and loves to teach through stories',
        avatarUrl: 'https://example.com/wizard_avatar.png',
        metadata: {
          'specialty': 'speech_magic',
          'favorite_words': ['magic', 'adventure', 'friendship'],
          'voice_tone': 'warm_and_encouraging',
        },
      ),
      AICharacter(
        id: 'robot',
        name: 'Robo Buddy',
        description: 'A friendly robot who helps children learn through technology',
        personality: 'Logical, helpful, and always ready to assist',
        avatarUrl: 'https://example.com/robot_avatar.png',
        metadata: {
          'specialty': 'technical_learning',
          'favorite_words': ['technology', 'learning', 'innovation'],
          'voice_tone': 'clear_and_precise',
        },
      ),
      AICharacter(
        id: 'fairy',
        name: 'Fairy Flora',
        description: 'A magical fairy who brings joy and wonder to learning',
        personality: 'Playful, imaginative, and loves to create magical moments',
        avatarUrl: 'https://example.com/fairy_avatar.png',
        metadata: {
          'specialty': 'creative_expression',
          'favorite_words': ['imagination', 'creativity', 'wonder'],
          'voice_tone': 'playful_and_whimsical',
        },
      ),
    ];
  }

  static List<Map<String, dynamic>> getAvailableStories() {
    return [
      {
        'id': 'demo_story_1',
        'title': 'The Magic Forest Adventure',
        'description': 'A magical journey through an enchanted forest where words come to life',
        'difficulty': 1,
        'characterId': 'wizard',
        'thumbnailUrl': 'https://example.com/forest_story.png',
      },
      {
        'id': 'demo_story_2',
        'title': 'Robot World Exploration',
        'description': 'Discover the fascinating world of robots and technology',
        'difficulty': 2,
        'characterId': 'robot',
        'thumbnailUrl': 'https://example.com/robot_story.png',
      },
      {
        'id': 'demo_story_3',
        'title': 'Fairy Tale Garden',
        'description': 'A whimsical adventure in a magical garden filled with fairies',
        'difficulty': 1,
        'characterId': 'fairy',
        'thumbnailUrl': 'https://example.com/fairy_story.png',
      },
    ];
  }
}
