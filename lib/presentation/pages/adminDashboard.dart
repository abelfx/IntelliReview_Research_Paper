import 'package:flutter/material.dart';
import 'package:frontend/presentation/components/ResearchPaperCardNorating.dart';

class AdminDashboard extends StatefulWidget {
  final VoidCallback onLogout;

  const AdminDashboard({super.key, required this.onLogout});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? selectedFilter;
  String? selectedSort;
  String? selectedCategory;
  String query = "";
  bool isLoading = false;

  // Mocked stats
  final int users = 120;
  final int papers = 45;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  void _fetchStats() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF5D5CBB)),
              child: Text("Admin Panel",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              title: const Text("Create Notification"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/create-notification');
              },
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                widget.onLogout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5D5CBB),
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () =>
                Navigator.pushNamed(context, '/create-notification'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 16),

            // Mock filter, sort, and category
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text("Filter"),
                  selected: selectedFilter != null,
                  onSelected: (_) => setState(() => selectedFilter = "Filter"),
                ),
                FilterChip(
                  label: const Text("Sort"),
                  selected: selectedSort != null,
                  onSelected: (_) => setState(() => selectedSort = "Sort"),
                ),
                FilterChip(
                  label: const Text("Category"),
                  selected: selectedCategory != null,
                  onSelected: (_) =>
                      setState(() => selectedCategory = "Category"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Cards
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard("Users", users.toString()),
                  _buildStatCard("Researches", papers.toString()),
                  _buildStatCard("Comments", "0"),
                ],
              ),

            const SizedBox(height: 24),

            const Text(
              "Recently Posted",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Use your custom research paper card
            ResearchPaperCardNorating(
              title: "Blockchain Applications in Research",
              imageAsset: "assets/research_paper.png",
              publishedDate: "2025-01-20",
              authorName: "Prof. Sara Mekonnen",
            ),
            ResearchPaperCardNorating(
              title: "AI in Modern Research",
              imageAsset: "assets/research_paper.png",
              publishedDate: "2025-01-18",
              authorName: "Dr. Henok Ayele",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D5CBB),
                ),
              ),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
