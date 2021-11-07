import 'package:book_tracker/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String? id;
  final String? title;
  final String author;
  final String description;
  final String categories;
  final String? notes;
  final String? photoUrl;
  final String? userId;
  final int pageCount;
  final Timestamp? startedReading;
  final Timestamp? finishReading;
  final String publishedDate;
  final double rating;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.categories,
    this.notes,
    this.userId,
    required this.publishedDate,
    required this.pageCount,
    this.photoUrl,
    this.startedReading,
    this.finishReading,
    this.rating = 4,
  });

  factory Book.fromDocument(QueryDocumentSnapshot data) {
    return Book(
      id: data.id,
      title: data.get("title"),
      author: data.get("author"),
      description: data.get("description"),
      categories: data.get("categories"),
      notes: data.get("notes"),
      photoUrl: data.get("photo_url"),
      userId: data.get("user_id"),
      pageCount: data.get("page_count"),
      publishedDate: data.get("published_date"),
      startedReading: data.data().toString().contains('started_reading_at')
          ? data.get("started_reading_at")
          : null,
      finishReading: data.data().toString().contains('finished_reading_at')
          ? data.get("finished_reading_at")
          : null,
      rating: data.data().toString().contains('rating')
          ? parseDouble(data.get("rating"))
          : 0.0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'categories': categories,
      'notes': notes,
      'photo_url': photoUrl,
      'user_id': userId,
      'page_count': pageCount,
      'published_date': publishedDate,
      'started_reading_at': startedReading,
      'finished_reading_at': finishReading,
      'rating': rating
    };
  }
}
