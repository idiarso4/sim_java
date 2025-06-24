import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_java_frontend/core/theme/app_theme.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/widgets/error_view.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/widgets/dashboard_loading.dart';
import 'package:sim_java_frontend/core/utils/size_utils.dart';

class DashboardView extends StatelessWidget {
  final DashboardSummary summary;
  final List<UpcomingClass> upcomingClasses;

  const DashboardView({
    Key? key,
    required this.summary,
    required this.upcomingClasses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic here
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Summary Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSummaryCards(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Upcoming Classes Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildUpcomingClassesSection(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildQuickActions(),
            ),
          ),
          // Add some bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Text(
      'Selamat Datang',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildSummaryCard(
              title: 'Total Siswa',
              value: summary.totalStudents.toString(),
              icon: Icons.people,
              color: Theme.of(context).colorScheme.primary,
            ),
            _buildSummaryCard(
              title: 'Total Guru',
              value: summary.totalTeachers.toString(),
              icon: Icons.school,
              color: Colors.green,
            ),
            _buildSummaryCard(
              title: 'Kehadiran Hari Ini',
              value: '${summary.todayAttendance}%',
              icon: Icons.calendar_today,
              color: Colors.orange,
            ),
            _buildSummaryCard(
              title: 'Total Kelas',
              value: summary.totalClasses.toString(),
              icon: Icons.class_,
              color: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kelas Berikutnya',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (upcomingClasses.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Navigate to full schedule
                },
                child: const Text('Lihat Semua'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (upcomingClasses.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Tidak ada jadwal kelas mendatang'),
            ),
          )
        else
          ...upcomingClasses
              .map((classItem) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildClassItem(classItem),
                  ))
              .toList(),
      ],
    );
  }

  Widget _buildClassItem(UpcomingClass classItem) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.class_,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          '${classItem.className} • ${classItem.subject}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              classItem.teacherName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  classItem.time,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          // Navigate to class details
        },
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: [
            _buildQuickActionButton(
              'Tambah Siswa',
              context,
              'Add Student',
              Icons.person_add,
              Colors.green,
              () {
                // Navigate to add student
              },
            ),
            _buildQuickActionButton(
              context,
              'Add Teacher',
              Icons.person_add_alt_1,
              Colors.blue,
              () {
                // Navigate to add teacher
              },
            ),
            _buildQuickActionButton(
              context,
              'Take Attendance',
              Icons.assignment_turned_in,
              Colors.orange,
              () {
                // Navigate to attendance
              },
            ),
            _buildQuickActionButton(
              context,
              'View All Classes',
              Icons.class_,
              Colors.purple,
              () {
                // Navigate to classes
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
