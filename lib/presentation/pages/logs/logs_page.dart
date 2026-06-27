import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/models/log_model.dart';
import '../../providers/websocket_provider.dart';
import '../../widgets/log_entry_widget.dart';

class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> {
  LogCategory? _selectedCategory;
  LogSeverity? _selectedSeverity;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LogModel> _filterLogs(List<LogModel> logs) {
    return logs.where((log) {
      if (_selectedCategory != null && log.category != _selectedCategory) {
        return false;
      }
      if (_selectedSeverity != null && log.severity != _selectedSeverity) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return log.title.toLowerCase().contains(q) ||
            log.description.toLowerCase().contains(q) ||
            (log.username?.toLowerCase().contains(q) ?? false) ||
            (log.targetName?.toLowerCase().contains(q) ?? false);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(realtimeLogsProvider);
    final wsState = ref.watch(webSocketProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredLogs = _filterLogs(logs);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        actions: [
          // WebSocket status
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (wsState.status == WsStatus.connected
                      ? AppColors.discordGreen
                      : AppColors.discordRed)
                  .withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: wsState.status == WsStatus.connected
                        ? AppColors.discordGreen
                        : AppColors.discordRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  wsState.status == WsStatus.connected ? 'Live' : 'Offline',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: wsState.status == WsStatus.connected
                        ? AppColors.discordGreen
                        : AppColors.discordRed,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(webSocketProvider.notifier).reconnect(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search logs...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),

          // Category Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(
                    label: 'All',
                    isSelected: _selectedCategory == null,
                    color: AppColors.discordBlurple,
                    onTap: () => setState(() => _selectedCategory = null),
                  ),
                  ...LogCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _CategoryChip(
                        label: cat.name.capitalize,
                        isSelected: isSelected,
                        color: _getCategoryColor(cat),
                        onTap: () => setState(() =>
                            _selectedCategory = isSelected ? null : cat),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Severity Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: LogSeverity.values.map((sev) {
                  final isSelected = _selectedSeverity == sev;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(sev.name.capitalize),
                      selected: isSelected,
                      onSelected: (_) => setState(() =>
                          _selectedSeverity = isSelected ? null : sev),
                      selectedColor: _getSeverityColor(sev).withOpacity(0.2),
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: isSelected
                            ? _getSeverityColor(sev)
                            : (isDark ? Colors.white54 : Colors.black45),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Log count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Text(
                  '${filteredLogs.length} entries',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                const Spacer(),
                if (_selectedCategory != null || _selectedSeverity != null)
                  TextButton(
                    onPressed: () => setState(() {
                      _selectedCategory = null;
                      _selectedSeverity = null;
                    }),
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          // Logs List
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No logs match your filters',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredLogs.length,
                    itemBuilder: (_, i) => LogEntryWidget(
                      log: filteredLogs[i],
                    )
                        .animate(delay: Duration(milliseconds: i < 10 ? i * 30 : 0))
                        .fadeIn(duration: 300.ms),
                  ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(LogCategory cat) {
    switch (cat) {
      case LogCategory.moderation:
        return AppColors.discordRed;
      case LogCategory.messages:
        return AppColors.discordBlurple;
      case LogCategory.voice:
        return const Color(0xFF9B59B6);
      case LogCategory.members:
        return AppColors.discordGreen;
      case LogCategory.server:
        return AppColors.discordYellow;
      case LogCategory.bot:
        return const Color(0xFF00B0F4);
      case LogCategory.commands:
        return AppColors.discordFuchsia;
      case LogCategory.security:
        return const Color(0xFFFF7043);
    }
  }

  Color _getSeverityColor(LogSeverity sev) {
    switch (sev) {
      case LogSeverity.info:
        return const Color(0xFF00B0F4);
      case LogSeverity.warning:
        return AppColors.discordYellow;
      case LogSeverity.error:
        return AppColors.discordRed;
      case LogSeverity.success:
        return AppColors.discordGreen;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
          ),
        ),
      ),
    );
  }
}
