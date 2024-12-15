import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class TrainerListPage extends StatelessWidget {
  const TrainerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainer List'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('TrainerList').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("No trainers found in Firestore."); // Debug log
            return const Center(
              child: Text(
                'No trainers available at the moment.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          var trainers = snapshot.data!.docs;
          for (var trainer in trainers) {
            print("Trainer Data: ${trainer.data()}"); // Debug log
          }

          return ListView.builder(
            itemCount: trainers.length,
            itemBuilder: (context, index) {
              var trainer = trainers[index];

              // Fetch fields with default fallback values
              String name = trainer['Name'] ?? 'Unknown Name';
              String experience = trainer['Experience'] ?? 'No Experience';
              String phone = trainer['Phone'] ?? 'No Phone';
              String location = trainer['Location'] ?? 'No Location';
              String imgUrl = trainer['ImgUrl'] ?? 'https://via.placeholder.com/150';
              Uint8List? decoded; // Declare the variable before using it

              // If image URL is available, try to decode it
              if (imgUrl.isNotEmpty) {
                try {
                  decoded = base64Decode(imgUrl);
                } catch (e) {
                  print("Error decoding image: $e");
                }
              }

              // Placeholder image
              String category = trainer['Category'] ?? 'No Category'; // New field

              return TrainerCard(
                name: name,
                experience: experience,
                phone: phone,
                location: location,
                imgUrl: decoded != null ? MemoryImage(decoded) : null, // Pass the decoded image or null
                category: category, // Passing category to TrainerCard
              );
            },
          );
        },
      ),
    );
  }
}

class TrainerCard extends StatelessWidget {
  final String name;
  final String experience;
  final String phone;
  final String location;
  final ImageProvider? imgUrl; // Changed to ImageProvider? to handle the image properly
  final String category; // New field

  const TrainerCard({
    super.key,
    required this.name,
    required this.experience,
    required this.phone,
    required this.location,
    required this.imgUrl,
    required this.category, // Required category
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          foregroundImage: imgUrl, // Use ImageProvider for foregroundImage
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text('Category: $category'), // Displaying category
            Text('Experience: $experience'),
            Text('Phone: $phone'),
            Text('Location: $location'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Call Trainer'),
                content: Text('Would you like to call $name at $phone?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text('Call'),
                    onPressed: () {
                      // Add phone calling logic if needed
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}






// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:typed_data';
//
// class TrainerListPage extends StatelessWidget {
//   const TrainerListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trainer List'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('TrainerList').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             print("No trainers found in Firestore."); // Debug log
//             return const Center(
//               child: Text(
//                 'No trainers available at the moment.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }
//
//           var trainers = snapshot.data!.docs;
//           for (var trainer in trainers) {
//             print("Trainer Data: ${trainer.data()}"); // Debug log
//           }
//
//           return ListView.builder(
//             itemCount: trainers.length,
//             itemBuilder: (context, index) {
//               var trainer = trainers[index];
//
//               // Fetch fields with default fallback values
//               String name = trainer['Name'] ?? 'Unknown Name';
//               String experience = trainer['Experience'] ?? 'No Experience';
//               String phone = trainer['Phone'] ?? 'No Phone';
//               String location = trainer['Location'] ?? 'No Location';
//               String imgUrl = trainer['ImgUrl'] ??
//                   'https://via.placeholder.com/150'; //
//               Uint8List? decoded; // Declare the variable before using it
//
//               if ( imgUrl.isNotEmpty) {
//                 try {
//                   decoded = base64Decode(imgUrl);
//                 } catch (e) {
//                   print("Error decoding image: $e");
//                 }
//               }
// // Placeholder image
//               String category = trainer['Category'] ?? 'No Category'; // New field
//
//               return TrainerCard(
//                 name: name,
//                 experience: experience,
//                 phone: phone,
//                 location: location,
//                 imgUrl: decoded != null ? MemoryImage(decoded) : null,
//
//                 category: category, // Passing category to TrainerCard
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TrainerCard extends StatelessWidget {
//   final String name;
//   final String experience;
//   final String phone;
//   final String location;
//   final Widget imgUrl;
//   final String category; // New field
//
//   const TrainerCard({
//     super.key,
//     required this.name,
//     required this.experience,
//     required this.phone,
//     required this.location,
//     required this.imgUrl,
//     required this.category, // Required category
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 30,
//           foregroundImage: imgUrl,
//         ),
//         title: Text(
//           name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 5),
//             Text('Category: $category'), // Displaying category
//             Text('Experience: $experience'),
//             Text('Phone: $phone'),
//             Text('Location: $location'),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.phone),
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Call Trainer'),
//                 content: Text('Would you like to call $name at $phone?'),
//                 actions: [
//                   TextButton(
//                     child: const Text('Cancel'),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   TextButton(
//                     child: const Text('Call'),
//                     onPressed: () {
//                       // Add phone calling logic if needed
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }














//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
//
// class TrainerListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trainer List'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('TrainerList').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             print("No trainers found in Firestore."); // Debug log
//             return Center(
//               child: Text(
//                 'No trainers available at the moment.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }
//
//           var trainers = snapshot.data!.docs;
//           trainers.forEach((trainer) {
//             print("Trainer Data: ${trainer.data()}"); // Debug log
//           });
//
//           return ListView.builder(
//             itemCount: trainers.length,
//             itemBuilder: (context, index) {
//               var trainer = trainers[index];
//
//               // Fetch fields with default fallback values
//               String name = trainer['Name'] ?? 'Unknown Name';
//               String experience = trainer['Experience'] ?? 'No Experience';
//               String phone = trainer['Phone'] ?? 'No Phone';
//               String location = trainer['Location'] ?? 'No Location';
//               String imgUrl = trainer['ImgUrl'] ??
//                   'https://via.placeholder.com/150'; // Placeholder image
//               String category = trainer['Category'] ?? 'No Category'; // New field
//
//               return TrainerCard(
//                 name: name,
//                 experience: experience,
//                 phone: phone,
//                 location: location,
//                 imgUrl: imgUrl,
//                 category: category, // Passing category to TrainerCard
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TrainerCard extends StatelessWidget {
//   final String name;
//   final String experience;
//   final String phone;
//   final String location;
//   final String imgUrl;
//   final String category; // New field
//
//   const TrainerCard({
//     Key? key,
//     required this.name,
//     required this.experience,
//     required this.phone,
//     required this.location,
//     required this.imgUrl,
//     required this.category, // Required category
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 30,
//           backgroundImage: NetworkImage(imgUrl),
//           onBackgroundImageError: (_, __) => Icon(Icons.person, size: 30),
//         ),
//         title: Text(
//           name,
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 5),
//             Text('Category: $category'), // Displaying category
//             Text('Experience: $experience'),
//             Text('Phone: $phone'),
//             Text('Location: $location'),
//           ],
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.phone),
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: Text('Call Trainer'),
//                 content: Text('Would you like to call $name at $phone?'),
//                 actions: [
//                   TextButton(
//                     child: Text('Cancel'),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   TextButton(
//                     child: Text('Call'),
//                     onPressed: () {
//                       Navigator.pop(context); // Close the dialog
//                       _makePhoneCall(phone); // Launch phone dialer
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // Function to launch the phone dialer
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       print('Can make calls: ${await canLaunchUrl(phoneUri)}');
//     }
//   }
// }
