// features/discover/data/datasources/discover_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/developer_model.dart';

abstract class DiscoverRemoteDataSource {
  Future<List<DeveloperModel>> getRecommendedDevelopers({
    List<String>? techFilters,
    int page = 1,
    int limit = 20,
  });
  Future<void> followDeveloper(String userId);
  Future<void> unfollowDeveloper(String userId);
}

class DiscoverRemoteDataSourceImpl implements DiscoverRemoteDataSource {
  final DioClient dioClient;

  DiscoverRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<DeveloperModel>> getRecommendedDevelopers({
    List<String>? techFilters,
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Remove mock data when backend is ready
    await Future.delayed(const Duration(seconds: 1));

    return List.generate(limit, (index) {
      final devIndex = (page - 1) * limit + index;
      return DeveloperModel(
        id: 'dev_$devIndex',
        name: _getRandomName(devIndex),
        username: '@${_getRandomUsername(devIndex)}',
        avatar: 'https://i.pravatar.cc/150?u=dev$devIndex',
        bio: _getRandomBio(devIndex),
        matchPercentage: 80 + (devIndex % 20),
        commonTechnologies: 2 + (devIndex % 4),
        mutualConnections: 3 + (devIndex % 10),
        commonTech: _getCommonTech(devIndex),
        otherTech: _getOtherTech(devIndex),
        knownFor: _getKnownFor(devIndex),
        isFollowing: false,
      );
    });
  }

  @override
  Future<void> followDeveloper(String userId) async {
    try {
      final response = await dioClient.post('/users/$userId/follow');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(message: 'Failed to follow user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unfollowDeveloper(String userId) async {
    try {
      final response = await dioClient.post('/users/$userId/unfollow');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(message: 'Failed to unfollow user');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  String _getRandomName(int index) {
    final names = [
      'Jordan Lee',
      'Maya Patel',
      'Alex Kumar',
      'Sarah Chen',
      'Marcus Johnson',
      'Elena Rodriguez',
      'David Kim',
      'Emma Williams',
      'Ryan Taylor',
      'Sophie Anderson',
    ];
    return names[index % names.length];
  }

  String _getRandomUsername(int index) {
    final usernames = [
      'jordanlee',
      'mayapatel',
      'alexk_dev',
      'sarahdev',
      'marcusj',
      'elenacodes',
      'davidkim',
      'emmawilliams',
      'ryantaylor',
      'sophieanderson',
    ];
    return usernames[index % usernames.length];
  }

  String _getRandomBio(int index) {
    final bios = [
      'Backend engineer specializing in scalable microservices. Love working with cloud-native technologies.',
      'Full-stack developer with a focus on developer experience and tooling. Open source enthusiast.',
      'Building amazing React applications with TypeScript. Passionate about clean code and testing.',
      'Mobile developer creating beautiful Flutter apps. UI/UX design enthusiast.',
      'DevOps engineer automating everything. Kubernetes and Docker expert.',
      'Frontend wizard crafting pixel-perfect interfaces. Animation lover.',
      'Data engineer building robust pipelines. Python and Spark specialist.',
      'Security researcher and ethical hacker. Making the web safer.',
      'Machine learning engineer working on NLP. AI enthusiast.',
      'Game developer creating immersive experiences. Unity and Unreal Engine.',
    ];
    return bios[index % bios.length];
  }

  List<String> _getCommonTech(int index) {
    final techSets = [
      ['#NodeJS', '#TypeScript', '#Docker'],
      ['#React', '#NodeJS'],
      ['#React', '#TypeScript', '#TailwindCSS'],
      ['#Flutter', '#Dart'],
      ['#Kubernetes', '#Docker', '#AWS'],
      ['#React', '#JavaScript', '#CSS'],
      ['#Python', '#Spark', '#SQL'],
      ['#Python', '#Security', '#Linux'],
      ['#Python', '#TensorFlow', '#NLP'],
      ['#Unity', '#C#', '#Blender'],
    ];
    return techSets[index % techSets.length];
  }

  List<String> _getOtherTech(int index) {
    final techSets = [
      ['#Kubernetes', '#Redis'],
      ['#Vue', '#webpack'],
      ['#NodeJS', '#GraphQL'],
      ['#Swift', '#Kotlin'],
      ['#Terraform', '#Jenkins'],
      ['#Vue', '#Nuxt'],
      ['#Kafka', '#Airflow'],
      ['#BurpSuite', '#Metasploit'],
      ['#PyTorch', '#Keras'],
      ['#Unreal', '#Maya'],
    ];
    return techSets[index % techSets.length];
  }

  String _getKnownFor(int index) {
    final knownForList = [
      'microservices-framework',
      'dev-tools-suite',
      'react-state-manager',
      'flutter-ui-kit',
      'k8s-deployment-tool',
      'animation-library',
      'data-pipeline-framework',
      'security-scanner',
      'ml-training-toolkit',
      'game-engine-plugin',
    ];
    return knownForList[index % knownForList.length];
  }
}
