import 'package:flutter_app/dto/dto_constants.dart';

class UserDto {
  int id;
  String email;
  String firstName;
  String lastName;
  String token;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DtoConstants.userDtoEmail: this.email,
      DtoConstants.userDtoFirstName: this.firstName,
      DtoConstants.userDtoLastName: this.lastName,
    };
  }

  fromMap(Map<String, dynamic> query) {
    this.id = query[DtoConstants.userDtoId];
    this.email = query[DtoConstants.userDtoEmail];
    this.firstName = query[DtoConstants.userDtoFirstName];
    this.lastName = query[DtoConstants.userDtoLastName];
    this.token = query[DtoConstants.userDtoToken];
    return this;
  }
}
