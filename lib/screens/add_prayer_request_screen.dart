import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_request_provider.dart';
import '../models/prayer_request.dart';

class AddPrayerRequestScreen extends StatefulWidget {
  const AddPrayerRequestScreen({super.key, this.prayerToEdit});

  final PrayerRequest? prayerToEdit;

  @override
  State<AddPrayerRequestScreen> createState() => _AddPrayerRequestScreenState();
}

class _AddPrayerRequestScreenState extends State<AddPrayerRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  PrayerCategory _selectedCategory = PrayerCategory.personal;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // If editing an existing prayer, populate the form
    if (widget.prayerToEdit != null) {
      final prayer = widget.prayerToEdit!;
      _titleController.text = prayer.title;
      _descriptionController.text = prayer.description;
      _selectedCategory = prayer.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prayerToEdit != null ? 'Edit Prayer Request' : 'Add Prayer Request'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _savePrayerRequest,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share your heart with God',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'What would you like to pray about today?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Prayer Title',
                  hintText: 'e.g., Healing for my friend',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for your prayer';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PrayerCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: PrayerCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()[0] + 
                              category.name.substring(1)),
                  );
                }).toList(),
                onChanged: (category) {
                  if (category != null) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Prayer Description',
                  hintText: 'Share the details of your prayer request...',
                  prefixIcon: Icon(Icons.description_rounded),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description for your prayer';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Prayer Tip',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be specific and heartfelt in your prayer requests. God cares about every detail of your life, big and small.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _savePrayerRequest,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.favorite_rounded),
                  label: Text(_isLoading 
                      ? 'Saving...' 
                      : widget.prayerToEdit != null 
                          ? 'Update Prayer Request'
                          : 'Add Prayer Request'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePrayerRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<PrayerRequestProvider>();
      
      if (widget.prayerToEdit != null) {
        // Update existing prayer request
        final updatedPrayer = widget.prayerToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
        );
        await provider.updatePrayerRequest(updatedPrayer);
      } else {
        // Add new prayer request
        await provider.addPrayerRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.prayerToEdit != null 
              ? 'Prayer request updated successfully! 🙏' 
              : 'Prayer request added successfully! 🙏'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.prayerToEdit != null 
              ? 'Failed to update prayer request: $e'
              : 'Failed to add prayer request: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
