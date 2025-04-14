import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart'; // Import for dotted borders
import 'package:empower_her/views/skills_extraction_screen/ytb_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SkillExtractionPage extends StatefulWidget {
  const SkillExtractionPage({Key? key}) : super(key: key);

  @override
  State<SkillExtractionPage> createState() => _SkillExtractionPageState();
}

class _SkillExtractionPageState extends State<SkillExtractionPage> {
  File? _image;
  bool _isAnalyzing = false;
  bool _showResults = false;
  final ImagePicker _picker = ImagePicker();
  List<String> _skills = [];

  // Mock data for demonstration
  List<Map<String, dynamic>> _detectedSkills = [];

  final List<String> _detectedMaterials = [
    'Cotton fabric',
    'Thread (color: red)',
    'Buttons',
    'Sequins',
  ];

  final List<Map<String, dynamic>> _matchingJobs = [
    {
      'title': 'Tailor at FabStitch',
      'salary': '₹15k/month',
      'requirements': 5,
      'matched': 3,
      'missingSkills': ['Machine Stitching', 'Garment Finishing'],
      'courseDuration': '2-week course',
    },
    {
      'title': 'Embroidery Artist at CraftVilla',
      'salary': '₹12k/month',
      'requirements': 4,
      'matched': 3,
      'missingSkills': ['Zari Work'],
      'courseDuration': '1-week course',
    },
  ];
  var lesson = "";
  List<List<String>> skillCombosWithPay = [
    ["clay", "₹6,000/month"],
    ["clay", "wheel", "₹7,000/month"],
    ["clay", "wheel", "glaze", "₹8,000/month"],
    ["ceramic", "floral", "₹10,000/month"],
    ["ceramic", "floral", "abstract", "₹12,000/month"],
    ["ceramic", "floral", "sculpting", "₹13,000/month"],
    ["handbuilding", "textured", "₹9,000/month"],
    ["handbuilding", "textured", "glazing", "₹10,500/month"],
    ["slab", "engraving", "₹9,500/month"],
    ["slab", "engraving", "floral", "₹11,000/month"],
    ["wheel", "porcelain", "₹10,000/month"],
    ["wheel", "porcelain", "raku", "₹12,500/month"],
    ["porcelain", "abstract", "₹11,000/month"],
    ["porcelain", "abstract", "modern", "₹13,000/month"],
    ["functional", "glazing", "₹9,000/month"],
    ["functional", "glazing", "custom", "₹10,500/month"],
    ["mugs", "cups", "floral", "₹11,000/month"],
    ["mugs", "cups", "abstract", "₹12,000/month"],
    ["mold", "casting", "₹9,500/month"],
    ["mold", "casting", "textured", "₹11,000/month"],
    ["kiln", "raku", "₹10,000/month"],
    ["kiln", "raku", "glazing", "₹12,000/month"],
    ["nature", "floral", "₹9,000/month"],
    ["nature", "floral", "sculpting", "₹10,500/month"],
    ["minimalist", "modern", "₹10,000/month"],
    ["minimalist", "modern", "engraving", "₹11,500/month"],
    ["decor", "custom", "₹11,000/month"],
    ["decor", "custom", "sets", "₹13,000/month"],
    ["teaching", "workshops", "₹14,000/month"],
    ["studio", "management", "₹15,000/month"],
  ];

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isAnalyzing = true;
        _showResults = false;
      });

      // Simulate AI analysis delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isAnalyzing = false;
          _showResults = true;
        });
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      List<Map<String, String>> detectedSkills = await _uploadImage(_image!);

      setState(() {
        _detectedSkills = detectedSkills;
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera); // ✅ triggers upload
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery); // ✅ triggers upload
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> extractJsonFromGemini(String rawResponse) {
    try {
      final cleaned = rawResponse.replaceAll(RegExp(r'```[a-z]*'), '').trim();
      final firstBrace = cleaned.indexOf('{');
      final lastBrace = cleaned.lastIndexOf('}');

      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        final jsonString = cleaned.substring(firstBrace, lastBrace + 1);
        return json.decode(jsonString);
      } else {
        throw FormatException("No JSON braces found.");
      }
    } catch (e) {
      debugPrint("❌ Failed to extract JSON from Gemini: \$e");
      return {};
    }
  }

  String _compareResponseText = '';

  Future<void> sendCompareData(final user, final employerMap) async {
    final url = Uri.parse('http://192.168.165.49:8000/compare');

    final body = jsonEncode({"user": user, "employer_map": employerMap});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response from server: ${responseData['response']}");

        setState(() {
          _compareResponseText = responseData['response'];
        });

        // lesson += responseData['response'];
        //fetchEmbeddedVideos(lesson, "pottery");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception caught: $e");
    }
  }

  List<String> _embeddedVideos = [];

  // Future<List<String>> fetchEmbeddedVideos(
  //     String lesson, String category) async {
  //   final url = Uri.parse(
  //       'http://192.168.165.49:8000/embed_vid'); // Replace with your actual IP if needed

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "learn": "clay wheel",
  //         "category": "pottery",
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final decoded = jsonDecode(response.body);
  //       print(decoded);
  //       List<String> videos = List<String>.from(decoded["video_urls"] ?? []);
  //       print("🎥 Embedded Videos: $videos");
  //       return videos;
  //     } else {
  //       print("❌ Failed to fetch videos: ${response.statusCode}");
  //       return [];
  //     }
  //   } catch (e) {
  //     print("🚨 Error: $e");
  //     return [];
  //   }
  // }
  Future<void> fetchEmbeddedVideos(String lesson, String category) async {
    final url = Uri.parse('http://192.168.165.49:8000/embed_vid');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "learn": lesson,
          "category": category,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<String> videos = List<String>.from(decoded["video_urls"] ?? []);

        setState(() {
          _embeddedVideos = videos;
        });

        print("🎥 Embedded Videos: $_embeddedVideos");
      } else {
        print("❌ Failed to fetch videos: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error: $e");
    }
  }

  // Future<List<Map<String, String>>> _uploadImage(File imageFile) async {
  //   final url = Uri.parse('http://192.168.165.49:8000/');
  //   var request = http.MultipartRequest('POST', url);
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'image',
  //     imageFile.path,
  //   ));
  Future<List<Map<String, String>>> _uploadImage(File imageFile) async {
    final url = Uri.parse('http://192.168.165.49:8000/');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    var response = await request.send();

    List<Map<String, String>> _detectedSkills = [];

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("✅ Uploaded successfully!");
      print("🧠 Gemini Raw Response: $responseBody");

      final Map<String, dynamic> outerDecoded = jsonDecode(responseBody);

      // Step 1: Get the nested JSON string
      final innerJsonString = outerDecoded["response"];

      // Step 2: Clean it up if it has ```json wrapping
      final cleaned = innerJsonString
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      // Step 3: Decode the actual inner JSON
      final Map<String, dynamic> innerDecoded = jsonDecode(cleaned);

      // Step 4: Extract from either key
      var skills = innerDecoded["design_characteristics"] ??
          innerDecoded["design_characteristic"];

      if (skills is String) {
        _detectedSkills.add({"skill": skills});
      } else if (skills is List) {
        for (var skill in skills) {
          _detectedSkills.add({"skill": skill});
        }
      } else {
        print(
            "⚠️ Unexpected format in design_characteristics/design_characteristic");
      }

      print("🎯 Detected Skills: $_detectedSkills");
    } else {
      print("❌ Upload failed: ${response.statusCode}");
    }
    sendCompareData(_detectedSkills, skillCombosWithPay);
    return _detectedSkills;
  }
  //   var response = await request.send();

  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     print("✅ Uploaded successfully!");
  //     print("🧠 Gemini Raw Response: $responseBody");

  //     final Map<String, dynamic> outerDecoded = jsonDecode(responseBody);

  //     // Step 1: Get the nested JSON string
  //     final innerJsonString = outerDecoded["response"];

  //     // Step 2: Clean it up if it has ```json wrapping
  //     final cleaned = innerJsonString
  //         .replaceAll("```json", "")
  //         .replaceAll("```", "")
  //         .trim();

  //     // Step 3: Decode the actual inner JSON
  //     final Map<String, dynamic> innerDecoded = jsonDecode(cleaned);

  //     // Step 4: Extract from either key
  //     var skills = innerDecoded["design_characteristics"] ??
  //         innerDecoded["design_characteristic"];

  //     _detectedSkills.clear();

  //     if (skills is String) {
  //       _detectedSkills.add({"skill": skills});
  //     } else if (skills is List) {
  //       for (var skill in skills) {
  //         _detectedSkills.add({"skill": skill});
  //       }
  //     } else {
  //       print(
  //           "⚠️ Unexpected format in design_characteristics/design_characteristic");
  //     }

  //     print("🎯 Detected Skills: $_detectedSkills");
  //     return _detectedSkills;
  //   }
  // }
  // // Future<void> _uploadImage(File image) async {
  //   final mimeType = lookupMimeType(image.path); // optional: get mime type
  //   final uri = Uri.parse("http://192.168.165.49:8000/");

  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode({
  //       "url": image.path, // path on device
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final rawSkills = data["response"];

  //     try {
  //       final decoded = json.decode(rawSkills); // parse Gemini JSON
  //       if (decoded is List) {
  //         setState(() {
  //           _detectedSkills.clear(); // Clear previous
  //           for (var skill in decoded) {
  //             _detectedSkills.add({"skill": skill});
  //           }
  //         });
  //       }
  //     } catch (e) {
  //       print("Could not parse response: $e");
  //       print(rawSkills);
  //     }
  //   } else {
  //     print("Upload failed: ${response.statusCode}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Skill Extraction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageUploadSection(),
            _buildDetectedSkillsSection(_detectedSkills),

            _buildCompareResponseBox(_detectedSkills, skillCombosWithPay),
            // if (_isAnalyzing) _buildAnalyzingIndicator(),
            // if (_showResults) ...[
            //   _buildDetectedSkillsSection(),
            //   _buildDetectedMaterialsSection(),
            //   _buildMatchingJobsSection(),
            //   _buildActionableSection(),
            // ],
            const SizedBox(height: 80), // Space for floating Didi avatar
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'voice_guide',
            backgroundColor: const Color(0xFFEFE5FF),
            foregroundColor: const Color(0xFF6A3EA1),
            mini: true,
            onPressed: () {
              // Voice guide logic
            },
            child: const Icon(Icons.volume_up),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'didi_assistant',
            backgroundColor: const Color(0xFF6A3EA1),
            onPressed: () {
              // Show Didi assistant
            },
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/didi_avatar.png'),
              backgroundColor: Color(0xFF6A3EA1),
              child: Text(
                'दीदी',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareResponseBox(user, employerMap) {
    // fetchEmbeddedVideos(user, "pottery");
    // sendCompareData(user, employerMap);
    if (_compareResponseText.isEmpty)
      return SizedBox(); // show nothing if no data yet

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
              Icon(Icons.analytics, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "AI Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _compareResponseText,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              // Fetch videos first

              await fetchEmbeddedVideos("clay", "pottery");

              // Agar videos milte hain, toh navigation karein
              if (_embeddedVideos.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmbeddedVideosPage(
                      videoUrls: _embeddedVideos,
                    ),
                  ),
                );
              } else {
                // Agar videos nahi hain, alert ya kuch aur dikhana ho toh
                print("⚠️ No videos available");
              }
            },
            child: const Text('Want to know video paths?'),
          )
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload a photo of your craft',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo of your handmade item (e.g., stitched blouse, pottery, embroidery)',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (_image == null)
            GestureDetector(
              onTap: _showImageSourceOptions,
              child: DottedBorder(
                color: const Color(0xFF6A3EA1),
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: [6, 3],
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: const Color(0xFFEFE5FF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 64,
                        color: const Color(0xFF6A3EA1).withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Upload Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A3EA1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.photo_library,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: _showImageSourceOptions,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _showImageSourceOptions,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Change Photo'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF6A3EA1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
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
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A3EA1)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analyzing your craft...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Our AI is identifying skills, techniques, and materials used',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedSkillsSection(List<Map<String, dynamic>> skills) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF6A3EA1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detected Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...skills.map((skill) => _buildSkillItem(skill)).toList(),
        ],
      ),
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill) {
    final String skillName = skill['skill'];
    final double proficiency =
        (skillName.hashCode % 50 + 50) / 100; // Random-ish %
    final String level = proficiency > 0.8
        ? "Expert"
        : proficiency > 0.6
            ? "Intermediate"
            : "Beginner";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE5FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A3EA1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 10.0,
            percent: proficiency,
            backgroundColor: Colors.grey[200],
            progressColor: const Color(0xFF6A3EA1),
            barRadius: const Radius.circular(5),
            trailing: Text(
              '${(proficiency * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedMaterialsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.category,
                  color: Color(0xFF0078D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Materials Used',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _detectedMaterials.map((material) {
              return Chip(
                label: Text(material),
                backgroundColor: const Color(0xFFE5F6FF),
                labelStyle: const TextStyle(
                  color: Color(0xFF0078D4),
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingJobsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work,
                  color: Color(0xFFFF8C00),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Jobs Matching Your Skills',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._matchingJobs.map((job) => _buildJobItem(job)).toList(),
        ],
      ),
    );
  }

  Widget _buildJobItem(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${job['title']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${job['salary']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF8C00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You meet ${job['matched']}/${job['requirements']} requirements',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: job['matched'] / job['requirements'],
                backgroundColor: Colors.grey[200],
                progressColor: const Color(0xFF6A3EA1),
                barRadius: const Radius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Missing Skills:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ...job['missingSkills'].map<Widget>((skill) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 16,
                        color: Color(0xFF6A3EA1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Learn: $skill (${job['courseDuration']})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6A3EA1),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View job details
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6A3EA1),
                    side: const BorderSide(color: Color(0xFF6A3EA1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Bookmark job
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A3EA1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Bookmark'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionableSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
          const Text(
            'Next Steps',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            icon: Icons.school,
            title: 'View Courses to Upskill',
            description: 'Learn the missing skills to qualify for more jobs',
            color: const Color(0xFF6A3EA1),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.share,
            title: 'Share Your Skills',
            description: 'Generate a portfolio to share with employers',
            color: const Color(0xFF0078D4),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.verified,
            title: 'Get Skill Certificate',
            description: 'Verify your skills with an AI-generated certificate',
            color: const Color(0xFFFF8C00),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFE5FF).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF6A3EA1).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFF6A3EA1), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Community Comparison',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A3EA1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your embroidery skills are better than 70% of beginners in your region!',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        // Action logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: color),
        ],
      ),
    );
  }
}
