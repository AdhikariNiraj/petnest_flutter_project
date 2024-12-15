import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'confirm_adoption.dart'; // Import ConfirmAdoption page

class ConfirmedRejectedList extends StatefulWidget {
  const ConfirmedRejectedList({super.key});

  @override
  _ConfirmedRejectedListState createState() => _ConfirmedRejectedListState();
}

class _ConfirmedRejectedListState extends State<ConfirmedRejectedList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests List'),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filterStatus = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'Confirmed',
                child: Text('Confirmed'),
              ),
              const PopupMenuItem(
                value: 'Rejected',
                child: Text('Rejected'),
              ),
              const PopupMenuItem(
                value: 'Pending',
                child: Text('Pending'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _filterStatus == 'All'
            ? _firestore
            .collection('AdoptionRequests')
            .where('status', whereIn: ['Confirmed', 'Rejected', 'Pending'])
            .snapshots()
            : _firestore
            .collection('AdoptionRequests')
            .where('status', isEqualTo: _filterStatus)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No requests found for the selected filter.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }

          final requests = snapshot.data!.docs;

          // Sort 'Pending' requests to appear first
          requests.sort((a, b) {
            final statusA = a['status'] ?? '';
            final statusB = b['status'] ?? '';
            if (statusA == 'Pending' && statusB != 'Pending') return -1;
            if (statusA != 'Pending' && statusB == 'Pending') return 1;
            return 0; // Keeps original order for other statuses
          });

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final petName = data['petName'] ?? 'Unknown Pet';
              final status = data['status'] ?? 'Unknown Status';
              final userEmail = data['userEmail'] ?? 'N/A';
              final requestId = requests[index].id;

              Color statusColor;
              IconData statusIcon;
              if (status == 'Confirmed') {
                statusColor = Colors.green;
                statusIcon = Icons.check;
              } else if (status == 'Rejected') {
                statusColor = Colors.red;
                statusIcon = Icons.close;
              } else {
                statusColor = Colors.orange;
                statusIcon = Icons.hourglass_empty;
              }

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor,
                    child: Icon(statusIcon, color: Colors.white),
                  ),
                  title: Text(
                    petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'User: $userEmail',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmAdoption(adoptionRequestId: requestId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
