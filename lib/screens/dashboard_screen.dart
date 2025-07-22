import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Added for jsonDecode
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fl_chart/fl_chart.dart';
import '../api_service.dart';
import 'dart:ui';
import 'profile_screen.dart';
import 'dart:async';
import 'package:share_plus/share_plus.dart';

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
  final List<String> regions = [
    'Kuala Lumpur, Federal Territory',
    'Selangor',
    'Penang',
    'Johor',
    'Sabah',
    'Sarawak',
  ];
  final DateTime votingClose = DateTime(2024, 7, 1, 23, 59, 59);

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    // Use a ValueNotifier for region selection in a StatelessWidget
    final ValueNotifier<String> selectedRegion = ValueNotifier<String>(regions[0]);
    return Scaffold(
      appBar: AppBar(title: Text('Election Voting'), backgroundColor: purple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Election Info Card
            _ElectionInfoCard(
              electionName: 'National Election 2024',
              electionType: 'National',
              electionDate: '1 July 2024',
              votingClose: votingClose,
              onLearnMore: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Election Details'),
                    content: Text('This is the National Election 2024. All verified citizens are eligible to vote. Voting closes on 1 July 2024 at 11:59 PM.'),
                    actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close'))],
                  ),
                );
              },
            ),
            SizedBox(height: 18),
            // Security & Trust Info Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green[200]!, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, color: Colors.green[700], size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your vote is anonymous and secure',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            // Live Turnout Stats
            _LiveTurnoutStatsWidget(),
            // Results Preview (after voting closes)
            if (DateTime.now().isAfter(votingClose))
              _ResultsPreviewWidget(),
            Container(
              decoration: BoxDecoration(
                color: purple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: purple.withOpacity(0.18),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48,
                child: Icon(Icons.how_to_vote, color: Colors.white, size: 56),
              ),
            ),
            SizedBox(height: 28),
            Text('Participate in the Election!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: purple)),
            SizedBox(height: 12),
            Text(
              'Your vote is your voice. Join the latest national and local elections to make a real impact on your community and country.',
              style: TextStyle(fontSize: 17, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28),
            // Region/Constituency Selector
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Select your region/constituency:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: purple)),
            ),
            SizedBox(height: 10),
            ValueListenableBuilder<String>(
              valueListenable: selectedRegion,
              builder: (context, value, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: purple.withOpacity(0.18)),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                    ),
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, color: purple),
                      items: regions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => selectedRegion.value = val!,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('You are voting in: $value', style: TextStyle(fontSize: 15, color: purple, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Why your vote matters (Voter Engagement)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                border: Border(left: BorderSide(color: purple, width: 7)),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.campaign, color: purple, size: 28),
                      SizedBox(width: 10),
                      Text('Why your vote matters', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: purple)),
                    ],
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.gavel, color: purple, size: 32),
                          SizedBox(height: 4),
                          Text('Influence', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.favorite, color: purple, size: 32),
                          SizedBox(height: 4),
                          Text('Support', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.emoji_people, color: purple, size: 32),
                          SizedBox(height: 4),
                          Text('Civic Duty', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.public, color: purple, size: 32),
                          SizedBox(height: 4),
                          Text('Shape Future', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  // Placeholder for infographic or video
                  GestureDetector(
                    onTap: () {
                      // TODO: Open video or infographic modal
                    },
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_circle_fill, color: purple, size: 48),
                            SizedBox(width: 12),
                            Text('Watch: Why voting matters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: purple)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Your vote is powerful. It helps shape the future of your community and country. Make it count!', style: TextStyle(fontSize: 15, color: Colors.black87)),
                ],
              ),
            ),
            // Important Notice
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 2))],
                border: Border(left: BorderSide(color: Colors.red, width: 7)),
              ),
              padding: EdgeInsets.fromLTRB(18, 16, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.w700, fontSize: 15),
                        children: [
                          TextSpan(text: 'Important: '),
                          TextSpan(
                            text: 'Each citizen can only vote once per election. ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: 'Please make your selection carefully. Duplicate votes will not be counted.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action Button
            SizedBox(
              width: double.infinity,
              height: 62,
              child: ElevatedButton.icon(
                icon: Icon(Icons.how_to_vote, color: Colors.white, size: 30),
                label: Text('Go to Voting Page', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 10,
                  shadowColor: purple.withOpacity(0.18),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PartyVotingPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ElectionInfoCard extends StatefulWidget {
  final String electionName;
  final String electionType;
  final String electionDate;
  final DateTime votingClose;
  final VoidCallback onLearnMore;
  const _ElectionInfoCard({
    required this.electionName,
    required this.electionType,
    required this.electionDate,
    required this.votingClose,
    required this.onLearnMore,
  });
  @override
  State<_ElectionInfoCard> createState() => _ElectionInfoCardState();
}

class _ElectionInfoCardState extends State<_ElectionInfoCard> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.votingClose.difference(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _remaining = widget.votingClose.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _countdown {
    if (_remaining.isNegative) return 'Voting closed';
    final d = _remaining.inDays;
    final h = _remaining.inHours % 24;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    if (d > 0) return '$d days $h h $m m';
    if (h > 0) return '$h h $m m $s s';
    if (m > 0) return '$m m $s s';
    return '$s seconds';
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    final isClosed = _remaining.isNegative;
    return Container(
      margin: EdgeInsets.only(bottom: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 8))],
        border: Border(left: BorderSide(color: purple, width: 6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.how_to_vote, color: purple, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(widget.electionName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: purple)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: purple, size: 18),
                      SizedBox(width: 4),
                      Text('National', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.calendar_today, color: purple, size: 18),
                SizedBox(width: 6),
                Text('Date: ${widget.electionDate}', style: TextStyle(fontSize: 15)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isClosed ? Colors.red[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: isClosed ? Colors.red : Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text(
                        isClosed ? 'Voting closed' : _countdown,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isClosed ? Colors.red : Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onLearnMore,
                icon: Icon(Icons.info_outline, color: purple, size: 18),
                label: Text('Learn more', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
              ),
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
                              value: 30,
                              title: 'B40',
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
                      ],
                    ),
                    SizedBox(height: 24),
                    // Election Results & Analysis Card (after analytics)
                    _ElectionResultsAnalysisCard(),
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
              _SettingsTile(icon: Icons.person, label: 'Profile', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              }),
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
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.8, end: 1.0),
                                    duration: Duration(milliseconds: 220),
                                    curve: Curves.easeOutBack,
                                    builder: (context, scale, child) => Transform.scale(
                                      scale: scale,
                                      child: child,
                                    ),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 160), // Even smaller
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 18,
                                        borderRadius: BorderRadius.circular(32),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(32),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.92),
                                                borderRadius: BorderRadius.circular(32),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 32,
                                                    offset: Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.how_to_vote, color: Theme.of(context).primaryColor, size: 32),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Cast Your Vote',
                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Do you support this policy?',
                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    SizedBox(height: 14),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Theme.of(context).primaryColor,
                                                              foregroundColor: Colors.white,
                                                              shape: StadiumBorder(),
                                                              padding: EdgeInsets.symmetric(vertical: 8),
                                                              elevation: 2,
                                                            ),
                                                            onPressed: () => Navigator.of(context).pop('no'),
                                                            child: Text('No', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Theme.of(context).primaryColor,
                                                              foregroundColor: Colors.white,
                                                              shape: StadiumBorder(),
                                                              padding: EdgeInsets.symmetric(vertical: 8),
                                                              elevation: 2,
                                                            ),
                                                            onPressed: () => Navigator.of(context).pop('yes'),
                                                            child: Text('Yes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              if (selectedVote != null) {
                                final api = ApiService();
                                final data = await api.submitPolicyVote('some_user', policy.title, selectedVote);
                                final message = (data['message'] ?? '').toString().toLowerCase();
                                if (data['success'] == true || message.contains('recorded successfully')) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => NotarizationReceiptPage(
                                        party: policy.title,
                                        receipt: data['notarization_receipt'] ?? '',
                                        message: data['message'] ?? 'Policy vote recorded.',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Backend error: ${data['message']}')),
                                  );
                                }
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
  final List<_PartyInfo> parties = [
    _PartyInfo(
      name: 'Party A',
      logo: Icons.flag,
      bio: 'Progressive party focused on technology and education.',
      policies: ['Universal internet access', 'STEM education', 'Green energy'],
      manifesto: 'Party A believes in a tech-driven future, investing in education, and sustainable energy for all.',
    ),
    _PartyInfo(
      name: 'Party B',
      logo: Icons.eco,
      bio: 'Environmental party with a focus on sustainability.',
      policies: ['Clean water', 'Forest protection', 'Renewable energy'],
      manifesto: 'Party B is committed to protecting the environment and ensuring a green future for generations to come.',
    ),
    _PartyInfo(
      name: 'Party C',
      logo: Icons.people,
      bio: 'Social party prioritizing healthcare and welfare.',
      policies: ['Universal healthcare', 'Affordable housing', 'Social safety nets'],
      manifesto: 'Party C stands for equal opportunity, healthcare for all, and strong social support systems.',
    ),
    _PartyInfo(
      name: 'Party D',
      logo: Icons.business,
      bio: 'Business-oriented party supporting entrepreneurship.',
      policies: ['Small business grants', 'Tax incentives', 'Job creation'],
      manifesto: 'Party D empowers entrepreneurs, supports job growth, and fosters a thriving economy.',
    ),
  ];
  final Set<String> compareSelection = {};

  void _toggleCompare(String party) {
    setState(() {
      if (compareSelection.contains(party)) {
        compareSelection.remove(party);
      } else if (compareSelection.length < 2) {
        compareSelection.add(party);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Vote for a Party'), backgroundColor: purple),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            Icon(Icons.how_to_vote, color: purple, size: 48),
            SizedBox(height: 12),
            Text('Vote for a Party', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: purple)),
            SizedBox(height: 8),
            Text('Select your preferred party:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: purple)),
            SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: parties.map((party) => _PartyCard(
                  party: party,
                  selected: selectedParty == party.name,
                  onSelect: () => setState(() => selectedParty = party.name),
                  compareSelected: compareSelection.contains(party.name),
                  onCompare: () => _toggleCompare(party.name),
                )).toList(),
              ),
            ),
            if (compareSelection.length == 2)
              _PartyCompareCard(
                partyA: parties.firstWhere((p) => p.name == compareSelection.elementAt(0)),
                partyB: parties.firstWhere((p) => p.name == compareSelection.elementAt(1)),
              ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: Icon(Icons.how_to_vote, color: Colors.white, size: 28),
                label: Text('Submit Vote', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedParty == null ? Colors.grey[300] : purple,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: selectedParty == null ? 0 : 8,
                  shadowColor: purple.withOpacity(0.18),
                ),
                onPressed: selectedParty == null ? null : () async {
                  final region = 'Kuala Lumpur, Federal Territory'; // Replace with actual selected region if available
                  final confirmed = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 340),
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 14,
                          titlePadding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 0),
                          title: Column(
                            children: [
                              Icon(Icons.how_to_vote, color: purple, size: 34),
                              SizedBox(height: 8),
                              Text('Review Your Vote', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black87, fontSize: 16),
                                  children: [
                                    TextSpan(text: 'You are about to vote for:\n'),
                                    TextSpan(text: ' 24selectedParty', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                                    TextSpan(text: ' in '),
                                    TextSpan(text: region, style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Divider(),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Once you confirm, your vote will be permanently recorded and cannot be changed.',
                                        style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actionsPadding: EdgeInsets.fromLTRB(16, 8, 16, 20),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Edit', style: TextStyle(fontSize: 15)),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      minimumSize: Size(0, 48),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 18),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Confirm', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: purple,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      minimumSize: Size(0, 48),
                                      elevation: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  if (confirmed == true) {
                    // Show animated confirmation
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => _VoteConfirmationDialog(),
                    );
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    try {
                      final api = ApiService();
                      final data = await api.submitVote('some_user', selectedParty!, selectedParty!, 'did:example');
                      final message = (data['message'] ?? '').toString().toLowerCase();
                      if (data['success'] == true || message.contains('recorded successfully')) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => NotarizationReceiptPage(
                              party: selectedParty!,
                              receipt: data['notarization_receipt'] ?? '',
                              message: data['message'] ?? 'Vote recorded.',
                            ),
                          ),
                        );
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('Backend error: ${data['message']}')),
                        );
                      }
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Failed to connect to backend: $e')),
                      );
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PartyInfo {
  final String name;
  final IconData logo;
  final String bio;
  final List<String> policies;
  final String manifesto;
  _PartyInfo({required this.name, required this.logo, required this.bio, required this.policies, required this.manifesto});
}

class _PartyCard extends StatefulWidget {
  final _PartyInfo party;
  final bool selected;
  final VoidCallback onSelect;
  final bool compareSelected;
  final VoidCallback onCompare;
  const _PartyCard({required this.party, required this.selected, required this.onSelect, required this.compareSelected, required this.onCompare});
  @override
  State<_PartyCard> createState() => _PartyCardState();
}

class _PartyCardState extends State<_PartyCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return AnimatedContainer(
      duration: Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: widget.selected ? purple : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        border: Border.all(
          color: widget.selected ? purple : Colors.grey.shade300,
          width: widget.selected ? 2.5 : 1.2,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: widget.onSelect,
            leading: Icon(widget.party.logo, color: widget.selected ? Colors.white : purple, size: 32),
            title: Text(
              widget.party.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.selected ? Colors.white : Colors.black87,
              ),
            ),
            subtitle: Text(widget.party.bio, style: TextStyle(color: widget.selected ? Colors.white70 : Colors.black54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more, color: widget.selected ? Colors.white : purple),
                  onPressed: () => setState(() => expanded = !expanded),
                ),
                IconButton(
                  icon: Icon(Icons.compare_arrows, color: widget.compareSelected ? purple : Colors.grey),
                  tooltip: widget.compareSelected ? 'Remove from compare' : 'Compare',
                  onPressed: widget.onCompare,
                ),
              ],
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Key Policies:', style: TextStyle(fontWeight: FontWeight.bold, color: widget.selected ? Colors.white : purple)),
                  SizedBox(height: 6),
                  ...widget.party.policies.map((p) => Row(
                    children: [
                      Icon(Icons.check, color: widget.selected ? Colors.white : purple, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text(p, style: TextStyle(color: widget.selected ? Colors.white : Colors.black87))),
                    ],
                  )),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('${widget.party.name} Manifesto'),
                          content: Text(widget.party.manifesto),
                          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Close'))],
                        ),
                      ),
                      child: Text('Read more', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PartyCompareCard extends StatelessWidget {
  final _PartyInfo partyA;
  final _PartyInfo partyB;
  const _PartyCompareCard({required this.partyA, required this.partyB});
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Card(
      margin: EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text('Compare Parties', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple)),
            SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _compareColumn(partyA, purple)),
                SizedBox(width: 18),
                Expanded(child: _compareColumn(partyB, purple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _compareColumn(_PartyInfo party, Color purple) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(party.logo, color: purple, size: 32),
        SizedBox(height: 6),
        Text(party.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 6),
        Text(party.bio, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.black54)),
        SizedBox(height: 8),
        Text('Key Policies:', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
        ...party.policies.map((p) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: purple, size: 16),
            SizedBox(width: 4),
            Flexible(child: Text(p, style: TextStyle(fontSize: 13))),
          ],
        )),
      ],
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
        SnackBar(content: Text('Backend error: ${response.statusCode}')),
      );
    }
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Failed to connect to backend: $e')),
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
              // Blockchain/Notarization Status Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                margin: EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[200]!, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, color: Colors.green[700], size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your vote is now recorded on the IOTA ledger',
                        style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
              SizedBox(height: 32),
              // Share Badge Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: purple.withOpacity(0.18)),
                  boxShadow: [
                    BoxShadow(
                      color: purple.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, color: purple, size: 32),
                        SizedBox(width: 10),
                        Text('I Voted Nationally!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Proud voter in the National Election 2024', style: TextStyle(fontSize: 15, color: purple)),
                    SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.share, color: purple),
                        label: Text('Share your badge', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: purple),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          // Import share_plus at the top: import 'package:share_plus/share_plus.dart';
                          await Share.share('I just voted in the National Election 2024! 🇲🇾 #IVoted #GovVote');
                        },
                      ),
                    ),
                  ],
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

