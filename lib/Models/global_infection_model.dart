class GlobalInfection {
  String country;
  int totalCases,
      newCases,
      totalDeaths,
      newDeaths,
      activeCases,
      totalRecovered,
      criticalCases;

  GlobalInfection(
      {this.country,
      this.totalCases,
      this.newCases,
      this.totalDeaths,
      this.newDeaths,
      this.activeCases,
      this.totalRecovered,
      this.criticalCases});

  factory GlobalInfection.fromJson(Map<String, dynamic> json) {
    return GlobalInfection(
        totalCases: json['totalCases'],
        newCases: json['newCases'],
        totalDeaths: json['totalDeaths'],
        newDeaths: json['newDeaths'],
        activeCases: json['activeCases'],
        totalRecovered: json['totalRecovered'],
        criticalCases: json['criticalCases'],
        country: json['country']);
  }
}
