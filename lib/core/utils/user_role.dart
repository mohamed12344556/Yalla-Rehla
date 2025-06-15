enum UserRole {
  admin('admin'),
  business('business'),
  traveler('traveler');

  const UserRole(this.value);
  final String value;

  // Convert from string to enum
  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'business':
        return UserRole.business;
      case 'traveler':
        return UserRole.traveler;
      default:
        throw ArgumentError('Invalid user role: $value');
    }
  }

  // Convert to string for storage
  @override
  String toString() => value;
}