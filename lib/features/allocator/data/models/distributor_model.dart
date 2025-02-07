class DistributorModel {
  final String id;
  final String name;
  final bool isAvailable;

  DistributorModel({
    required this.id,
    required this.name,
    required this.isAvailable,
  });

  factory DistributorModel.fromJson(Map<String, dynamic> json) {
    return DistributorModel(
      id: json['id'],
      name: json['name'],
      isAvailable: json['isAvailable'],
    );
  }
}
