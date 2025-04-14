import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empower_her/views/courses_screens/courses_list_screen.dart';
import 'package:empower_her/views/financial_goals/financial_savings.dart';
import 'package:empower_her/views/microearnings_screen/micro_earnings_screen.dart';
import 'package:empower_her/views/skills_extraction_screen/skills_extraction_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../components/app_drawer.dart';
import '../../providers/user_provider.dart';
import '../settings_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DashboardScreen();
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int>? courseStats;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  void loadStats() async {
    final stats = await fetchCourseStats();
    setState(() {
      courseStats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    // studentpr
    final userProvider = Provider.of<EmpowerHerUserProvider>(context);
    final username = userProvider.currentUser?.name ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(currentRoute: '/home'),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Header
              _buildWelcomeHeader(username),
              const SizedBox(height: 24),

              // 2. Learning Path Progress
              _buildLearningPathCard(),
              const SizedBox(height: 16),

              // 3. Quick Actions Row
              _buildQuickActionsRow(context),
              const SizedBox(height: 16),

              // 4. Courses Summary
              _buildCoursesSection(),
              const SizedBox(height: 16),

              // 5. Financial Goals
              _buildFinancialGoals(),
              const SizedBox(height: 16),

              // 6. Job Postings
              _buildJobPostings(),

              // 7. Daily Affirmation (from reference)
              _buildDailyAffirmation(),
            ],
          ),
        ),
      ),
    );
  }

  // ============= Widget Components =============
  Widget _buildWelcomeHeader(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $username!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6A3EA1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ready to empower yourself today?',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPathCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: const Color(0xFF6A3EA1)),
                const SizedBox(width: 8),
                Text(
                  'Learning Path',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearPercentIndicator(
              percent: 0.65,
              lineHeight: 12,
              progressColor: const Color(0xFF6A3EA1),
              backgroundColor: Colors.grey[200],
              barRadius: const Radius.circular(6),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete "Advanced Stitching" to reach 80%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.camera_alt, 'Scan Skills', onTap: () {
          // Navigate to scan skills screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SkillExtractionPage()));
        }),
        _buildActionButton(Icons.work, 'Earn Now', onTap: () {
          // Navigate to earn now screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MicroEarningsPage()));
        }),
        _buildActionButton(Icons.school, 'Learn', onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CourseListScreen()));
        }),
        _buildActionButton(Icons.people, 'Connect', onTap: () {}),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6A3EA1)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBox('${courseStats!['enrolled']}', 'Enrolled'),
                _buildStatBox('${courseStats!['completed']}', 'Completed'),
                _buildStatBox('${courseStats!['new']}', 'New'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCourseCard('Embroidery Basics'),
                  _buildCourseCard('Machine Stitching'),
                  _buildCourseCard('Fabric Dyeing'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, int>> fetchCourseStats() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('courses').get();

    int totalEnrolled = 0;
    int totalCompleted = 0;
    int newlyAdded = 0;
    final now = DateTime.now();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      totalEnrolled += (data['enrolledUsers'] as List?)?.length ?? 0;
      totalCompleted += (data['completedUsers'] as List?)?.length ?? 0;

      // Check for new courses (created in the last 7 days)
      final timestamp = data['createdAt'];
      if (timestamp != null) {
        final created = (timestamp as Timestamp).toDate();
        if (now.difference(created).inDays <= 7) {
          newlyAdded += 1;
        }
      }
    }

    return {
      'enrolled': totalEnrolled,
      'completed': totalCompleted,
      'new': newlyAdded,
    };
  }

  Widget _buildStatBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEFE5FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6A3EA1),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCourseCard(String title) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrV6s3JRQIjHN2yll0zMbosbqTyuzTTxUHZg&s',
              height: 60,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 12),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialGoals() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavingsGoalsScreen()),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.savings, color: const Color(0xFF6A3EA1)),
                  const SizedBox(width: 8),
                  Text(
                    'Financial Goals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildGoalItem('Sewing Machine', 8500, 15000),
              const SizedBox(height: 12),
              _buildGoalItem('Workshop Setup', 2500, 10000),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalItem(String goalName, int current, int target) {
    final progress = current / target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(goalName, style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                percent: progress,
                lineHeight: 8,
                progressColor: const Color(0xFF6A3EA1),
                backgroundColor: Colors.grey[200],
                barRadius: const Radius.circular(4),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '₹${current.toStringAsFixed(0)}/₹${target.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJobPostings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Job Postings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: const Text('12 new',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: const Color(0xFF6A3EA1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildJobItem('Embroidery Artist', '₹250/item • Remote'),
            _buildJobItem('Tailoring Assistant', '₹15k/month • Local'),
          ],
        ),
      ),
    );
  }

  Widget _buildJobItem(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.work, color: Color(0xFF6A3EA1)),
      title: Text(title, style: TextStyle()),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {}, // Add navigation
    );
  }

  Widget _buildDailyAffirmation() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Affirmation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6A3EA1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"Your skills today will create opportunities tomorrow."',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- EmpowerHer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
