import 'package:flutter_app/dto/dto_constants.dart';

class AuthDto {
  String username;
  String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DtoConstants.userDtoUsername: this.username,
      DtoConstants.userDtoPassword: this.password,
    };
  }
}
