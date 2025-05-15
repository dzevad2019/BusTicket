import 'package:bus_ticket_mobile/models/company.dart';
import 'package:bus_ticket_mobile/providers/base_provider.dart';
import 'package:bus_ticket_mobile/providers/companies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({Key? key}) : super(key: key);

  @override
  _CompaniesPageState createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final int _itemsPerPage = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<Company> _companies = [];

  late CompaniesProvider _companiesProvider;

  final ScrollController _scrollController = ScrollController();
  final double _cardElevation = 2.0;
  final Color _primaryColor = Colors.indigo.shade700;
  final Color _accentColor = Colors.tealAccent.shade400;

  @override
  void initState() {
    super.initState();
    _companiesProvider = context.read<CompaniesProvider>();
    _loadCompanies();
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
        _loadCompanies();
      }
    }
  }

  Future<void> _loadCompanies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {

      var params = {
        'PageNumber': _currentPage.toString(),
        'PageSize': _itemsPerPage.toString(),
      };

      var response = await _companiesProvider.getForPagination(params);
      var newCompanies = response.items;
      setState(() {
        _isLoading = false;
        _companies.addAll(newCompanies);
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
          content: Text('Failed to load companies'),
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
      _companies.clear();
      _hasMore = true;
    });
    await _loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prevoznici',
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
              if (_companies.isEmpty && !_isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business, size: 80, color: Colors.grey.shade400),
                        SizedBox(height: 20),
                        Text(
                          'No companies found',
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
                        if (index >= _companies.length) {
                          return _buildLoader();
                        }
                        return _buildCompanyCard(_companies[index]);
                      },
                      childCount: _companies.length + (_hasMore ? 1 : 0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(Company company) {
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
            // Handle company tap
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                        image: company.logoUrl != null
                        && company.logoUrl.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(BaseProvider.apiUrl + company.logoUrl!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: company.logoUrl == null
                          ? Icon(Icons.business, size: 30, color: Colors.grey.shade400)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: _primaryColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            company.city?.name ?? 'Unknown City',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: company.active
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        company.active ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: company.active ? Colors.green.shade800 : Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildInfoRow(Icons.phone, company.phoneNumber),
                _buildInfoRow(Icons.email, company.email),
                if (company.webPage != null && company.webPage!.isNotEmpty)
                  _buildInfoRow(Icons.public, company.webPage!),
                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (company.taxNumber != null)
                      _buildDetailChip('Tax: ${company.taxNumber}'),
                    if (company.identificationNumber != null)
                      _buildDetailChip('ID: ${company.identificationNumber}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
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
          'No more companies',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}