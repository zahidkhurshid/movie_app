import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';
import '../models/review_model.dart';
import '../config/firebase_settings.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFavoriteMovie(Movie movie) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .update({
      'favoriteMovies': FieldValue.arrayUnion([movie.id]),
    });
  }

  Future<void> removeFavoriteMovie(Movie movie) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .update({
      'favoriteMovies': FieldValue.arrayRemove([movie.id]),
    });
  }

  Future<List<int>> getFavoriteMovies() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .get();
    return List<int>.from(doc['favoriteMovies']);
  }

  Future<void> submitReview(Review review, int movieId) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection(FirebaseSettings.reviewsCollection).add({
      'userId': userId,
      'movieId': movieId,
      'author': review.author,
      'content': review.content,
      'rating': review.rating,
      'userName': review.userName,
      'comment': review.comment,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Review>> getReviewsForMovie(int movieId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseSettings.reviewsCollection)
        .where('movieId', isEqualTo: movieId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Review(
        id: doc.id,
        author: data['author'] ?? '',
        content: data['content'] ?? '',
        rating: (data['rating'] ?? 0).toDouble(),
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        comment: data['comment'] ?? '',
      );
    }).toList();
  }

  Future<void> addBookmark(Movie movie) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .update({
      'bookmarkedMovies': FieldValue.arrayUnion([movie.id]),
    });
  }

  Future<void> removeBookmark(int movieId) async {
    String userId = _auth.currentUser!.uid;
    await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .update({
      'bookmarkedMovies': FieldValue.arrayRemove([movieId]),
    });
  }

  Future<bool> isMovieBookmarked(int movieId) async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .get();
    List<dynamic> bookmarkedMovies = doc['bookmarkedMovies'] ?? [];
    return bookmarkedMovies.contains(movieId);
  }

  Future<List<int>> getBookmarkedMovies() async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore
        .collection(FirebaseSettings.usersCollection)
        .doc(userId)
        .get();
    List<dynamic> bookmarkedMovies = doc.get('bookmarkedMovies') ?? [];
    return bookmarkedMovies.cast<int>();
  }
}
