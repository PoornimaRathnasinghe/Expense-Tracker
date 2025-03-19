import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.status;

  if (!status.isGranted) {
    PermissionStatus newStatus = await Permission.storage.request();
    if (!newStatus.isGranted) {
      throw Exception("Storage permission is required.");
    }
  }
}
