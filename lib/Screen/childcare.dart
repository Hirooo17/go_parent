import 'package:flutter/material.dart';

class Childcare extends StatefulWidget {
  const Childcare({super.key});

  @override
  State<Childcare> createState() => _ChildcareState();
}

class _ChildcareState extends State<Childcare> {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Nutrition & Feeding',
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'tips': [
        'Breastfeed exclusively for first 6 months if possible',
        'Introduce solid foods gradually after 6 months',
        'Always sterilize bottles and feeding equipment',
        'Watch for food allergies when introducing new foods',
      ]
    },
    {
      'title': 'Sleep & Rest',
      'icon': Icons.bedtime,
      'color': Colors.indigo,
      'tips': [
        'Newborns sleep 16-17 hours per day',
        'Establish consistent bedtime routines',
        'Put baby to sleep on their back',
        'Maintain optimal room temperature (68-72°F)',
      ]
    },
    {
      'title': 'Health & Safety',
      'icon': Icons.health_and_safety,
      'color': Colors.red,
      'tips': [
        'Schedule regular pediatric check-ups',
        'Keep vaccinations up to date',
        'Learn infant CPR and first aid',
        'Childproof your home thoroughly',
      ]
    },
    {
      'title': 'Development',
      'icon': Icons.child_care,
      'color': Colors.green,
      'tips': [
        'Engage in daily tummy time',
        'Read books together daily',
        'Encourage play and exploration',
        'Monitor developmental milestones',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Childcare Knowledge'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Add bookmark functionality
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Featured tip card
          Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.tips_and_updates, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Tip of the Day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Consistent routines help babies feel secure and develop better sleep patterns.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Categories grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showCategoryDetails(categories[index]);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: categories[index]['color'].withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categories[index]['icon'],
                          size: 48,
                          color: categories[index]['color'],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          categories[index]['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${categories[index]['tips'].length} tips',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add new tips or notes
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDetails(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(category['icon'], color: category['color']),
                  const SizedBox(width: 12),
                  Text(
                    category['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...category['tips']
                  .map<Widget>((tip) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle,
                                color: category['color'], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