// Add the animated confirmation dialog:
class _VoteConfirmationDialog extends StatefulWidget {
  @override
  State<_VoteConfirmationDialog> createState() => _VoteConfirmationDialogState();
}

class _VoteConfirmationDialogState extends State<_VoteConfirmationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _controller.forward();
    Future.delayed(Duration(milliseconds: 1200), () => Navigator.of(context).pop());
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Center(
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 8))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: purple, size: 64),
              SizedBox(height: 18),
              Text('Vote Submitted!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: purple)),
              SizedBox(height: 8),
              Text('Thank you for voting.', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this widget at the end of the file
class _PostVoteFeedbackDialog extends StatefulWidget {
  @override
  State<_PostVoteFeedbackDialog> createState() => _PostVoteFeedbackDialogState();
}

class _PostVoteFeedbackDialogState extends State<_PostVoteFeedbackDialog> {
  int? selected;
  final emojis = ['😡', '😕', '😐', '🙂', '😍'];
  final labels = ['Terrible', 'Bad', 'Okay', 'Good', 'Great!'];
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Column(
        children: [
          Icon(Icons.feedback, color: purple, size: 32),
          SizedBox(height: 8),
          Text('How was your voting experience?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      content: submitted
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 36),
                SizedBox(height: 10),
                Text('Thank you for your feedback!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(emojis.length, (i) => GestureDetector(
                    onTap: () => setState(() => selected = i),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 180),
                      padding: EdgeInsets.all(selected == i ? 8 : 4),
                      decoration: BoxDecoration(
                        color: selected == i ? purple.withOpacity(0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: selected == i ? Border.all(color: purple, width: 2) : null,
                      ),
                      child: Text(emojis[i], style: TextStyle(fontSize: 32)),
                    ),
                  )),
                ),
                SizedBox(height: 10),
                if (selected != null)
                  Text(labels[selected!], style: TextStyle(fontWeight: FontWeight.w500, color: purple)),
              ],
            ),
      actions: [
        if (!submitted)
          TextButton(
            onPressed: selected == null
                ? null
                : () {
                    setState(() => submitted = true);
                    // TODO: Send/store feedback
                    print('User feedback:  {labels[selected!]}');
                    Future.delayed(Duration(milliseconds: 900), () => Navigator.of(context).pop());
                  },
            child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
          ),
        if (submitted)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
          ),
      ],
    );
  }
}

