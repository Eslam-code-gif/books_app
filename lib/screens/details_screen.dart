import 'package:books_app/const/colors.dart';
import 'package:books_app/const/text_styles.dart';
import 'package:books_app/model/book_model.dart';
import 'package:books_app/screens/home_screen.dart';
import 'package:books_app/service/api_service.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String bookId;
  final String? category;
  const DetailsScreen({super.key, required this.bookId, this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
            size: 30,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.shopping_cart,
              color: AppColors.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Book?>(
              future: ApiService().getBookById(bookId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        "Error loading book details",
                        style: AppStyles.subTitle,
                      ),
                    ),
                  );
                }
                final book = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          book.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        book.title,
                        style: AppStyles.heading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  book.saleInfo,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.subTitleBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.previewButtonColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Preview",
                                    style: AppStyles.subTitle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(searchQuery: category),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Also See", style: AppStyles.subTitle),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<List<Book>?>(
              future: (category == null || category!.isEmpty)
                  ? ApiService().getNewestBooks()
                  : ApiService().getBooksByCategory(category!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        "Error loading related books",
                        style: AppStyles.subTitle,
                      ),
                    ),
                  );
                }
                final books = snapshot.data!;
                if (books.isEmpty) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        "No other books in same category",
                        style: AppStyles.subTitle,
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final relatedBook = books[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (relatedBook.id != null) {
                              final relatedCategory =
                                  (relatedBook.categories != null &&
                                      relatedBook.categories!.isNotEmpty)
                                  ? relatedBook.categories![0]
                                  : null;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    bookId: relatedBook.id!,
                                    category: relatedCategory,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No book ID available.'),
                                ),
                              );
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              relatedBook.thumbnail,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 120,
                                    color: Colors.grey,
                                    child: Icon(Icons.broken_image),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
