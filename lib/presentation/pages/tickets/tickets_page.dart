import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/ticket_model.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TicketStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tickets = TicketModel.mockList;

    final open = tickets.where((t) => t.status == TicketStatus.open).toList();
    final inProgress =
        tickets.where((t) => t.status == TicketStatus.inProgress).toList();
    final closed = tickets
        .where((t) =>
            t.status == TicketStatus.closed ||
            t.status == TicketStatus.resolved)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5865F2), Color(0xFF7B68EE)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Open (${open.length})'),
            Tab(text: 'In Progress (${inProgress.length})'),
            Tab(text: 'Closed (${closed.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Row
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _TicketStat(
                  label: 'Total',
                  value: tickets.length.toString(),
                  color: AppColors.discordBlurple,
                  icon: Icons.confirmation_num_rounded,
                ),
                const SizedBox(width: 12),
                _TicketStat(
                  label: 'Avg Response',
                  value: '2.3h',
                  color: AppColors.discordGreen,
                  icon: Icons.timer_outlined,
                ),
                const SizedBox(width: 12),
                _TicketStat(
                  label: 'Resolved',
                  value: '94%',
                  color: AppColors.discordYellow,
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TicketList(tickets: open),
                _TicketList(tickets: inProgress),
                _TicketList(tickets: closed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  final List<TicketModel> tickets;

  const _TicketList({required this.tickets});

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'No tickets here',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black45,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tickets.length,
      itemBuilder: (_, i) =>
          _TicketCard(ticket: tickets[i]).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideY(begin: 0.2),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = _getPriorityColor(ticket.priority);
    final statusColor = _getStatusColor(ticket.status);

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: priorityColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ticket.id,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.discordBlurple,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.priority.name.toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket.status.name.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ticket.title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ticket.description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.discordBlurple.withOpacity(0.15),
                  child: Text(
                    ticket.creatorName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.discordBlurple,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  ticket.creatorName,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                if (ticket.assignedToName != null) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_right, size: 14,
                      color: isDark ? Colors.white38 : Colors.black26),
                  const SizedBox(width: 2),
                  Text(
                    ticket.assignedToName!,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.discordGreen,
                    ),
                  ),
                ],
                const Spacer(),
                Icon(Icons.chat_bubble_outline,
                    size: 12,
                    color: isDark ? Colors.white38 : Colors.black26),
                const SizedBox(width: 3),
                Text(
                  ticket.messageCount.toString(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black26,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatAge(ticket.age),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black26,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TicketPriority p) {
    switch (p) {
      case TicketPriority.low:
        return AppColors.discordGreen;
      case TicketPriority.medium:
        return AppColors.discordYellow;
      case TicketPriority.high:
        return AppColors.discordRed;
      case TicketPriority.urgent:
        return const Color(0xFFFF1744);
    }
  }

  Color _getStatusColor(TicketStatus s) {
    switch (s) {
      case TicketStatus.open:
        return AppColors.discordGreen;
      case TicketStatus.inProgress:
        return AppColors.discordBlurple;
      case TicketStatus.waiting:
        return AppColors.discordYellow;
      case TicketStatus.closed:
        return Colors.grey;
      case TicketStatus.resolved:
        return AppColors.discordGreen;
    }
  }

  String _formatAge(Duration d) {
    if (d.inDays > 0) return '${d.inDays}d ago';
    if (d.inHours > 0) return '${d.inHours}h ago';
    return '${d.inMinutes}m ago';
  }
}

class _TicketStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _TicketStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