// Add this widget at the end of the file
class _LiveTurnoutStatsWidget extends StatefulWidget {
  @override
  State<_LiveTurnoutStatsWidget> createState() => _LiveTurnoutStatsWidgetState();
}

class _LiveTurnoutStatsWidgetState extends State<_LiveTurnoutStatsWidget> {
  int? voted;
  int? eligible;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() { loading = true; error = false; });
    try {
      final api = ApiService();
      final data = await api.getTurnoutStats();
      setState(() {
        voted = data['voted'] ?? 0;
        eligible = data['eligible'] ?? 1;
        loading = false;
      });
    } catch (e) {
      setState(() { error = true; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    if (loading) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: purple)),
            SizedBox(width: 10),
            Text('Loading turnout stats...', style: TextStyle(color: purple)),
          ],
        ),
      );
    }
    if (error || voted == null || eligible == null) {
      return SizedBox.shrink();
    }
    final percent = (voted! / eligible!).clamp(0.0, 1.0);
    final percentText = (percent * 100).toStringAsFixed(1);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: Colors.blue[700], size: 22),
              SizedBox(width: 10),
              Text('$percentText% of eligible voters have voted so far.', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.blue[100],
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
} 

// Add this widget at the end of the file
class _ResultsPreviewWidget extends StatefulWidget {
  @override
  State<_ResultsPreviewWidget> createState() => _ResultsPreviewWidgetState();
}

