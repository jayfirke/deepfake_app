
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {

  Future<bool> _requestPermission(Permission permission) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
    if (statuses[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestStoragePermission() async {
    return await _requestPermission(Permission.storage);
  }
}
