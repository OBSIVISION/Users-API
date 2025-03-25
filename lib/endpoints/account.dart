part of obsivision.apis.users;

/// Creates an account.
///
/// Called after Firebase Auth has successfully created a user. Their ID token
/// should be passed as the Authorization token. All user-specific details will be stored
/// by Firebase Auth.
class AccountCreate {
  static const String emailSubscriptions = 'emailSubscriptions';
  static Future<int> handle({
    required T? Function<T>(String paramName) getParam,
    required void Function(int, String) raise,
  }) async {
    await auth.setCustomUserClaims(getParam(HellcatHeaders.uid.header),
        customUserClaims: {'role': 'member'});
    await firestore
        .collection('users')
        .doc(getParam(HellcatHeaders.uid.header))
        .create({emailSubscriptions: []});
    return HttpStatus.ok;
  }
}
