class Book {
  final String? id;
  final String title;
  final List<String>? categories;
  final String thumbnail;
  final String saleInfo;
  const Book({
    this.id,
    this.title = 'Unknown Title',
    this.categories,
    this.thumbnail =
        "https://books.google.com/books/content?id=6ZxEAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
    this.saleInfo = 'Unknown Sale Info',
  });
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};

    return Book(
      id: json['id'],
      title: volumeInfo['title'] ?? 'Unknown Title',
      categories: (volumeInfo['categories'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      thumbnail:
          imageLinks['thumbnail'] ??
          "https://books.google.com/books/content?id=6ZxEAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
      saleInfo: saleInfo['saleability'] ?? 'Unknown Sale Info',
    );
  }
}
