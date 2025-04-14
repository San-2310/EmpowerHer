// EnrolledCoursesScreen.dart
import 'package:empower_her/models/user_model.dart';
import 'package:empower_her/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course_model.dart';
import '../../services/courses_services.dart';
import 'course_details_screen.dart';

class EnrolledCoursesScreen extends StatelessWidget {
  const EnrolledCoursesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmpowerHerUser? user =
        Provider.of<EmpowerHerUserProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
      ),
      body: StreamBuilder<List<Course>>(
        stream: CourseService().getEnrolledCourses(user!.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You haven\'t enrolled in any courses yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final course = snapshot.data![index];
              return EnrolledCourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}

class EnrolledCourseCard extends StatelessWidget {
  final Course course;
  const EnrolledCourseCard({Key? key, required this.course}) : super(key: key);

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
              builder: (context) => CourseDetailScreen(
                course: course,
                //isEnrolled: true,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value:
                    course.completedUsers.contains(user!.id ?? '') ? 1.0 : 0.0,
                backgroundColor: Colors.grey[200],
                color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.completedUsers.contains(user!.id ?? '')
                        ? 'Completed'
                        : 'In Progress',
                    style: TextStyle(
                      color: course.completedUsers.contains(user!.id ?? '')
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text('Enrolled'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
