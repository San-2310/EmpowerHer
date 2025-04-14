// CourseListScreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/courses_services.dart';
import 'course_details_screen.dart';
import 'enrolled_courses_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseService = CourseService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnrolledCoursesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: courseService.getAllCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmpowerHerUser? user =
        Provider.of<EmpowerHerUserProvider>(context).currentUser;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(course: course),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(course.category),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.totalDuration} mins',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      StreamBuilder<List<Course>>(
                        stream:
                            CourseService().getEnrolledCourses(user!.id ?? ''),
                        builder: (context, snapshot) {
                          bool isEnrolled = false;
                          if (snapshot.hasData) {
                            isEnrolled =
                                snapshot.data!.any((c) => c.id == course.id);
                          }
                          return ElevatedButton(
                            onPressed: isEnrolled
                                ? null
                                : () {
                                    CourseService().enrollInCourse(
                                        user!.id ?? '', course.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Successfully enrolled in course'),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isEnrolled
                                  ? const Color.fromARGB(255, 238, 189, 41)
                                  : null,
                            ),
                            child: Text(isEnrolled ? 'Enrolled' : 'Enroll Now'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
