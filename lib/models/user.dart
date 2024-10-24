class User {
  final String transporterId;
  final String driverId;

  User({
    required this.transporterId,
    required this.driverId,
  });

  // Factory method to create a User from a map (optional, if you're dealing with data serialization)
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      transporterId: data['transporterId'] as String,
      driverId: data['driverId'] as String,
    );
  }

  // Method to convert User to a map (optional)
  Map<String, dynamic> toMap() {
    return {
      'transporterId': transporterId,
      'driverId': driverId,
    };
  }
}
