import 'dart:async';

import 'package:bus_ticket_mobile/models/bus_stop.dart';
import 'package:bus_ticket_mobile/providers/bus_stops_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusStopsPage extends StatefulWidget {

  const BusStopsPage({Key? key}) : super(key: key);

  @override
  _BusStopsPageState createState() => _BusStopsPageState();
}

class _BusStopsPageState extends State<BusStopsPage> {
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<BusStop> _busStops = [];

  late BusStopsProvider _busStopsProvider;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _searchDebounce;

  final ScrollController _scrollController = ScrollController();
  final double _cardElevation = 2.0;
  final Color _primaryColor = Colors.deepPurple.shade700;
  final Color _accentColor = Colors.amber.shade600;

  @override
  void initState() {
    super.initState();
    _busStopsProvider = context.read<BusStopsProvider>();
    _loadBusStops();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _currentPage = 1;
        _hasMore = true;

        _loadBusStops();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoading && _hasMore) {
        _loadBusStops();
      }
    }
  }

  Future<void> _loadBusStops() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var params = {
        'PageNumber': _currentPage.toString(),
        'PageSize': _itemsPerPage.toString(),
        'SearchFilter': _searchQuery
      };

      var response = await _busStopsProvider.getForPagination(params);
      var newCompanies = response.items;
      setState(() {
        _isLoading = false;

        if (_searchQuery.isNotEmpty || _currentPage == 1) {
          _busStops.clear();
        }

        _busStops.addAll(newCompanies);
        _currentPage++;

        if (newCompanies.length < _itemsPerPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load bus stops'),
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
      _busStops.clear();
      _hasMore = true;
    });
    await _loadBusStops();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autobuske stanice',
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
          color: _primaryColor,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _buildSearchField(),
                ),
              ),
              if (_busStops.isEmpty && !_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_bus, size: 80, color: Colors.grey.shade400),
                        SizedBox(height: 20),
                        Text(
                          'No bus stops found',
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
                        if (index >= _busStops.length) {
                          return _buildLoader();
                        }
                        return _buildBusStopCard(_busStops[index]);
                      },
                      childCount: _busStops.length + (_hasMore ? 1 : 0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Pretraga po nazivu...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey.shade600),
              onPressed: () {
                _searchController.clear();
              },
            )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildBusStopCard(BusStop busStop) {
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
            // Handle bus stop tap
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.directions_bus,
                    color: _primaryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busStop.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        busStop.city?.name ?? 'Unknown City',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                //Icon(
                //  Icons.chevron_right,
                //  color: Colors.grey.shade400,
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
          'No more bus stops',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
