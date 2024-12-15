import 'package:flutter/material.dart';
import 'package:petnest_flutter_project/common/admin_nav_bar_common.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // List of most adopted breeds with their corresponding image paths
    final List<Map<String, String>> mostAdoptedBreeds = [
      {"breed": "Golden Retriever", "image": "images/golden_retriever.jpg"},
      {"breed": "German Shepherd", "image": "images/german_shepherd.webp"},
      {"breed": "Bulldog", "image": "images/bulldog.jpg"},
      {"breed": "Beagle", "image": "images/beagle.jpg"},
      {"breed": "Labrador", "image": "images/labrador_retriever.jpg"},
    ];

    // List of pet care tips
    final List<Map<String, String>> petCareTips = [
      {
        "tip": "Ensure your pet always has fresh water to stay hydrated.",
        "icon": "images/water_bowl.jpg"
      },
      {
        "tip": "Regular vet check-ups keep your pet healthy and happy.",
        "icon": "images/vet_checkup.jpg"
      },
      {
        "tip": "Daily exercise keeps your pet fit and mentally stimulated.",
        "icon": "images/exercise.jpg"
      },
      {
        "tip": "Feed your pet a balanced diet tailored to its needs.",
        "icon": "images/balanced_diet.jpg"
      },
    ];

    return AdminBasePage(
      title: 'Home',
      bodyContent: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue.shade100,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to PetNest!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Find your new best friend from our wide variety of pets.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Most Adopted Breeds Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Most Adopted Breeds',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mostAdoptedBreeds.length,
                itemBuilder: (context, index) {
                  final breed = mostAdoptedBreeds[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          // Display breed image from assets
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              child: Image.asset(
                                breed['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  breed['breed']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text('Popular Breed'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Pet Care Tips Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pet Care Tips',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 320, // Increased height for larger images
              child: PageView.builder(
                itemCount: petCareTips.length,
                itemBuilder: (context, index) {
                  final tip = petCareTips[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          tip['icon']!,
                          height: 200, // Increased image height
                          width: 350, // Increased image width
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            tip['tip']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Adoption Benefits Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Why Adopt?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Adopting a pet not only gives you a loyal friend, but it also saves lives and supports ethical pet practices.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
