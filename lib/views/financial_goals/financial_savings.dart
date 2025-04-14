import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SavingsGoalsScreen extends StatefulWidget {
  @override
  _SavingsGoalsScreenState createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Sewing Machine',
      'target': 15000,
      'saved': 8500,
      'milestones': [
        {'label': '₹1000 saved!', 'value': 1000},
        {'label': '₹7500 saved!', 'value': 7500},
      ],
    },
    {
      'title': 'Workshop Setup',
      'target': 10000,
      'saved': 2500,
      'milestones': [
        {'label': '₹1500 saved!', 'value': 1500},
        {'label': '₹1000 quarterway there!', 'value': 1000},
      ],
    },
  ];

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController targetController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Savings Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Goal Title'),
              ),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _goals.add({
                    'title': titleController.text,
                    'target': int.parse(targetController.text),
                    'saved': 0,
                    'milestones': [],
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Add Goal'),
            ),
          ],
        );
      },
    );
  }

  void _addMilestone(Map<String, dynamic> goal) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController milestoneController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Add New Milestone'),
          content: TextField(
            controller: milestoneController,
            decoration: const InputDecoration(labelText: 'Milestone Amount'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  goal['milestones'].add({
                    'label': '₹${milestoneController.text} milestone',
                    'value': int.parse(milestoneController.text),
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Add Milestone'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    double progress = goal['saved'] / goal['target'];
    double remaining = 1 - progress;

    // Prepare the segments for the pie chart (no percentages, just amounts)
    Map<String, double> dataMap = {
      'Saved': progress,
      'Remaining': remaining,
    };

    // Add milestones as segments
    for (var milestone in goal['milestones']) {
      double milestoneProgress = milestone['value'] / goal['target'];
      dataMap[milestone['label']] = milestoneProgress;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              chartRadius: MediaQuery.of(context).size.width / 2.2,
              centerText: "Remaining\n₹${goal['target'] - goal['saved']}",
              legendOptions: LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.left,
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValues: false,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Saved: ₹${goal['saved']} / ₹${goal['target']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            // Milestones
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: goal['milestones']
                  .map<Widget>((milestone) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          milestone['label'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            // Add Milestone button
            ElevatedButton(
              onPressed: () => _addMilestone(goal),
              child: const Text('Add Milestone'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings & Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _goals.isEmpty
                  ? const Center(child: Text('No goals yet. Add one!'))
                  : ListView.builder(
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        return _buildGoalCard(_goals[index]);
                      },
                    ),
            ),
            ElevatedButton.icon(
              onPressed: _addNewGoal,
              icon: const Icon(Icons.add),
              label: const Text('Add New Goal'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
