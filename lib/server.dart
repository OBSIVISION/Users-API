library obsivision.apis.users;

import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:http_apis_define/http_apis.dart';
import 'dart:io';

part './endpoints/account.dart';

final admin = FirebaseAdminApp.initializeApp(
  'obsivision-site',
  Credential.fromApplicationDefaultCredentials(),
);
final firestore = Firestore(admin);
final auth = Auth(admin);
void main(List<String> args) async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    int.fromEnvironment('PORT', defaultValue: 8080),
  );

  server.listen((req) async {
    req.response.headers.contentType = ContentType.json;
    await api.handleRequest(req);
    await req.response.close();
  });
}

final API api = API(
  apiName: 'users_api',
  routes: [
    RouteSegment.routes(
      routeName: 'account',
      routes: [
        RouteSegment.endpoint(
          routeName: 'create',
          endpoint: Endpoint(
            endpointTypes: [EndpointType.post],
            requiresAuth: true,
            queryParameters: [
              Param.required('Authorization',
                  desc: 'The token isused by Firebase Auth.',
                  cast: (obj) => obj as String)
            ],
            bodyParameters: null,
            handleRequest: AccountCreate.handle,
          ),
        ),
      ],
    ),
  ],
);
