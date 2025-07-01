import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditStaffPage extends StatefulWidget {
  final String? documentId;

  // Constructor accepts an optional documentId. If it's null, we're adding a new staff.
  // If it's not null, we're editing an existing one.
  const AddEditStaffPage({super.key, this.documentId});

  @override
  State<AddEditStaffPage> createState() => _AddEditStaffPageState();
}

class _AddEditStaffPageState extends State<AddEditStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _ageController = TextEditingController();
  
  bool _isLoading = false;
  bool get _isEditing => widget.documentId != null;

  @override
  void initState() {
    super.initState();
    // If we are editing, fetch the existing staff data
    if (_isEditing) {
      _fetchStaffData();
    }
  }

  Future<void> _fetchStaffData() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('staff').doc(widget.documentId).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _idController.text = data['staff_id'] ?? '';
        _ageController.text = (data['age'] ?? 0).toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load staff data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final staffData = {
          'name': _nameController.text,
          'staff_id': _idController.text,
          'age': int.parse(_ageController.text),
        };

        if (_isEditing) {
          // Update existing document
          await FirebaseFirestore.instance.collection('staff').doc(widget.documentId).update(staffData);
        } else {
          // Add new document
          await FirebaseFirestore.instance.collection('staff').add(staffData);
        }
        
        // Go back to the previous screen on success
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Staff' : 'Add Staff'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID Staff',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a staff ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(_isEditing ? 'Update' : 'Submit'),
                  ),
                ],
              ),
            ),
    );
  }
}
