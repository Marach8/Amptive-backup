class CreateShowModel {
  CreateShowModel({
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.category,
    required this.showType,
    required this.price,
    required this.tagIds,
    required this.coHostIds,
  });

  final String title;
  final String description;
  final String coverUrl;
  final String category;
  final String showType;
  final double price;
  final List<String> tagIds;
  final List<String> coHostIds;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'category': category,
      'show_type': showType,
      'price': price,
      'tag_ids': tagIds,
      'co_host_ids': coHostIds,
    };
  }
}
