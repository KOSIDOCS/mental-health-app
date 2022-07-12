class AppoinmentModel {
  final String name;
  final String time;
  final String date;
  // final String id;
  final String psychologistImage;
  final String type;
  final int price;
  final String about;
  final String recommendations;

  AppoinmentModel({
    required this.name,
    required this.time,
    required this.date,
    // required this.id,
    required this.psychologistImage,
    required this.type,
    required this.price,
    required this.about,
    required this.recommendations,
  });

  factory AppoinmentModel.fromMap(Map data) {
    return AppoinmentModel(
      name: data['name'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
      // id: data['id'] ?? '',
      psychologistImage: data['image'] ?? '',
      type: data['type'] ?? '',
      price: data['price'] ?? 0,
      about: data['about'] ?? '',
      recommendations: data['recommendations'] ?? '',
    );
  }
}