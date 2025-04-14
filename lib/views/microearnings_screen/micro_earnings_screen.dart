import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MicroEarningsPage extends StatefulWidget {
  const MicroEarningsPage({Key? key}) : super(key: key);

  @override
  State<MicroEarningsPage> createState() => _MicroEarningsPageState();
}

class _MicroEarningsPageState extends State<MicroEarningsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _hasActiveTasks = true; // Toggle this for empty state testing

  // Filter and sort state
  String _selectedSkillFilter = "All Skills";
  String _selectedSort = "Deadline";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _hasActiveTasks ? _buildMicrotasksTab() : _buildEmptyState(),
                  _buildCommissionsTab(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "₹1,250 Earned",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A3EA1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "This month",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Withdrawal logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A3EA1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Withdraw"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Monthly Goal",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "₹2,000/₹5,000",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearPercentIndicator(
                lineHeight: 10.0,
                percent: 0.4,
                backgroundColor: Colors.grey[200],
                progressColor: const Color(0xFF6A3EA1),
                barRadius: const Radius.circular(5),
                animation: true,
                animationDuration: 1000,
              ),
              const SizedBox(height: 4),
              Text(
                "Keep going! 40% to your goal.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF6A3EA1),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF6A3EA1),
        tabs: const [Tab(text: "Microtasks"), Tab(text: "Commissions")],
      ),
    );
  }

  Widget _buildMicrotasksTab() {
    return Column(
      children: [
        _buildFilterSort(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMicrotaskCard(
                title: "Make 5 Diwali Cards",
                description:
                    "Create beautiful handmade cards for Diwali festival",
                sponsor: "Craft India NGO",
                skillRequired: "Art & Craft",
                skillLevel: "Level 2",
                reward: 200,
                progress: 3,
                total: 5,
                deadline: DateTime.now().add(const Duration(days: 3)),
                isUrgent: true,
              ),
              const SizedBox(height: 16),
              _buildMicrotaskCard(
                title: "Stitch 3 Blouse Pieces",
                description: "Stitch traditional blouse pieces with embroidery",
                sponsor: "Women Empowerment Trust",
                skillRequired: "Sewing",
                skillLevel: "Level 3",
                reward: 350,
                progress: 1,
                total: 3,
                deadline: DateTime.now().add(const Duration(days: 7)),
                isUrgent: false,
              ),
              const SizedBox(height: 16),
              _buildMicrotaskCard(
                title: "Create Digital Flyer",
                description: "Design a simple digital flyer for local event",
                sponsor: "TechSkills Foundation",
                skillRequired: "Digital Literacy",
                skillLevel: "Level 1",
                reward: 150,
                progress: 0,
                total: 1,
                deadline: DateTime.now().add(const Duration(days: 5)),
                isUrgent: false,
              ),
              const SizedBox(height: 16),
              _buildLeaderboard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSort() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Filter by",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              value: _selectedSkillFilter,
              items: ["All Skills", "Art & Craft", "Sewing", "Digital Literacy"]
                  .map(
                    (skill) =>
                        DropdownMenuItem(value: skill, child: Text(skill)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkillFilter = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Sort by",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              value: _selectedSort,
              items: ["Reward", "Deadline", "Skill Level"]
                  .map(
                    (sort) => DropdownMenuItem(value: sort, child: Text(sort)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicrotaskCard({
    required String title,
    required String description,
    required String sponsor,
    required String skillRequired,
    required String skillLevel,
    required int reward,
    required int progress,
    required int total,
    required DateTime deadline,
    required bool isUrgent,
  }) {
    final bool isInProgress = progress > 0;
    final DateFormat formatter = DateFormat('MMM dd, yyyy');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE5FF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 16, color: Color(0xFF6A3EA1)),
                const SizedBox(width: 4),
                Text(
                  "Sponsored by $sponsor",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A3EA1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A3EA1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "Earn ₹$reward",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE5FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.school,
                            size: 14,
                            color: Color(0xFF6A3EA1),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$skillRequired → $skillLevel",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6A3EA1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? const Color(0xFFFFE5E5)
                            : const Color(0xFFE5F6FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color:
                                isUrgent ? Colors.red : const Color(0xFF0078D4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(deadline),
                            style: TextStyle(
                              fontSize: 12,
                              color: isUrgent
                                  ? Colors.red
                                  : const Color(0xFF0078D4),
                              fontWeight: isUrgent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$progress/$total completed",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (progress > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Fast Earner",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0078D4),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: progress / total,
                      backgroundColor: Colors.grey[200],
                      progressColor: const Color(0xFF6A3EA1),
                      barRadius: const Radius.circular(4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Task action logic
                      _showTaskSubmissionModal(context, title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3EA1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(isInProgress ? "Continue Task" : "Start Task"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Trending in West Bengal",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTrendingCommissionCard(
                title: "Handmade Rakhi Sets",
                price: 50,
                totalNeeded: 100,
                image: "assets/rakhi.jpg",
              ),
              const SizedBox(width: 12),
              _buildTrendingCommissionCard(
                title: "Jute Bags",
                price: 120,
                totalNeeded: 50,
                image: "assets/jute_bag.jpg",
              ),
              const SizedBox(width: 12),
              _buildTrendingCommissionCard(
                title: "Embroidered Handkerchiefs",
                price: 80,
                totalNeeded: 75,
                image: "assets/handkerchief.jpg",
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "All Commissions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildCommissionCard(
          title: "Handmade Rakhi Sets",
          description:
              "Create beautiful handmade rakhis for the upcoming festival",
          price: 50,
          totalNeeded: 100,
          deadline: DateTime.now().add(const Duration(days: 14)),
          image: "assets/rakhi.jpg",
        ),
        const SizedBox(height: 16),
        _buildCommissionCard(
          title: "Jute Bags",
          description: "Eco-friendly jute bags with simple designs",
          price: 120,
          totalNeeded: 50,
          deadline: DateTime.now().add(const Duration(days: 21)),
          image: "assets/jute_bag.jpg",
        ),
        const SizedBox(height: 16),
        _buildCommissionCard(
          title: "Embroidered Handkerchiefs",
          description: "Cotton handkerchiefs with simple embroidery patterns",
          price: 80,
          totalNeeded: 75,
          deadline: DateTime.now().add(const Duration(days: 10)),
          image: "assets/handkerchief.jpg",
        ),
      ],
    );
  }

  Widget _buildTrendingCommissionCard({
    required String title,
    required int price,
    required int totalNeeded,
    required String image,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "₹$price per piece",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A3EA1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Need: $totalNeeded pieces",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionCard({
    required String title,
    required String description,
    required int price,
    required int totalNeeded,
    required DateTime deadline,
    required String image,
  }) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  image,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFE5FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "₹$price per piece",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6A3EA1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5F6FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Need: $totalNeeded",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0078D4),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Deadline: ${formatter.format(deadline)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F6FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 12, color: Color(0xFF0078D4)),
                          SizedBox(width: 2),
                          Text(
                            "Quality Star",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF0078D4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply to fulfill logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3EA1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Apply to Fulfill"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/empty_tasks.png',
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.assignment_outlined,
                  size: 100,
                  color: Colors.grey[400],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "No tasks yet!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Complete a course to unlock opportunities.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to learning paths
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A3EA1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Explore Learning Paths"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFFFD700)),
              SizedBox(width: 8),
              Text(
                "Top 5 Earners This Week",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLeaderboardItem(
            name: "Priya S.",
            earnings: 1850,
            position: 1,
            avatarUrl: "assets/avatar1.jpg",
          ),
          const Divider(),
          _buildLeaderboardItem(
            name: "Meena R.",
            earnings: 1650,
            position: 2,
            avatarUrl: "assets/avatar2.jpg",
          ),
          const Divider(),
          _buildLeaderboardItem(
            name: "Lakshmi T.",
            earnings: 1450,
            position: 3,
            avatarUrl: "assets/avatar3.jpg",
          ),
          const Divider(),
          _buildLeaderboardItem(
            name: "Anjali P.",
            earnings: 1250,
            position: 4,
            avatarUrl: "assets/avatar4.jpg",
          ),
          const Divider(),
          _buildLeaderboardItem(
            name: "Sunita K.",
            earnings: 1100,
            position: 5,
            avatarUrl: "assets/avatar5.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem({
    required String name,
    required int earnings,
    required int position,
    required String avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$position.",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(avatarUrl),
            onBackgroundImageError: (exception, stackTrace) {},
            child: avatarUrl.isEmpty
                ? Text(
                    name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Earned ₹$earnings this week",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  position <= 3 ? const Color(0xFFFFE5CC) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                if (position == 1)
                  const Icon(
                    Icons.workspace_premium,
                    size: 14,
                    color: Color(0xFFFF8C00),
                  ),
                if (position <= 3) const SizedBox(width: 4),
                if (position <= 3)
                  Text(
                    position == 1
                        ? "Top Earner"
                        : position == 2
                            ? "Rising Star"
                            : "Consistent",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF8C00),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Open AI chatbot
            },
            icon: const Icon(Icons.support_agent),
            label: const Text("Ask Didi for help"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEFE5FF),
              foregroundColor: const Color(0xFF6A3EA1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Open financial literacy guide
            },
            icon: const Icon(Icons.account_balance_wallet),
            label:
                const Text("How to withdraw?", style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  void _showTaskSubmissionModal(BuildContext context, String taskTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Submit Task: $taskTitle",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Step 1: Upload a photo of your completed work",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Image picker logic
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tap to upload photo",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Step 2: Add a description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Describe your work...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // Voice to text logic
                          },
                          icon: const Icon(Icons.mic),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCelebrationPopup(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A3EA1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Submit for Approval"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          // Voice guide logic
                        },
                        icon: const Icon(Icons.volume_up),
                        label: const Text("Listen to voice guide"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCelebrationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.celebration,
                  size: 60,
                  color: Color(0xFF6A3EA1),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You earned ₹200! 🎉",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your submission has been approved. Keep up the great work!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A3EA1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
