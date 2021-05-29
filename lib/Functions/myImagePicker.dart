import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'compressImage.dart';
import 'randomString.dart';

Future<String> myImagePicker() async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
    source: ImageSource.camera,
    // imageQuality: 15,
  );
  // print(pickedFile.path);
  var dir = await getTemporaryDirectory();
  var tempPath = dir.path;
  File compressedFile = await testCompressAndGetFile(
      await File(pickedFile.path), "$tempPath/${getRandomString(10)}.jpeg");
  return compressedFile.path;
}
