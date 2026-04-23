import 'package:books_app/const/colors.dart';
import 'package:books_app/const/text_styles.dart';
import 'package:books_app/model/book_model.dart';
import 'package:books_app/screens/details_screen.dart';
import 'package:books_app/service/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String? searchQuery;
  const HomeScreen({super.key, this.searchQuery});
  String getHeaderImage(String image) {
    String lowerCaseImage = image.toLowerCase();
    if (lowerCaseImage.contains('library catalogs')) {
      return 'assets/images/horror_header.png';
    } else if (lowerCaseImage.contains('social science') ||
        lowerCaseImage.contains('language arts & disciplines')) {
      return 'assets/images/historic_header.png';
    } else if (lowerCaseImage.contains('economic geography')) {
      return 'assets/images/romance_header.png';
    } else if (lowerCaseImage.contains('catalogs')) {
      return 'assets/images/adventure_header.png';
    } else {
      return 'assets/images/default_header.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            getHeaderImage(searchQuery ?? 'newest'),
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              const SizedBox(height: 300),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Popular', style: AppStyles.subTitle),
                            Text('See All', style: AppStyles.subTitle),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(color: Colors.white24, thickness: 2),
                      ),
                      Expanded(
                        child: FutureBuilder<List<Book>?>(
                          future: searchQuery != null
                              ? ApiService().getBooksByCategory(searchQuery!)
                              : ApiService().getNewestBooks(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            }
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Center(
                                child: Text(
                                  "Error fetching books",
                                  style: AppStyles.subTitle,
                                ),
                              );
                            }
                            final books = snapshot.data!;
                            if (books.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No books found",
                                  style: AppStyles.subTitle,
                                ),
                              );
                            }
                            return ListView.separated(
                              separatorBuilder: (context, _) => const Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 30,
                              ),
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];
                                return InkWell(
                                  onTap: () {
                                    if (book.id != null) {
                                      final category =
                                          (book.categories != null &&
                                              book.categories!.isNotEmpty)
                                          ? book.categories![0]
                                          : null;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                            bookId: book.id!,
                                            category: category,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No book ID available.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Container(
                                            width: 80,
                                            height: 120,
                                            color: Colors.grey.shade800,
                                            child: Image.network(
                                              book.thumbnail,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            book.title,
                                            style: AppStyles.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
