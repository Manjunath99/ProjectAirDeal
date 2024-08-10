//this is the class for card details model
class CardDetail {
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? id;

  CardDetail({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.id,
  });

  // Convert a CardDetail instance to a JSON map
  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'id': id,
  };

  // Create a CardDetail instance from a JSON map
  factory CardDetail.fromJson(Map<String, dynamic> json) => CardDetail(
    name: json['name'],
    phoneNumber: json['phoneNumber'],
    email: json['email'],
    id: json['id'],
  );
}
