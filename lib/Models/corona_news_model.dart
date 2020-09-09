class CoronaNewsModel {
  String language, url, title, source, summary, imageUrl;

  CoronaNewsModel(
      {this.language,
      this.url,
      this.title,
      this.source,
      this.summary,
      this.imageUrl});

  factory CoronaNewsModel.fromJson(Map<String, dynamic> json) {
    return CoronaNewsModel(
        language: json['lang'],
        url: json['url'],
        title: json['title'],
        source: json['source'],
        summary: json['summary'],
        imageUrl: json['image_url']);
  }
}
