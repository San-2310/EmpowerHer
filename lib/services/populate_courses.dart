import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/course_model.dart';

Future<void> populateCourses() async {
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  // Sample courses data
  List<Course> coursesList = [];

  for (int i = 0; i < 30; i++) {
    List<Module> modules = [];
    for (int j = 0; j < 5; j++) {
      // Each course has 5 modules
      modules.add(Module(
        title: 'Module $j of Course $i',
        description: 'Description of Module $j in Course $i',
        videoUrl: 'https://example.com/video$j',
        duration: Random().nextInt(30) +
            20, // Random duration between 20 to 50 minutes
      ));
    }

    // Creating course with random data
    coursesList.add(Course(
      id: 'course$i',
      title: 'Course $i',
      description: 'This is the description of Course $i',
      category: 'Category ${Random().nextInt(5) + 1}', // Random category
      thumbnail: 'https://example.com/thumbnail$i',
      modules: modules,
      totalDuration: modules.fold(0, (sum, module) => sum + module.duration),
      enrolledUsers: [
        'tg8tqHEGHWdVowwWw7LT4QdiIuF2'
      ], // Add the user ID to enrolledUsers
      completedUsers: i % 2 ==
              0 // Example: mark courses with even IDs as completed for this user
          ? ['tg8tqHEGHWdVowwWw7LT4QdiIuF2']
          : [],
      rating: Random().nextDouble() * 5, // Random rating between 0.0 and 5.0
      numberOfRatings: Random().nextInt(100) + 1, // Random number of ratings
    ));
  }

  // Store courses in Firestore
  for (var course in coursesList) {
    try {
      await courses.doc(course.id).set(course.toJson());
      print('Course ${course.title} added to Firestore');
    } catch (e) {
      print("Error adding course: $e");
    }
  }
}
