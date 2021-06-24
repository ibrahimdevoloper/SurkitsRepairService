// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendNotificationService.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$SendNotificationService extends SendNotificationService {
  _$SendNotificationService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SendNotificationService;

  @override
  Future<Response<dynamic>> sendNotification(dynamic body) {
    final $url = '/send';
    final $headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=${FirebaseKeys.serverKey}',
    };

    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
