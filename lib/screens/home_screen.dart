import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import '../widgets/movie_list.dart';
import '../config/app_settings.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'downloads_screen.dart';
import 'profile_screen.dart';
import 'movie_detail_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _currentBannerIndex = 0;
  final List<String> _categories = ['Popular', 'Top Rated', 'Upcoming', 'Now Playing'];
  String _selectedCategory = 'Popular';
  bool _isLoading = false;
  String _error = '';
  Timer? _bannerTimer;
  static const Duration _bannerChangeDuration = Duration(seconds: 5);

  late PageController _pageController;
  List<Movie> _bannerMovies = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadMovies();
    _setupBannerTimer();
  }

  void _setupBannerTimer() {
    _bannerTimer = Timer.periodic(_bannerChangeDuration, (timer) {
      if (mounted && _bannerMovies.isNotEmpty) {
        if (_currentBannerIndex < _bannerMovies.length - 1) {
          _currentBannerIndex++;
        } else {
          _currentBannerIndex = 0;
        }
        _pageController.animateToPage(
          _currentBannerIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final movieService = Provider.of<MovieService>(context, listen: false);
      await movieService.fetchAllCategories();

      setState(() {
        _bannerMovies = movieService.popularMovies.take(5).toList();
      });

      // Fetch recommendations based on the first popular movie
      if (movieService.popularMovies.isNotEmpty) {
        await movieService.fetchRecommendations(movieService.popularMovies.first.id);
      }
    } catch (e) {
      setState(() {
        _error = AppSettings.genericErrorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    Provider.of<MovieService>(context, listen: false).updateMoviesByCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(AppSettings.appName),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error, style: AppSettings.bodyStyle))
          : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Slider
                AspectRatio(
                  aspectRatio: 16 / 8,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _bannerMovies.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentBannerIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final movie = _bannerMovies[index];
                          return Image.network(
                            '${AppSettings.imageBaseUrl}${movie.backdropPath}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[850],
                                child: Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.grey[400],
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _bannerMovies.length,
                                (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              width: index == _currentBannerIndex ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: index == _currentBannerIndex
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: AppSettings.headlineStyle,
                      ),
                      SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((category) {
                            bool isSelected = category == _selectedCategory;
                            return Container(
                              margin: EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                backgroundColor: Colors.transparent,
                                selectedColor: Colors.red,
                                checkmarkColor: Colors.white,
                                showCheckmark: false,
                                side: BorderSide(
                                  color: isSelected ? Colors.red : Colors.grey,
                                ),
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey,
                                  ),
                                ),
                                onSelected: (bool selected) {
                                  _onCategorySelected(category);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selected Category Movies
                Consumer<MovieService>(
                  builder: (context, movieService, child) {
                    final movies = movieService.movies;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            _selectedCategory,
                            style: AppSettings.headlineStyle,
                          ),
                        ),
                        SizedBox(height: 4),
                        SizedBox(
                          height: 175,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemCount: movies.length,
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(movie: movie),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  margin: EdgeInsets.only(right: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          '${AppSettings.imageBaseUrl}${movie.posterPath}',
                                          height: 150,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        movie.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Recommendations
                Consumer<MovieService>(
                  builder: (context, movieService, child) {
                    if (movieService.recommendations.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Recommended for You',
                            style: AppSettings.headlineStyle,
                          ),
                        ),
                        SizedBox(
                          height: 175,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemCount: movieService.recommendations.length,
                            itemBuilder: (context, index) {
                              final movie = movieService.recommendations[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(movie: movie),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  margin: EdgeInsets.only(right: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          '${AppSettings.imageBaseUrl}${movie.posterPath}',
                                          height: 150,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        movie.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != 0) {
            switch (index) {
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SavedScreen()),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadsScreen()),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
            }
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}

