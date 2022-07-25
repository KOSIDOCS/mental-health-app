
class PsychologistModel {
  final String uid;
  final String name;
  final String userImage;
  final int experience;
  final double star;
  final String earlyAdmit;
  final double minAmount;
  final String specialization;
  final String placeOfWork;
  final String country;
  final String currency;
  final String about;
  final List<dynamic> diplomarAndCertificate;
  final List<dynamic> articles;
  final dynamic education;
  final List<dynamic> reviews;
  final bool isOnline;

  PsychologistModel({
    required this.uid,
    required this.name,
    required this.userImage,
    required this.experience,
    required this.star,
    required this.earlyAdmit,
    required this.minAmount,
    required this.specialization,
    required this.placeOfWork,
    required this.country,
    required this.currency,
    required this.about,
    required this.diplomarAndCertificate,
    required this.articles,
    required this.education,
    required this.reviews,
    required this.isOnline,
  });

  factory PsychologistModel.fromMap(Map data, {required String uid }) {
    return PsychologistModel(
      uid: uid,
      name: data['name'],
      userImage: data['user_image'],
      experience: data['experience'],
      star: data['star'],
      earlyAdmit: data['early_admit'],
      minAmount: data['min_amount'],
      specialization: data['specialization'],
      placeOfWork: data['place_of_work'],
      country: data['country'],
      currency: data['currency'],
      about: data['about'],
      diplomarAndCertificate: data['diplomas_cert'] ?? [],
      articles: data['articles'],
      education: data['education'],
      reviews: data['reviews'],
      isOnline: data['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'user_image': userImage,
      'experience': experience,
      'star': star,
      'early_admit': earlyAdmit,
      'min_amount': minAmount,
      'specialization': specialization,
      'place_of_work': placeOfWork,
      'country': country,
      'currency': currency,
      'about': about,
      'diplomas_cert': diplomarAndCertificate,
      'articles': articles,
      'education': education,
      'reviews': reviews,
      'is_online': isOnline,
    };
  }
}