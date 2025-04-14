import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class EmpowerHerUser {
  final String id;
  final String name;
  final int age;
  final String region;
  final String language;
  final bool isMentor;
  final String phone;
  final String email;
  final List<String> skills;
  final String learningLevel;
  final String currentGoal;
  final double goalProgress;
  final String preferredJobType;
  final List<String> categories;
  final DateTime joinedAt;
  final String avatarUrl;
  final double earnings;
  final int completedCourses;
  final List<String> portfolio;
  final String availability;

  EmpowerHerUser({
    required this.id,
    required this.name,
    required this.age,
    required this.region,
    required this.language,
    required this.isMentor,
    required this.phone,
    required this.email,
    required this.skills,
    required this.learningLevel,
    required this.currentGoal,
    required this.goalProgress,
    required this.preferredJobType,
    required this.categories,
    required this.joinedAt,
    required this.avatarUrl,
    required this.earnings,
    required this.completedCourses,
    required this.portfolio,
    required this.availability,
  });

  // Sample user for preview
  static EmpowerHerUser sampleUser() {
    return EmpowerHerUser(
      id: '123',
      name: 'Priya Sharma',
      age: 28,
      region: 'West Bengal',
      language: 'Bengali',
      isMentor: true,
      phone: '+91 9876543210',
      email: 'priya.sharma@example.com',
      skills: ['Embroidery', 'Stitching', 'Pottery', 'Digital Marketing'],
      learningLevel: 'Intermediate',
      currentGoal: 'Master Machine Stitching',
      goalProgress: 0.65,
      preferredJobType: 'Remote Part-time',
      categories: ['Craft', 'Sewing', 'Digital'],
      joinedAt: DateTime.now().subtract(const Duration(days: 120)),
      avatarUrl: '',
      earnings: 12500,
      completedCourses: 3,
      portfolio: ['Embroidered Saree', 'Hand-crafted Pottery', 'Custom Blouse'],
      availability: 'Weekends Only',
    );
  }
}

class ProfilePage extends StatefulWidget {
  final EmpowerHerUser user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // Here you would upload the image to your backend
      // and update the user's profile
    }
  }

  Color _getSkillColor(String skill) {
    final Map<String, Color> skillColors = {
      'Embroidery': Colors.pink.shade100,
      'Stitching': Colors.purple.shade100,
      'Pottery': Colors.orange.shade100,
      'Digital Marketing': Colors.blue.shade100,
    };

    return skillColors[skill] ?? Colors.grey.shade100;
  }

  void _editProfile() {
    // Navigate to edit profile page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile functionality coming soon!')),
    );
  }

  void _applyAsMentor() {
    // Navigate to mentor application page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mentor application coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _editProfile),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            _buildStatsRow(),
            _buildSkillsSection(),
            _buildGoalCard(),
            _buildPreferencesCard(),
            _buildPortfolioSection(),
            if (!widget.user.isMentor) _buildMentorCTA(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : widget.user.avatarUrl.isNotEmpty
                              ? NetworkImage(widget.user.avatarUrl)
                                  as ImageProvider
                              : const AssetImage('assets/default_avatar.png'),
                      child: widget.user.avatarUrl.isEmpty && _imageFile == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.user.age} • ${widget.user.region} • ${widget.user.language}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.user.isMentor)
                      Chip(
                        label: const Text('Verified Mentor'),
                        backgroundColor: Colors.purple.shade50,
                        avatar: const Icon(
                          Icons.verified,
                          color: Colors.purple,
                          size: 18,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Member since ${DateFormat.yMMM().format(widget.user.joinedAt)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.user.availability,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactButton(
                icon: Icons.phone,
                label: 'Call',
                onTap: () {
                  // Launch phone call
                },
              ),
              _buildContactButton(
                icon: Icons.email,
                label: 'Email',
                onTap: () {
                  // Launch email
                },
              ),
              _buildContactButton(
                icon: Icons.message,
                label: 'Message',
                onTap: () {
                  // Open messaging
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.purple),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard(
            title: 'Earnings',
            value: '₹${widget.user.earnings.toStringAsFixed(0)}',
            icon: Icons.currency_rupee,
          ),
          _buildStatCard(
            title: 'Courses',
            value: widget.user.completedCourses.toString(),
            icon: Icons.school,
          ),
          _buildStatCard(
            title: 'Skills',
            value: widget.user.skills.length.toString(),
            icon: Icons.auto_awesome,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to add skills
                },
                child: const Text('Add Skill'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.user.skills.map((skill) {
              return Chip(
                label: Text(skill),
                backgroundColor: _getSkillColor(skill),
                avatar: const Icon(Icons.star, size: 16),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'Current Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {
                  // Edit goal
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.user.currentGoal,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 14.0,
            percent: widget.user.goalProgress,
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.purple.shade300,
            barRadius: const Radius.circular(7),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 8),
          Text(
            '${(widget.user.goalProgress * 100).round()}% Complete',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.work, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Preferred Job Type:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(widget.user.preferredJobType),
                backgroundColor: Colors.purple.shade50,
                padding: const EdgeInsets.all(4),
                labelStyle: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Interested Categories:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.user.categories.map((category) {
              return Chip(
                label: Text(category),
                backgroundColor: Colors.purple.shade50,
                padding: const EdgeInsets.all(4),
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.collections, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'Portfolio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Add to portfolio
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.user.portfolio.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.user.portfolio[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCTA() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: _applyAsMentor,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Become a Mentor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
