import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/widgets/dashboard_loading.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/widgets/dashboard_view.dart';
import 'package:sim_java_frontend/features/dashboard/presentation/widgets/error_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Load dashboard data when the page is first opened
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<DashboardBloc>().add(const LoadDashboard());
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state.status == DashboardStatus.failure) {
          _showErrorSnackBar(
            state.error is ServerFailure
                ? 'Gagal memuat data dashboard. Periksa koneksi internet Anda.'
                : state.error?.message ?? 'Terjadi kesalahan',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                return IconButton(
                  icon: state.status == DashboardStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: state.status == DashboardStatus.loading
                      ? null
                      : _loadDashboard,
                  tooltip: 'Refresh',
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.initial ||
                state.status == DashboardStatus.loading) {
              return const DashboardLoading();
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                context.read<DashboardBloc>().add(const RefreshDashboard());
                // Wait for the bloc to emit a new state
                await Future.delayed(const Duration(seconds: 1));
              },
              child: _buildContent(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(DashboardState state) {
    if (state.status == DashboardStatus.failure) {
      return ErrorView(
        message: state.error is ServerFailure
            ? 'Gagal memuat data dashboard. Periksa koneksi internet Anda.'
            : state.error?.message ?? 'Terjadi kesalahan',
        onRetry: _loadDashboard,
      );
    }

    if (state.status == DashboardStatus.success) {
      return DashboardView(
        summary: state.summary ?? DashboardSummary.empty(),
        upcomingClasses: state.upcomingClasses,
        onRetry: _loadDashboard,
      );
    }

    return const SizedBox.shrink();
  }
}
