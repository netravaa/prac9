import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String? description;
  final int? pages;
  final bool isRead;
  final int? rating;
  final DateTime dateAdded;
  final DateTime? dateFinished;
  final String? imageUrl;

  const Recipe({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.description,
    this.pages,
    this.isRead = false,
    this.rating,
    required this.dateAdded,
    this.dateFinished,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        genre,
        description,
        pages,
        isRead,
        rating,
        dateAdded,
        dateFinished,
        imageUrl,
      ];

  Recipe copyWith({
    String? id,
    String? title,
    String? author,
    String? genre,
    String? description,
    int? pages,
    bool? isRead,
    int? rating,
    DateTime? dateAdded,
    DateTime? dateFinished,
    String? imageUrl,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
      pages: pages ?? this.pages,
      isRead: isRead ?? this.isRead,
      rating: rating ?? this.rating,
      dateAdded: dateAdded ?? this.dateAdded,
      dateFinished: dateFinished ?? this.dateFinished,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
