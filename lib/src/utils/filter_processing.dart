import 'dart:isolate';

import 'package:intl_phone_number_input/src/models/country_model.dart';

class FilterProcessing {
  List<Country>? countries;
  String? text;
  SendPort? sendPort;
  FilterProcessing({
    this.countries,
    this.text,
    this.sendPort,
  });
}

class GetCountryNameModule {
  Country? country;
  String? locale;
  SendPort? sendPort;
  GetCountryNameModule({
    this.country,
    this.locale,
    this.sendPort,
  });
}
