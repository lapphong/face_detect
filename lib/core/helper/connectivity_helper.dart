import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  ConnectivityHelper._();

  static Future<bool> get isNetworkAvailable async {
    final result = await Connectivity().checkConnectivity();

    return !result.contains(ConnectivityResult.none);
  }

  static Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map((event) {
      return !event.contains(ConnectivityResult.none);
    });
  }
}
