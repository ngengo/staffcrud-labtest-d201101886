import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_staff_page.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get a reference to the 'staff' collection in Firestore
    final CollectionReference staffCollection = FirebaseFirestore.instance.collection('staff');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Listen to the stream of snapshots from the 'staff' collection
        stream: staffCollection.snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle error state
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          // Handle empty data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No staff found. Add one!'));
          }

          // If we have data, display it in a list
          final staffDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: staffDocs.length,
            itemBuilder: (context, index) {
              final doc = staffDocs[index];
              final staffData = doc.data() as Map<String, dynamic>;
              
              // Safely get data with fallbacks
              final name = staffData['name'] as String? ?? 'No Name';
              final staffId = staffData['staff_id'] as String? ?? 'No ID';
              final age = staffData['age'] as int? ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                color: Colors.amber[100],
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('$staffId\nAge: $age'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black54),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditStaffPage(documentId: doc.id),
                            ),
                          );
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Show a confirmation dialog before deleting
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Staff'),
                              content: const Text('Are you sure you want to delete this staff member?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirm == true) {
                            await staffCollection.doc(doc.id).delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add/Edit page without a document ID to create a new staff
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditStaffPage()),
          );
        },
        tooltip: 'Add Staff',
        child: const Icon(Icons.add),
      ),
    );
  }
}
