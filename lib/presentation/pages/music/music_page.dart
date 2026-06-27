import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  bool _isPlaying = true;
  double _volume = 0.8;
  int _currentTrack = 0;

  static const _queue = [
    {'title': 'Blinding Lights', 'artist': 'The Weeknd', 'duration': '3:20'},
    {'title': 'Stay', 'artist': 'The Kid LAROI', 'duration': '2:21'},
    {'title': 'Levitating', 'artist': 'Dua Lipa', 'duration': '3:23'},
    {'title': 'Peaches', 'artist': 'Justin Bieber', 'duration': '3:17'},
    {'title': 'Good 4 U', 'artist': 'Olivia Rodrigo', 'duration': '2:58'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = _queue[_currentTrack];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF57F287), Color(0xFF43B581)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Album Art
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF5865F2), Color(0xFFEB459E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.discordBlurple.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 80,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

            const SizedBox(height: 28),

            // Track Info
            Text(
              current['title']!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              current['artist']!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: isDark ? Colors.white60 : Colors.black45,
              ),
            ),

            const SizedBox(height: 24),

            // Progress Bar
            Column(
              children: [
                Slider(
                  value: 0.35,
                  onChanged: (_) {},
                  activeColor: AppColors.discordGreen,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1:10', style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
                      Text(current['duration']!, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle_rounded),
                  color: AppColors.discordGreen,
                  iconSize: 24,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  color: isDark ? Colors.white : Colors.black87,
                  iconSize: 36,
                  onPressed: () {
                    setState(() {
                      _currentTrack =
                          (_currentTrack - 1 + _queue.length) % _queue.length;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF57F287), Color(0xFF43B581)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.discordGreen.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  color: isDark ? Colors.white : Colors.black87,
                  iconSize: 36,
                  onPressed: () {
                    setState(() {
                      _currentTrack = (_currentTrack + 1) % _queue.length;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.repeat_rounded),
                  color: isDark ? Colors.white54 : Colors.black38,
                  iconSize: 24,
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Volume
            Row(
              children: [
                const Icon(Icons.volume_down, color: Colors.grey, size: 20),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: (v) => setState(() => _volume = v),
                    activeColor: AppColors.discordBlurple,
                  ),
                ),
                const Icon(Icons.volume_up, color: Colors.grey, size: 20),
              ],
            ),

            const SizedBox(height: 24),

            // Queue
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Queue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Clear All'),
                ),
              ],
            ),

            ..._queue.asMap().entries.map((e) {
              final isActive = e.key == _currentTrack;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.discordGreen.withOpacity(0.15)
                        : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isActive ? Icons.equalizer_rounded : Icons.music_note_rounded,
                    color: isActive ? AppColors.discordGreen : Colors.grey,
                    size: 20,
                  ),
                ),
                title: Text(
                  e.value['title']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppColors.discordGreen
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                subtitle: Text(
                  e.value['artist']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white45 : Colors.black38,
                  ),
                ),
                trailing: Text(
                  e.value['duration']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: isDark ? Colors.white45 : Colors.black38,
                  ),
                ),
                onTap: () => setState(() => _currentTrack = e.key),
              );
            }),
          ],
        ),
      ),
    );
  }
}
