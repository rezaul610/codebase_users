import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final InternetConnection _connectionChecker = InternetConnection();

  Future<bool> hasConnection() async {
    return await _connectionChecker.hasInternetAccess;
  }

  Stream<bool> get onConnectionChanged => _connectionChecker.onStatusChange.map(
        (status) => status == InternetStatus.connected,
      );
}
