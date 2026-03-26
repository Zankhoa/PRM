class AccountManageDto {
  final int userId;
  final String username;
  final String fullName;
  final String? email;
  final String? phone;
  final bool isActive;
  final int roleId;

  const AccountManageDto({
    required this.userId,
    required this.username,
    required this.fullName,
    this.email,
    this.phone,
    required this.isActive,
    required this.roleId,
  });

  factory AccountManageDto.fromJson(Map<String, dynamic> json) {
    return AccountManageDto(
      userId: json['userId'] as int? ?? json['UserId'] as int? ?? 0,
      username:
          json['username'] as String? ?? json['Username'] as String? ?? '',
      fullName:
          json['fullName'] as String? ?? json['FullName'] as String? ?? '',
      email: json['email'] as String? ?? json['Email'] as String?,
      phone: json['phone'] as String? ?? json['Phone'] as String?,
      isActive: json['isActive'] as bool? ?? json['IsActive'] as bool? ?? false,
      roleId: json['roleId'] as int? ?? json['RoleId'] as int? ?? 3,
    );
  }
}

class CreateAccountRequest {
  final String username;
  final String fullName;
  final String password;
  final String? email;
  final String? phone;
  final int roleId;

  const CreateAccountRequest({
    required this.username,
    required this.fullName,
    required this.password,
    this.email,
    this.phone,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'email': email,
      'phone': phone,
      'roleId': roleId,
    };
  }
}

class UpdateAccountRequest {
  final String? fullName;
  final String? password;
  final String? email;
  final String? phone;
  final bool? isActive;
  final int? roleId;

  const UpdateAccountRequest({
    this.fullName,
    this.password,
    this.email,
    this.phone,
    this.isActive,
    this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'password': password,
      'email': email,
      'phone': phone,
      'isActive': isActive,
      'roleId': roleId,
    }..removeWhere((key, value) => value == null);
  }
}
