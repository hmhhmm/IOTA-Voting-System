import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Added for jsonDecode
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fl_chart/fl_chart.dart';

String getBackendBaseUrl() {
  return 'http://127.0.0.1:3000';
}

Future<void> checkBackendHealth() async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/health'));
    if (response.statusCode == 200) {
      print('Backend health: \\${response.body}');
    } else {
      print('Backend health check failed: \\${response.statusCode}');
    }
  } catch (e) {
    print('Failed to connect to backend: \\${e}');
  }
}

// Election Voting Page
class ElectionVotingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Election Voting'), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.how_to_vote, color: purple, size: 80),
            SizedBox(height: 24),
            Text(
              'Participate in the Election!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: purple),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Your vote is your voice. Join the latest national and local elections to make a real impact on your community and country.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Why Vote?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple),
                  ),
                  SizedBox(height: 10),
                  Text('• Influence government decisions\n• Support policies you believe in\n• Fulfill your civic duty\n• Help shape the future'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.withOpacity(0.18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Important: Each citizen can only vote once per election. Please make your selection carefully. Duplicate votes will not be counted.',
                      style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.how_to_vote, color: Colors.white),
              label: Text('Go to Voting Page', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                minimumSize: Size(double.infinity, 72),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PartyVotingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Helpdesk & FAQ Page
class HelpdeskFaqPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'q': 'How do I vote in an election?',
      'a': 'Go to the Vote Policies section, select an open policy, and press the Vote button.'
    },
    {
      'q': 'How do I give feedback?',
      'a': 'Tap the Give Feedback button on the home screen and fill out the feedback form.'
    },
    {
      'q': 'Is my vote anonymous?',
      'a': 'Yes, all votes are securely anonymized and protected.'
    },
    {
      'q': 'Who can participate in surveys?',
      'a': 'All registered users can participate in government surveys.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Helpdesk & FAQ'), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent, color: purple, size: 40),
                SizedBox(width: 12),
                Text('Helpdesk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
              ],
            ),
            SizedBox(height: 12),
            Text('Need assistance? Contact our support team:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: purple),
                SizedBox(width: 8),
                Text('support@govvote.gov', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: purple),
                SizedBox(width: 8),
                Text('+1 800 123 4567', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.question_answer, color: purple, size: 40),
                SizedBox(width: 12),
                Text('Frequently Asked Questions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
              ],
            ),
            SizedBox(height: 16),
            ...faqs.map((faq) => Container(
              margin: EdgeInsets.only(bottom: 18),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q: ${faq['q']}', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                  SizedBox(height: 6),
                  Text('A: ${faq['a']}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomePage(),
    AnalyticsPage(),
    PolicyPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.policy), label: 'Policy'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class VerifyIdentityPage extends StatefulWidget {
  @override
  _VerifyIdentityPageState createState() => _VerifyIdentityPageState();
}

class _VerifyIdentityPageState extends State<VerifyIdentityPage> {
  bool _verifying = true;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1600), () async {
      setState(() {
        _verifying = false;
        _verified = true;
      });
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ElectionVotingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Verify Identity'), backgroundColor: purple),
      body: Center(
        child: _verifying
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: purple),
                  SizedBox(height: 24),
                  Text('Verifying your identity...', style: TextStyle(fontSize: 18)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, color: purple, size: 64),
                  SizedBox(height: 24),
                  Text('Identity Verified!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
                  SizedBox(height: 24),
                  // Button removed, auto navigation after 1s
                ],
              ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [purple, purple.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // Remove rounded corners for sharp vertices
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(32),
              //   bottomRight: Radius.circular(32),
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PersonalIdentityPage()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Text('L', style: TextStyle(fontWeight: FontWeight.bold, color: purple, fontSize: 24)),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => NotificationsPage()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'WELCOME TO THE NEW\n', style: TextStyle(fontSize: 14, color: Colors.white70, letterSpacing: 1)),
                      TextSpan(text: 'Gov', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow[700])),
                      TextSpan(text: 'Vote', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Participate in policy voting and give your feedback to shape the future!',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: purple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AboutAppPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Find out more', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Removed carousel dots
              ],
            ),
          ),
          // Main menu horizontal bar buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              children: [
                _LongMenuButton(
                  icon: Icons.how_to_vote,
                  label: 'Vote Policies',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => VotePolicyListPage()),
                    );
                  },
                  color: purple,
                ),
                SizedBox(height: 16),
                _LongMenuButton(
                  icon: Icons.feedback,
                  label: 'Give Feedback',
                  onTap: () => Navigator.pushNamed(context, '/feedback'),
                  color: purple,
                ),
                SizedBox(height: 16),
                _LongMenuButton(
                  icon: Icons.poll,
                  label: 'Take Survey',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SurveyPage()),
                    );
                  },
                  color: purple,
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          // Quick actions (Voting/Feedback context)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => VoiceMattersPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.how_to_vote, size: 32, color: purple),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Voice Matters!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 4),
                            Text('Participate in the latest policy votes and provide feedback to help shape the future of your community.', style: TextStyle(fontSize: 13, color: Colors.black87)),
                            SizedBox(height: 8),
                            Text('Learn more →', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Election Voting Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: purple.withOpacity(0.12)),
                    ),
                    child: Icon(Icons.how_to_vote, color: purple, size: 32),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Election Voting', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Participate in the latest national and local elections.', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => VerifyIdentityPage()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Vote Now', style: TextStyle(fontWeight: FontWeight.bold, color: purple, fontSize: 16)),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward, size: 18, color: purple),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Helpdesk & FAQ Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: purple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.help_center, size: 32, color: purple),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Helpdesk & FAQ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('Get support or find answers to common questions.', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => HelpdeskFaqPage()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Go to Helpdesk & FAQ', style: TextStyle(fontWeight: FontWeight.bold, color: purple, fontSize: 16)),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward, size: 18, color: purple),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _MenuIcon({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: purple, size: 28),
          ),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart, color: purple, size: 48),
                    SizedBox(height: 16),
                    Text('Analytics Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
                    SizedBox(height: 12),
                    Text('See voting trends, participation rates, and more. (Demo content)', textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                    SizedBox(height: 24),
                    // Main analytics cards
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _AnalyticsCard(title: 'Votes Cast', value: '1,234'),
                        _AnalyticsCard(title: 'Feedbacks', value: '567'),
                        _AnalyticsCard(title: 'Active Policies', value: '8'),
                        _AnalyticsCard(title: 'Participation', value: '76%'),
                        _AnalyticsCard(title: 'Registered Users', value: '2,345'),
                        _AnalyticsCard(title: 'Avg. Feedback Score', value: '4.7'),
                        _AnalyticsCard(title: 'Policies Passed', value: '5'),
                        _AnalyticsCard(title: 'Voting Sessions', value: '12'),
                      ],
                    ),
                    SizedBox(height: 32),
                    // Pie chart section
                    Text('Voter Classification by Income Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purple)),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.deepPurple,
                              value: 40,
                              title: 'T20',
                              radius: 50,
                              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            PieChartSectionData(
                              color: Colors.purpleAccent,
                              value: 30,
                              title: 'M40',
                              radius: 50,
                              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            PieChartSectionData(
                              color: Colors.purple[200],
                              value: 20,
                              title: 'B40',
                              radius: 50,
                              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            PieChartSectionData(
                              color: Colors.grey[400],
                              value: 10,
                              title: 'Others',
                              radius: 50,
                              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PieLegend(color: Colors.deepPurple, label: 'T20'),
                        SizedBox(width: 16),
                        _PieLegend(color: Colors.purpleAccent, label: 'M40'),
                        SizedBox(width: 16),
                        _PieLegend(color: Colors.purple[200]!, label: 'B40'),
                        SizedBox(width: 16),
                        _PieLegend(color: Colors.grey[400]!, label: 'Others'),
                      ],
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  const _AnalyticsCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Container(
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
          SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}

class PolicyPage extends StatelessWidget {
  final List<String> upcomingPolicies = [
    'Digital Voting Rollout',
    'Youth Engagement Policy',
    'Green City Initiative',
    'E-Government Expansion',
    'Universal Broadband Access',
    'Renewable Energy Mandate',
  ];
  final List<String> implementedPolicies = [
    'Public Transport Subsidy',
    'Healthcare Access Reform',
    'Smart City Infrastructure',
    'Education Modernization',
    'Affordable Housing Program',
  ];
  final List<String> delayedPolicies = [
    'Water Conservation Act',
    'Urban Traffic Decongestion',
  ];
  final List<String> reconstructedPolicies = [
    'Tax Code Simplification',
    'National Cybersecurity Plan',
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
                SizedBox(height: 12),
                ...upcomingPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Upcoming', color: purple)),
                SizedBox(height: 32),
                Text('Implemented Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
                SizedBox(height: 12),
                ...implementedPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Implemented', color: Colors.green)),
                SizedBox(height: 32),
                Text('Delayed Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                SizedBox(height: 12),
                ...delayedPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Delayed', color: Colors.orange)),
                SizedBox(height: 32),
                Text('Reconstructed Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                SizedBox(height: 12),
                ...reconstructedPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Reconstructed', color: Colors.blue)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String policy;
  final String status;
  final Color color;
  const _PolicyCard({required this.policy, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.policy, color: color, size: 32),
          SizedBox(width: 16),
          Expanded(child: Text(policy, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
              SizedBox(height: 24),
              _SettingsTile(icon: Icons.person, label: 'Profile', onTap: () {}),
              _SettingsTile(icon: Icons.lock, label: 'Change Password', onTap: () {}),
              _SettingsTile(icon: Icons.notifications, label: 'Notifications', onTap: () {}),
              _SettingsTile(icon: Icons.logout, label: 'Sign Out', onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: purple, size: 26),
            SizedBox(width: 18),
            Expanded(child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}

// Long horizontal menu button widget
class _LongMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _LongMenuButton({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

// Survey Page
class SurveyPage extends StatelessWidget {
  final List<_Survey> surveys = [
    _Survey(
      title: 'Digital Voting Readiness Survey',
      description: 'Help us understand your readiness and concerns about digital voting before we roll out the new system.',
      imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=600&q=80',
      info: 'Digital voting is a new initiative to make elections more accessible. Your feedback will help us ensure a smooth rollout.',
    ),
    _Survey(
      title: 'Youth Engagement Feedback',
      description: 'Share your thoughts on how the government can better engage youth in policy-making.',
      imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
      info: 'We want to empower youth voices in shaping the future. Let us know your ideas and concerns.',
    ),
    _Survey(
      title: 'Green City Initiative Survey',
      description: 'Tell us what green initiatives you want to see in your city before we implement the Green City policy.',
      imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=600&q=80',
      info: 'Green City aims to improve urban sustainability. Your input will guide our priorities.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Government Surveys'), backgroundColor: purple),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          final survey = surveys[index];
          return Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(survey.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
                SizedBox(height: 10),
                Text(survey.description),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.poll, color: Colors.white),
                    label: Text('Participate', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SurveyDetailPage(survey: survey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SurveyDetailPage extends StatelessWidget {
  final _Survey survey;
  SurveyDetailPage({required this.survey});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text(survey.title), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Removed image
            // Info
            Text(survey.info, style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 24),
            Text('Survey Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purple)),
            SizedBox(height: 12),
            _SurveyForm(),
          ],
        ),
      ),
    );
  }
}

class _SurveyForm extends StatefulWidget {
  @override
  State<_SurveyForm> createState() => _SurveyFormState();
}

class _SurveyFormState extends State<_SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> answers = List.filled(8, null);
  String? answerText;

  final List<String> questions = [
    'How likely are you to support this policy?',
    'Do you feel informed about this policy?',
    'How important is this policy to you?',
    'Do you trust digital voting systems?',
    'Would you recommend this policy to others?',
    'How easy is it to understand the policy details?',
    'Do you believe this policy will have a positive impact?',
    'Would you participate in future government surveys?',
  ];

  final List<List<String>> options = [
    [
      'Very likely',
      'Somewhat likely',
      'Neutral',
      'Somewhat unlikely',
      'Very unlikely',
    ],
    [
      'Very informed',
      'Somewhat informed',
      'Neutral',
      'Somewhat uninformed',
      'Not informed',
    ],
    [
      'Very important',
      'Somewhat important',
      'Neutral',
      'Not very important',
      'Not important at all',
    ],
    [
      'Yes',
      'No',
      'Not sure',
    ],
    [
      'Yes',
      'No',
      'Maybe',
    ],
    [
      'Very easy',
      'Somewhat easy',
      'Neutral',
      'Somewhat difficult',
      'Very difficult',
    ],
    [
      'Strongly agree',
      'Agree',
      'Neutral',
      'Disagree',
      'Strongly disagree',
    ],
    [
      'Yes',
      'No',
      'Maybe',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < questions.length; i++) ...[
            Text('${i + 1}. ${questions[i]}', style: TextStyle(fontWeight: FontWeight.w500)),
            DropdownButtonFormField<String>(
              value: answers[i],
              items: options[i].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => answers[i] = val),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (val) => val == null ? 'Please select an answer' : null,
            ),
            SizedBox(height: 20),
          ],
          Text('Any suggestions or concerns?', style: TextStyle(fontWeight: FontWeight.w500)),
          TextFormField(
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (val) => answerText = val,
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thank you for participating in the survey!')),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Survey {
  final String title;
  final String description;
  final String imageUrl;
  final String info;
  _Survey({required this.title, required this.description, required this.imageUrl, required this.info});
}

// Vote Policy List Page
class VotePolicyListPage extends StatelessWidget {
  final List<_Policy> policies = [
    _Policy(
      title: 'Digital Voting Rollout',
      explanation: 'Introduce secure digital voting for all eligible citizens, making the voting process more accessible and efficient.',
      pros: [
        'Increases accessibility for remote and disabled voters',
        'Reduces costs and paperwork',
        'Faster vote counting and results',
        'Environmentally friendly',
      ],
      votingOpen: true,
    ),
    _Policy(
      title: 'Youth Engagement Policy',
      explanation: 'Encourage youth participation in civic activities and policy-making.',
      pros: [
        'Empowers the next generation',
        'Brings fresh perspectives',
        'Increases civic responsibility',
      ],
      votingOpen: false,
    ),
    _Policy(
      title: 'Green City Initiative',
      explanation: 'Promote sustainable urban development and green spaces.',
      pros: [
        'Improves air quality',
        'Enhances quality of life',
        'Attracts eco-conscious investment',
      ],
      votingOpen: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Vote on Policies'), backgroundColor: purple),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: policies.length,
        itemBuilder: (context, index) {
          final policy = policies[index];
          return Container(
            margin: EdgeInsets.only(bottom: 24),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(policy.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
                SizedBox(height: 10),
                Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(policy.explanation),
                SizedBox(height: 10),
                Text('Pros:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                ...policy.pros.map((pro) => Row(
                  children: [
                    Icon(Icons.check, color: purple, size: 18),
                    SizedBox(width: 8),
                    Expanded(child: Text(pro)),
                  ],
                )),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: policy.votingOpen ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        policy.votingOpen ? 'Voting Open' : 'Voting Closed',
                        style: TextStyle(
                          color: policy.votingOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      icon: Icon(Icons.how_to_vote, color: Colors.white),
                      label: Text('Vote', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: policy.votingOpen
                          ? () async {
                              final selectedVote = await showDialog<String>(
                                context: context,
                                builder: (context) => Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 220), // Make dialog box smaller
                                    child: AlertDialog(
                                      title: Center(
                                        child: Text(
                                          'Cast Your Vote',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          'Do you support this policy?',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      contentPadding: EdgeInsets.fromLTRB(18, 12, 18, 0),
                                      actionsPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      actionsAlignment: MainAxisAlignment.center,
                                      insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                      actions: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: 120),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            onPressed: () => Navigator.of(context).pop('no'),
                                            child: Text('No', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: 120),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                            ),
                                            onPressed: () => Navigator.of(context).pop('yes'),
                                            child: Text('Yes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              if (selectedVote != null) {
                                await submitPolicyVote(context, policy.title, selectedVote);
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Policy {
  final String title;
  final String explanation;
  final List<String> pros;
  final bool votingOpen;
  _Policy({required this.title, required this.explanation, required this.pros, required this.votingOpen});
}

// Voice Matters Promotion Page
class VoiceMattersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Your Voice Matters!'), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.campaign, color: purple, size: 80),
            SizedBox(height: 24),
            Text(
              'Raise Your Voice, Shape Your Future!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: purple),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Every opinion counts! By sharing your thoughts, voting on policies, and giving feedback, you help build a better community for everyone.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, color: purple, size: 40),
                SizedBox(width: 16),
                Icon(Icons.lightbulb, color: purple, size: 40),
                SizedBox(width: 16),
                Icon(Icons.public, color: purple, size: 40),
              ],
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Why Speak Up?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple),
                  ),
                  SizedBox(height: 10),
                  Text('• Influence real policy decisions\n• Ensure your needs are heard\n• Inspire others to participate\n• Strengthen democracy'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Ready to make a difference? Start by voting, giving feedback, or joining a survey today!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_forward, color: Colors.white),
              label: Text('Go to Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Personal Identity Page
class PersonalIdentityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Personal Identity'), backgroundColor: purple),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, color: purple, size: 80),
            SizedBox(height: 24),
            Text('Ali', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: purple)),
            SizedBox(height: 8),
            Text('Citizen ID: did:iota:example:123456789', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ali@gmail.com'),
                  SizedBox(height: 6),
                  Text('Phone: +60 12-345 6789'),
                  SizedBox(height: 6),
                  Text('Registered Address: 123 Main Street, Kuala Lumpur'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text('Your identity is securely managed and verified using IOTA Identity technology.', textAlign: TextAlign.center, style: TextStyle(color: purple)),
          ],
        ),
      ),
    );
  }
}

// Notifications Page
class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    'Your vote for Digital Voting Rollout has been recorded.',
    'A new policy is open for feedback: Green City Initiative.',
    'Survey: Youth Engagement Feedback is now available.',
    'Your feedback has been received. Thank you!',
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'), backgroundColor: purple),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 18),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.notifications, color: purple),
                SizedBox(width: 12),
                Expanded(child: Text(notifications[index])),
              ],
            ),
          );
        },
      ),
    );
  }
}

// About App Page
class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('About GovVote'), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.emoji_objects, color: purple, size: 80),
            SizedBox(height: 24),
            Text('Welcome to GovVote!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: purple), textAlign: TextAlign.center),
            SizedBox(height: 16),
            Text(
              'GovVote is your gateway to transparent, secure, and impactful citizen participation. Vote on policies, give feedback, and help shape the future of your community and country.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, color: purple, size: 40),
                SizedBox(width: 16),
                Icon(Icons.people_alt, color: purple, size: 40),
                SizedBox(width: 16),
                Icon(Icons.lightbulb_outline, color: purple, size: 40),
              ],
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Key Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple)),
                  SizedBox(height: 10),
                  Text('• Secure digital voting\n• Real-time feedback\n• Transparent policy updates\n• Community-driven surveys'),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text('Join GovVote and make your voice count!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// Party Voting Page
class PartyVotingPage extends StatefulWidget {
  @override
  State<PartyVotingPage> createState() => _PartyVotingPageState();
}

class _PartyVotingPageState extends State<PartyVotingPage> {
  String? selectedParty;
  final List<String> parties = [
    'Party A',
    'Party B',
    'Party C',
    'Party D',
  ];

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Vote for a Party'), backgroundColor: purple),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your preferred party:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
            SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: parties.length,
                separatorBuilder: (context, index) => SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final party = parties[index];
                  final isSelected = selectedParty == party;
                  return GestureDetector(
                    onTap: () => setState(() => selectedParty = party),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? purple.withOpacity(0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? purple : Colors.grey.shade300,
                          width: isSelected ? 2.5 : 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          party,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? purple : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                icon: Icon(Icons.how_to_vote, color: Colors.white, size: 32),
                label: Text('Submit Vote', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: selectedParty == null
                    ? null
                    : () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        try {
                          final response = await http.post(
                            Uri.parse(getBackendBaseUrl() + '/vote'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              'user_id': 'some_user', // Replace with actual user ID if available
                              'vote': selectedParty!,
                            }),
                          );
                          if (response.statusCode == 200) {
                            final data = jsonDecode(response.body);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => NotarizationReceiptPage(
                                  party: data['party'] ?? selectedParty!,
                                  receipt: data['notarization_receipt'] ?? '',
                                  message: data['message'] ?? 'Vote recorded.',
                                ),
                              ),
                            );
                          } else {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Backend error: \\${response.statusCode}')),
                            );
                          }
                        } catch (e) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text('Failed to connect to backend: \\${e}')),
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this function near the top of the file
Future<void> submitPolicyVote(BuildContext context, String selectedPolicy, String selectedVote) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    final response = await http.post(
      Uri.parse(getBackendBaseUrl() + '/policy_vote'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 'some_user', // Replace with actual user ID if available
        'policy': selectedPolicy,
        'vote': selectedVote,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => NotarizationReceiptPage(
            party: data['policy'] ?? selectedPolicy,
            receipt: data['notarization_receipt'] ?? '',
            message: data['message'] ?? 'Policy vote recorded.',
          ),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Backend error: \\${response.statusCode}')),
      );
    }
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Failed to connect to backend: \\${e}')),
    );
  }
}

// Add this widget before _DashboardScreenState
class NotarizationReceiptPage extends StatelessWidget {
  final String party;
  final String receipt;
  final String message;

  const NotarizationReceiptPage({required this.party, required this.receipt, required this.message});

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Notarization Receipt'), backgroundColor: purple),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: purple, size: 64),
              SizedBox(height: 24),
              Text('Your vote for', style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(party, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: purple)),
              SizedBox(height: 16),
              Text(message, style: TextStyle(fontSize: 16)),
              SizedBox(height: 24),
              Text('Notarization Receipt:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              SelectableText(receipt, style: TextStyle(fontSize: 16, color: Colors.black87)),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    padding: EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PieLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _PieLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
} 