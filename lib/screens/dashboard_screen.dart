import 'package:flutter/material.dart';

// Election Voting Page
class ElectionVotingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Election Voting'), backgroundColor: purple),
      body: Center(
        child: Text('Election Voting Page (to be implemented)', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

// Helpdesk & FAQ Page
class HelpdeskFaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Helpdesk & FAQ'), backgroundColor: purple),
      body: Center(
        child: Text('Helpdesk & FAQ Page (to be implemented)', style: TextStyle(fontSize: 18)),
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text('L', style: TextStyle(fontWeight: FontWeight.bold, color: purple, fontSize: 24)),
                    ),
                    Spacer(),
                    Icon(Icons.policy, color: Colors.white, size: 28),
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
                    onPressed: () {},
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
                // Carousel dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.white : Colors.white24,
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
              ],
            ),
          ),
          // Main menu horizontal bar buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
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
              child: Column(
                children: [
                  _LongMenuButton(
                    icon: Icons.how_to_vote,
                    label: 'Vote Policies',
                    onTap: () {},
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
          ),
          // Quick actions (Voting/Feedback context)
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
                          GestureDetector(
                            onTap: () {},
                            child: Text('Learn more →', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Election Voting Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ElectionVotingPage()),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: purple.withOpacity(0.12)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/5/5b/Logo_SPR_%28Malaysia%29.svg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.how_to_vote, color: purple, size: 32),
                        ),
                      ),
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Vote Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Helpdesk & FAQ Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HelpdeskFaqPage()),
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Go to Helpdesk & FAQ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                  // Example analytics cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnalyticsCard(title: 'Votes Cast', value: '1,234'),
                      _AnalyticsCard(title: 'Feedbacks', value: '567'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AnalyticsCard(title: 'Active Policies', value: '8'),
                      _AnalyticsCard(title: 'Participation', value: '76%'),
                    ],
                  ),
                ],
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
  ];
  final List<String> implementedPolicies = [
    'Public Transport Subsidy',
    'Healthcare Access Reform',
    'Smart City Infrastructure',
  ];

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
              Text('Upcoming Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
              SizedBox(height: 12),
              ...upcomingPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Upcoming', color: purple)),
              SizedBox(height: 32),
              Text('Implemented Policies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: purple)),
              SizedBox(height: 12),
              ...implementedPolicies.map((policy) => _PolicyCard(policy: policy, status: 'Implemented', color: Colors.green)),
            ],
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
  @override
  Widget build(BuildContext context) {
    final purple = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(title: Text('Take Survey'), backgroundColor: purple),
      body: Center(
        child: Text('Survey Page (to be implemented)', style: TextStyle(fontSize: 18)),
      ),
    );
  }
} 