class _ResultsPreviewWidgetState extends State<_ResultsPreviewWidget> {
  Map<String, dynamic>? results;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() { loading = true; error = false; });
    try {
      final api = ApiService();
      final data = await api.getElectionResults();
      setState(() {
        results = data;
        loading = false;
      });
    } catch (e) {
      setState(() { error = true; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    if (loading) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: purple)),
            SizedBox(width: 10),
            Text('Loading results...', style: TextStyle(color: purple)),
          ],
        ),
      );
    }
    if (error || results == null || results!.isEmpty) {
      return SizedBox.shrink();
    }
    final totalVotes = results!.values.fold<int>(0, (a, b) => a + (b as int));
    final colors = [
      Colors.deepPurple,
      Colors.purpleAccent,
      Colors.purple[200]!,
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.red[400]!,
      Colors.grey[400]!,
    ];
    final partyNames = results!.keys.toList();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow[200]!, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: Colors.orange[700], size: 22),
              SizedBox(width: 10),
              Text('Results Preview', style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sections: [
                  for (int i = 0; i < partyNames.length; i++)
                    PieChartSectionData(
                      color: colors[i % colors.length],
                      value: (results![partyNames[i]] as int).toDouble(),
                      title: partyNames[i],
                      radius: 50,
                      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          SizedBox(height: 12),
          // Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              for (int i = 0; i < partyNames.length; i++)
                _PieLegend(color: colors[i % colors.length], label: partyNames[i]),
            ],
          ),
          SizedBox(height: 10),
          Text('Total votes: $totalVotes', style: TextStyle(fontSize: 14, color: Colors.orange[900], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  } 
}

// Add this widget at the end of the file
class _ElectionResultsAnalysisCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
        border: Border(left: BorderSide(color: purple, width: 7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.insights, color: purple, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Election Results & Analysis',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: purple),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'After the election concludes, you will be able to view detailed results and analysis here. This includes vote breakdowns, turnout trends, and insights into how different groups participated. Stay tuned for a comprehensive post-election report!',
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}