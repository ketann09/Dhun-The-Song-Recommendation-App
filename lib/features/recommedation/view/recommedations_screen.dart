import 'package:dhun/core/widgets/app_bg.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';

class RecommedationScreen extends StatefulWidget {
  const RecommedationScreen({super.key});

  @override
  State<RecommedationScreen> createState() => _RecommedationScreenState();
}

class _RecommedationScreenState extends State<RecommedationScreen> {
  final TextEditingController _trackIdController = TextEditingController();
  final TextEditingController _nController = TextEditingController();

  
  @override
  void initState() {
    super.initState();
    _nController.text = '5';
    _trackIdController.text = '16zol4GvHyTER5irYODUk0';
  }

  @override
  void dispose() {
    _trackIdController.dispose();
    _nController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBg(
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    _buildTextField(_trackIdController, 'Track ID (e.g., 16zol4GvHyTER5irYODUk0)'),
                    const SizedBox(height: 16),
                    _buildTextField(_nController, 'Number of Recommendations (n)'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Recommendations',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Results:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.white54),
                    _buildResults(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Results will appear here once fetched.',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey.shade800.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text(
          'Recommedations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48), 
      ],
    );
  }
}

