class NepalInfection {
  int positive, negative, total;
  String source;

  NepalInfection({this.positive, this.negative, this.total, this.source});

  factory NepalInfection.fromJson(Map<String, dynamic> json) {
    return NepalInfection(
        positive: json['tested_positive'],
        negative: json['tested_negative'],
        total: json['tested_total'],
        source: json['source']);
  }
}
