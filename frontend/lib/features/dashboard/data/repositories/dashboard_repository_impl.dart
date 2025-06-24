import 'package:dartz/dartz.dart';
import 'package:sim_java_frontend/core/error/exceptions.dart';
import 'package:sim_java_frontend/core/error/failures.dart';
import 'package:sim_java_frontend/core/network/network_info.dart';
import 'package:sim_java_frontend/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sim_java_frontend/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:sim_java_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSummary = await remoteDataSource.getDashboardSummary();
        return Right(remoteSummary);
      } on ServerException {
        return Left(ServerFailure('Failed to load dashboard summary'));
      } on UnauthorizedException {
        return Left(UnauthorizedFailure('Session expired'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<UpcomingClass>>> getUpcomingClasses() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteClasses = await remoteDataSource.getUpcomingClasses();
        return Right(remoteClasses);
      } on ServerException {
        return Left(ServerFailure('Failed to load upcoming classes'));
      } on UnauthorizedException {
        return Left(UnauthorizedFailure('Session expired'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
