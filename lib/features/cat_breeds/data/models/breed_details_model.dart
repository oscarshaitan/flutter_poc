import 'package:fluttertest/features/cat_breeds/domain/entities/breed_details.dart';
import 'package:meta/meta.dart';

class BreedDetailsModel extends BreedDetails {
  BreedDetailsModel({
    @required String url,
  }) : super(url: url);

  factory BreedDetailsModel.fromJson(Map<String, dynamic> json) {
    return BreedDetailsModel(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
