import 'package:bus_ticket_mobile/models/notification.dart';
import 'package:bus_ticket_mobile/providers/notifications_provider.dart';
import 'package:bus_ticket_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationsProvider? _notificationsProvider = null;
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<NotificationData> _notifications = [];

  final ScrollController _scrollController = ScrollController();
  final double _cardElevation = 2.0;
  final Color _primaryColor = Colors.blue.shade700;
  final Color _accentColor = Colors.amber.shade600;

  @override
  void initState() {
    super.initState();
    _notificationsProvider = context.read<NotificationsProvider>();
    _loadNotifications();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading && _hasMore) {
        _loadNotifications();
      }
    }
  }

  Future<void> _loadNotifications() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var params = {
        'PageNumber': _currentPage.toString(),
        'PageSize': _itemsPerPage.toString(),
        'UserId': Authorization.id.toString(),
      };

      var newNotifications =
      await _notificationsProvider!.getForPagination(params);

      setState(() {
        _isLoading = false;
        _notifications.addAll(newNotifications.items);
        _currentPage++;

        if (newNotifications.items.length < _itemsPerPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load notifications'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1;
      _notifications.clear();
      _hasMore = true;
    });
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikacije',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: RefreshIndicator(
          color: Colors.deepPurple,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (_notifications.isEmpty && !_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //SvgPicture.asset(
                        //  'assets/images/empty_notifications.svg',
                        //  height: 150,
                        //  color: Colors.grey.shade400,
                        //),
                        //SizedBox(height: 20),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (index >= _notifications.length) {
                            return _buildLoader();
                          }
                          return _buildNotificationItem(_notifications[index]);
                        },
                        childCount: _notifications.length + (_hasMore ? 1 : 0),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationData notification) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Card(
          elevation: _cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Handle notification tap
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(Icons.directions_bus,
                                size: 20,
                                color: Colors.deepPurple),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                notification.busLineName ?? 'Unknown Bus',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                ),
                                //overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat('MMM dd, yyyy')
                          .format(notification.departureDateTime!),
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  //SizedBox(height: 8),
                  //Row(
                  //  mainAxisAlignment: MainAxisAlignment.end,
                  //  children: [
                  //    Text(
                  //      DateFormat('hh:mm a')
                  //          .format(notification.departureDateTime!),
                  //      style: TextStyle(
                  //        fontSize: 12,
                  //        color: Colors.grey.shade600,
                  //      ),
                  //    ),
                  //  ],
                  //),
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(_accentColor),
          ),
        )
            : Text(
          'No more notifications',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}