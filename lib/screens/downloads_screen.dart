import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_settings.dart';
import '../models/movie_model.dart';
import '../services/download_service.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/saved_screen.dart';
import '../screens/search_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/custom_bottom_nav222.dart';

class DownloadsScreen extends StatefulWidget {
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text('Downloads'),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Downloaded'),
              Tab(text: 'Downloading'),
            ],
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDownloadedTab(),
                _buildDownloadingTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                break;
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

  Widget _buildDownloadedTab() {
    return FutureBuilder<List<Movie>>(
      future: _downloadService.getDownloadedMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No downloaded movies', style: TextStyle(color: Colors.white)));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final movie = snapshot.data![index];
              return _buildMovieCard(movie);
            },
          );
        }
      },
    );
  }

  Widget _buildDownloadingTab() {
    // TODO: Implement downloading movies list
    return Center(child: Text('No movies currently downloading', style: TextStyle(color: Colors.white)));
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color(0xFF1F1F3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${AppSettings.imageBaseUrl}${movie.posterPath}',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    movie.genres.join(', '),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${_formatDuration(movie.runtime)} | ${_formatFileSize(movie.fileSize)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // TODO: Implement options menu
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

