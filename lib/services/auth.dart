import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import '../config/secrets.dart';

class Auth {
  final userPool = CognitoUserPool(
    Config.cognitoUserPoolId,
    Config.clientId,
  );

  late CognitoUser cognitoUser;

  late CognitoUserSession session;
  Future<String?> signIn(email, password) async {
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );

    try {
      session = (await cognitoUser.authenticateUser(authDetails))!;
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
    } catch (e) {}
    print(session.getAccessToken().getJwtToken());
  }
}
