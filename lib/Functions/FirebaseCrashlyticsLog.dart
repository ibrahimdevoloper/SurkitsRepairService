import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void firebaseCrashLog(dynamic error,StackTrace stackTrace,{String code, String tag, String message}) {
  print("Error Code: ${code},Tag: ${tag},message: ${message},");
  // if (code != null)
  //   FirebaseCrashlytics.instance
  //       .log("Error Code: ${code},Tag: ${tag},message: ${message},");
  // else
  //   FirebaseCrashlytics.instance.log("Tag: ${tag},message: ${message},");
  FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason:"Error Code: ${code},Tag: ${tag},message: ${message},"
  );
}
