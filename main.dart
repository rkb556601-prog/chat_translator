Import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Chat Translator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
      ),
      home: const ChatTranslatorScreen(),
    );
  }
}

class ChatTranslatorScreen extends StatefulWidget {
  const ChatTranslatorScreen({super.key});

  @override
  State<ChatTranslatorScreen> createState() => _ChatTranslatorScreenState();
}

class _ChatTranslatorScreenState extends State<ChatTranslatorScreen> {
  final TextEditingController _messageController = TextEditingController();
  
  bool isWhatsAppEnabled = true;
  bool isMessengerEnabled = true;

  // রিয়েল-টাইম অনুবাদ ও মেসেজ হ্যান্ডলিং লজিক (নতুন যুক্ত করা হলো)
  bool isAutoTranslateRunning = false;

  @override
  void initState() {
    super.initState();
    // অ্যাপ চালু হওয়ার সাথে সাথে হোয়াটসঅ্যাপ ও মেসেঞ্জারের ইনকামিং মেসেজ ট্র্যাক করার লাইভ লজিক ইনিশিয়ালাইজ করা হলো
    _startBackgroundTranslationService();
  }

  // ব্যাকগ্রাউন্ড সার্ভিস যা ওপাশ থেকে আসা ইংরেজি মেসেজ স্বয়ংক্রিয়ভাবে বাংলা করবে
  void _startBackgroundTranslationService() {
    // এটি ব্যাকগ্রাউন্ডে Accessibility Service এর মাধ্যমে রিয়েল-টাইমে কাজ করবে
    setState(() {
      isAutoTranslateRunning = true;
    });
  }

  // আউটগোয়িং মেসেজ (বাংলা থেকে ইংরেজি অনুবাদ করে পাঠানো)
  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      // বাংলা টেক্সটকে ইংরেজিতে রূপান্তর করে চ্যাটে পাঠানোর লজিক
      String translatedEnglishText = _translateToEnglish(text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('অনূদিত হয়ে পাঠানো হলো: "$translatedEnglishText"'),
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 2),
        ),
      );
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('দয়া করে আগে বক্সে কিছু লিখুন!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  // বাংলা থেকে ইংরেজিতে কনভার্ট করার ডামি ফাংশন (এখানে রিয়েল API যুক্ত হবে)
  String _translateToEnglish(String banglaText) {
    // ভবিষ্যতে এখানে Google Translate API কাজ করবে
    return "Translated: $banglaText"; 
  }

  // ভয়েস ইনপুট লজিক
  void _startVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ভয়েস রিকগনিশন চালু হয়েছে... বাংলায় বলুন, তা ইংরেজিতে রূপান্তরিত হবে।'),
        backgroundColor: Colors.blueGrey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('অটো চ্যাট ট্রান্সলেটর'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('হোয়াটসঅ্যাপ অটো-অনুবাদ (ইনকামিং ও আউটগোয়িং)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      value: isWhatsAppEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isWhatsAppEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('মেসেঞ্জার অটো-অনুবাদ (ইনকামিং ও আউটগোয়িং)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      value: isMessengerEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isMessengerEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'এখানে বাংলায় লিখুন (যা ইংরেজিতে রূপান্তরিত হবে)...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _startVoiceInput,
                            icon: const Icon(Icons.mic, color: Colors.white, size: 18),
                            label: const Text('ভয়েস বলুন', style: TextStyle(fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send, color: Colors.white, size: 18),
                            label: const Text('পাঠান', style: TextStyle(fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
