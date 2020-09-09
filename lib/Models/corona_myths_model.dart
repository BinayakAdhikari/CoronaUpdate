class CoronaMythsModel {
  String myth, reality, imageUrl, sourceName, sourceUrl;

  CoronaMythsModel(
      {this.myth,
      this.reality,
      this.imageUrl,
      this.sourceName,
      this.sourceUrl});

  factory CoronaMythsModel.fromJson(Map<String, dynamic> json) {
    return CoronaMythsModel(
        myth: json['myth'],
        reality: json['reality'],
        imageUrl: json['image_url'] == null
            ? 'https://www.health.gov.au/sites/default/files/images/news/2020/03/launch-of-the-coronavirus-covid-19-campaign.png'
            : json['image_url'],
        sourceName: json['source_name'],
        sourceUrl: json['source_url']);
  }
}
