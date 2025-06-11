// lib/presentation/screens/admin_dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/ResearchPaperCardNorating.dart';
import '../components/homeTopBar.dart';
import '../components/searchBar.dart';
import '../components/drawer.dart';
import '../../application/providers/paper_provider.dart';
import '../../application/providers/stats_provider.dart';
import "../../domain/entities/paper_entity.dart";

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminStatsViewModelProvider).fetchStats();
      ref.read(paperNotifierProvider.notifier).fetchPapers();
    });
  }

  List<PaperEntity> _filteredPapers(List<PaperEntity> papers) {
    if (_searchQuery.isEmpty) return papers;
    return papers
        .where(
            (p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final statsVm = ref.watch(adminStatsViewModelProvider);
    final paperState = ref.watch(paperNotifierProvider);
    final paperNotifier = ref.read(paperNotifierProvider.notifier);

    final isLoading = statsVm.isLoading || paperState.status == "loading";

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerContent(
          onLogout: () async {
            try {
              // Navigate to login
              context.go('/login');
            } catch (e) {
              // Show an error message if logout fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logout failed: ${e.toString()}'),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          onNavigate: (route) {
            Navigator.pop(context);
            GoRouter.of(context).go(route);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top bar with menu & notifications
              HomeTopBar(
                onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
                inputName: 'Admin Dashboard',
                onNotificationClick: () {
                  // handle notifications
                },
              ),
              const SizedBox(height: 16),

              // Search bar
              CustomSearchBar(
                query: _searchQuery,
                onQueryChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 24),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard("Users", statsVm.stats!.users.toString()),
                  _buildStatCard(
                      "Researches", statsVm.stats!.papers.toString()),
                  _buildStatCard("Comments", "0"),
                ],
              ),
              const SizedBox(height: 24),

              // Section title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recently Posted",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              // Papers list
              Expanded(
                child: _filteredPapers(paperState.papers).isEmpty
                    ? const Center(child: Text('No papers found'))
                    : ListView.builder(
                        itemCount: _filteredPapers(paperState.papers).length,
                        itemBuilder: (context, index) {
                          final paper =
                              _filteredPapers(paperState.papers)[index];
                          return ResearchPaperCardNorating(
                            key: ValueKey(paper.id), // Unique key for each item
                            paperId: paper.id,
                            title: paper.title,
                            imageAsset: 'assets/research_paper.png',
                            publishedDate: paper.year.toString(),
                            authorName: paper.authors.join(', '),
                            // lib/presentation/screens/admin_dashboard.dart
                            onDelete: () async {
                              final scaffold = ScaffoldMessenger.of(context);

                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Delete Paper?'),
                                  content: Text(
                                      'Are you sure you want to delete "${paper.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed != true) return;

                              try {
                                await paperNotifier.deletePaper(paper.id);
                                ref
                                    .read(adminStatsViewModelProvider)
                                    .fetchStats();
                              } catch (e) {
                                scaffold.showSnackBar(SnackBar(
                                    content: Text(
                                        'Delete failed: ${e.toString()}')));
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
