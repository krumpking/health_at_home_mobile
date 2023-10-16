class SignUpUser {
  late String uuid = '';
  late int purpose = 1;
  late String email;
  late String password;
  late String phoneCode;
  late String phone;
  late String firstName;
  late String lastName;
  late String gender;
  late String dob;
  late String userType = 'patient';
  late bool termsAccepted = true;
  late bool marketingAccepted = true;

  SignUpUser.init();

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'passwordConfirmation': password,
        'userType': userType,
        'phoneCode': phoneCode,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender.toLowerCase() == 'female'
            ? 1
            : (gender.toLowerCase() == 'male' ? 2 : 3),
        'dob': dob,
        'termsAccepted': termsAccepted,
        'marketingAccepted': marketingAccepted
      };
}
