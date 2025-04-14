import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    _HomeContent(),
    const ArticlesPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? user?.email ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Welcome, $displayName',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.red),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()),
                    );
                  },
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person, color: Colors.red),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/coronary.png'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black54,
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Coronary Artery Detection',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/heart_bpm');
                          },
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/heart_bpm.jpeg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black54,
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Heart BPM',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Container(
            height: 400,
            width: double.infinity,
            color: Colors.white,
            child: Image.asset(
              'assets/images/heartcheckup.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  static const List<Map<String, dynamic>> articles = [
    {
      'title': 'Understanding Coronary Artery Disease',
      'description':
          'Learn about the causes, symptoms, and treatments for coronary artery disease, a leading cause of heart issues worldwide.',
      'image': 'assets/images/coronary_article.jpg',
      'url':
          'https://www.mayoclinic.org/diseases-conditions/coronary-artery-disease/symptoms-causes/syc-20350613',
    },
    {
      'title': 'How to Monitor Your Heart Rate Effectively',
      'description':
          'Discover tips and tools for tracking your heart rate to maintain optimal heart health and detect abnormalities early.',
      'image': 'assets/images/heart_rate_article.jpg',
      'url':
          'https://www.heart.org/en/healthy-living/fitness/fitness-basics/target-heart-rates',
    },
    {
      'title': 'Lifestyle Changes for a Healthier Heart',
      'description':
          'Explore practical lifestyle changes, from diet to exercise, that can significantly improve your heart health.',
      'image': 'assets/images/lifestyle_article.jpg',
      'url': 'https://www.cdc.gov/heartdisease/prevention.htm',
    },
    {
      'title': 'Advances in Heart Disease Detection',
      'description':
          'Read about the latest technologies and methods for early detection of heart disease, improving outcomes for patients.',
      'image': 'assets/images/detection_article.jpg',
      'url':
          'https://www.nih.gov/news-events/nih-research-matters/new-imaging-technique-detects-heart-disease',
    },
    {
      'title': 'Managing Stress to Protect Your Heart',
      'description':
          'Understand the link between stress and heart health, and learn strategies to manage stress for a healthier heart.',
      'image': 'assets/images/stress_article.jpg',
      'url':
          'https://www.heart.org/en/healthy-living/healthy-lifestyle/stress-management/stress-and-heart-health',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Articles',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Heart Health Insights',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...articles.map((article) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => _launchUrl(article['url']),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.asset(
                                article['image'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint(
                                      'Image failed to load: ${article['image']}, error: $error');
                                  return Container(
                                    height: 150,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article['description'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Read More',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: Colors.red.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.red.shade600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _bpmAlerts = true;
  bool _articleUpdates = false;
  bool _checkupReminders = true;

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Coming Soon',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'This feature is under development and will be available in a future update.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error signing out: $e',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.red),
                      title: const Text(
                        'Edit Profile',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _signOut(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text(
                        'Delete Account',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeColor: Colors.red,
                      title: const Text(
                        'BPM Alerts',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Notify if heart rate exceeds threshold',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      value: _bpmAlerts,
                      onChanged: (value) => setState(() => _bpmAlerts = value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      activeColor: Colors.red,
                      title: const Text(
                        'Article Updates',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Get notified about new heart health articles',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      value: _articleUpdates,
                      onChanged: (value) =>
                          setState(() => _articleUpdates = value),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      activeColor: Colors.red,
                      title: const Text(
                        'Checkup Reminders',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Remind me for regular heart checkups',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      value: _checkupReminders,
                      onChanged: (value) =>
                          setState(() => _checkupReminders = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'App Preferences',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.brightness_6, color: Colors.red),
                      title: const Text(
                        'Theme',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Light mode (Dark mode coming soon)',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language, color: Colors.red),
                      title: const Text(
                        'Language',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'English (More languages coming soon)',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.straighten, color: Colors.red),
                      title: const Text(
                        'Units',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Set units for BPM and other metrics',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Heart Health',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: const Text(
                        'BPM Threshold',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Set custom heart rate alert levels',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.red),
                      title: const Text(
                        'Data Sharing',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Share anonymized data for research',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.cloud_upload, color: Colors.red),
                      title: const Text(
                        'Backup Health Data',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Save heart health data to the cloud',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help, color: Colors.red),
                      title: const Text(
                        'FAQ',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.support_agent, color: Colors.red),
                      title: const Text(
                        'Contact Support',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.bug_report, color: Colors.red),
                      title: const Text(
                        'Report a Bug',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'About',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.red),
                      title: const Text(
                        'App Version',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        '1.0.0',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.code, color: Colors.red),
                      title: const Text(
                        'Developed By',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      subtitle: const Text(
                        'Nipun Sahoo @HeartCare Labs',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.gavel, color: Colors.red),
                      title: const Text(
                        'Terms of Service',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, color: Colors.red),
                      title: const Text(
                        'Privacy Policy',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading:
                          const Icon(Icons.library_books, color: Colors.red),
                      title: const Text(
                        'Open Source Licenses',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'More',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.red),
                      title: const Text(
                        'Rate the App',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.red),
                      title: const Text(
                        'Share the App',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                      onTap: () => _showComingSoonDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© 2025 HeartCare Labs. All Rights Reserved.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // Sample notifications data
  static const List<Map<String, dynamic>> notifications = [
    {
      'type': 'bpm_alert',
      'title': 'High Heart Rate Detected',
      'description': 'Your heart rate exceeded 100 BPM at 10:30 AM today.',
      'timestamp': '2025-04-14 10:30 AM',
      'isRead': false,
      'icon': Icons.favorite,
    },
    {
      'type': 'checkup_reminder',
      'title': 'Weekly Checkup Reminder',
      'description':
          'Time for your weekly heart checkup! Schedule a scan today.',
      'timestamp': '2025-04-14 09:00 AM',
      'isRead': false,
      'icon': Icons.event,
    },
    {
      'type': 'article_update',
      'title': 'New Article Available',
      'description': 'Read our latest article: Tips for Heart-Healthy Eating.',
      'timestamp': '2025-04-13 02:15 PM',
      'isRead': true,
      'icon': Icons.article,
    },
    {
      'type': 'scan_result',
      'title': 'Scan Results Ready',
      'description':
          'Your recent coronary scan is ready for review in the dashboard.',
      'timestamp': '2025-04-13 11:45 AM',
      'isRead': false,
      'icon': Icons.scanner,
    },
    {
      'type': 'tip',
      'title': 'Heart Health Tip',
      'description': 'Stay hydrated to support optimal heart function.',
      'timestamp': '2025-04-12 08:00 AM',
      'isRead': true,
      'icon': Icons.lightbulb,
    },
  ];

  // Placeholder dialog for actions
  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Coming Soon',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'This feature is under development and will be available soon.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showComingSoonDialog(context),
            child: const Text(
              'Mark All as Read',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Updates',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications yet.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Column(
                      children: notifications.map((notification) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: notification['isRead']
                                ? Colors.grey.shade100
                                : Colors.white,
                            child: ListTile(
                              leading: Icon(
                                notification['icon'],
                                color: Colors.red,
                                size: 30,
                              ),
                              title: Text(
                                notification['title'],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: notification['isRead']
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['description'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: notification['isRead']
                                          ? Colors.grey.shade500
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification['timestamp'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _showComingSoonDialog(context),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 24,
                                ),
                                onPressed: () => _showComingSoonDialog(context),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'HeartCare Labs by Nipun Sahoo',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
