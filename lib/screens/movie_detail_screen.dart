import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie_model.dart';
import '../services/download_service.dart';
import '../services/user_service.dart';
import '../services/movie_service.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DownloadService _downloadService = DownloadService();
  final UserService _userService = UserService();
  bool _isExpanded = false;
  bool _isBookmarked = false;
  bool _isPlaying = false;
  bool _showPlayer = false;
  YoutubePlayerController? _youtubeController;
  String? _trailerUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkIfBookmarked();
    _loadTrailer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _checkIfBookmarked() async {
    final isBookmarked = await _userService.isMovieBookmarked(widget.movie.id);
    setState(() {
      _isBookmarked = isBookmarked;
    });
  }

  Future<void> _toggleBookmark() async {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    if (_isBookmarked) {
      await _userService.addBookmark(widget.movie);
    } else {
      await _userService.removeBookmark(widget.movie.id);
    }
  }

  Future<void> _loadTrailer() async {
    final movieService = Provider.of<MovieService>(context, listen: false);
    final trailerUrl = await movieService.getMovieTrailer(widget.movie.id);
    if (trailerUrl != null) {
      setState(() {
        _trailerUrl = trailerUrl;
      });
      _initializeYoutubePlayer();
    }
  }

  void _initializeYoutubePlayer() {
    if (_trailerUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(_trailerUrl!);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _showPlayer = true;
      if (_isPlaying) {
        _youtubeController?.play();
      } else {
        _youtubeController?.pause();
      }
    });
  }

  String _formatDuration(int minutes) {
    if (minutes == 0) return 'N/A';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white, size: 20),
            onPressed: () {
              Share.share('Check out ${widget.movie.title}!');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.movie.backdropUrl ?? widget.movie.posterUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xFF1A1A1A).withOpacity(0.8),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                ),
              ),
            ),

            // Movie Info
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.movie.releaseDate.year} • ${widget.movie.genres.take(2).join(', ')} • ${_formatDuration(widget.movie.runtime)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.movie.overview,
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : 'Read more',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.download),
                      label: Text('Download'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color(0xFF2A2A2A),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        await _downloadService.downloadMovie(widget.movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Download started')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // YouTube Player
            if (_showPlayer && _youtubeController != null)
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.red,
                      bufferedColor: Colors.grey[700]!,
                      backgroundColor: Colors.grey[900]!,
                    ),
                    onEnded: (data) {
                      setState(() {
                        _isPlaying = false;
                      });
                    },
                  ),
                ),
              ),

            // Tabs
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Episode'),
                      Tab(text: 'Similar'),
                      Tab(text: 'About'),
                    ],
                    indicatorColor: Colors.red,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(16),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildEpisodeTab(),
                        _buildSimilarTab(),
                        _buildAboutTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodeTab() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.movie.posterUrl ?? '',
            width: 100,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.movie, size: 60, color: Colors.grey),
          ),
        ),
        title: Text(
          'Trailer',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          widget.movie.overview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Icon(Icons.download, color: Colors.white),
      ),
    );
  }

  Widget _buildSimilarTab() {
    return Center(
      child: Text(
        'Similar movies will appear here',
        style: TextStyle(color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildAboutTab() {
    return ListView(
      children: [
        _buildAboutItem('Director', 'Guy Ritchie'),
        _buildAboutItem('Cast', 'Will Smith, Mena Massoud, Naomi Scott'),
        _buildAboutItem('Writer', 'John August, Guy Ritchie'),
        _buildAboutItem('Genre', widget.movie.genres.join(', ')),
        _buildAboutItem('Release', widget.movie.releaseDate.year.toString()),
        _buildAboutItem('Duration', _formatDuration(widget.movie.runtime)),
      ],
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

