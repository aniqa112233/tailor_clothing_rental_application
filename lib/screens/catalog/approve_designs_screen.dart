
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApproveDesignsScreen extends StatefulWidget {
  const ApproveDesignsScreen({super.key});

  @override
  State<ApproveDesignsScreen> createState() => _ApproveDesignsScreenState();
}

class _ApproveDesignsScreenState extends State<ApproveDesignsScreen>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  bool loading = false;
  List<Map<String, dynamic>> pendingDesigns = [];
  List<Map<String, dynamic>> processedDesigns = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPendingDesigns();
    _fetchProcessedDesigns();
  }

  Future<void> _fetchPendingDesigns() async {
    try {
      setState(() => loading = true);
      final response = await supabase
          .from('custom_designs')
          .select()
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      setState(() {
        pendingDesigns = List<Map<String, dynamic>>.from(response);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching designs: $e')));
    }
  }

  Future<void> _fetchProcessedDesigns() async {
    try {
      final response = await supabase
          .from('custom_designs')
          .select()
          .inFilter('status', ['approved', 'rejected'])
          .order('created_at', ascending: false);

      setState(() {
        processedDesigns = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching processed: $e')));
    }
  }

  Future<void> _approveDesign(String id) async {
    try {
      await supabase
          .from('custom_designs')
          .update({'status': 'approved'}).eq('id', id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Design approved successfully!')),
      );

      _fetchPendingDesigns();
      _fetchProcessedDesigns();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error approving design: $e')));
    }
  }

  Future<void> _rejectDesign(String id) async {
    try {
      await supabase
          .from('custom_designs')
          .update({'status': 'rejected'}).eq('id', id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Design rejected!')),
      );

      _fetchPendingDesigns();
      _fetchProcessedDesigns();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error rejecting design: $e')));
    }
  }

  Widget _buildDesignCard(Map<String, dynamic> design,
      {bool showActions = true}) {
    final status = design['status'] ?? '';
    Color statusColor;
    String statusLabel;

    if (status == 'approved') {
      statusColor = Colors.green;
      statusLabel = 'Approved';
    } else if (status == 'rejected') {
      statusColor = Colors.redAccent;
      statusLabel = 'Rejected';
    } else {
      statusColor = Colors.orange;
      statusLabel = 'Pending';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            design['image_url'] != null &&
                    design['image_url'].toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      design['image_url'],
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Placeholder(fallbackHeight: 150, color: Colors.grey),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes: ${design['notes'] ?? 'No notes'}',
                  style: const TextStyle(fontSize: 15),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Uploaded by: ${design['user_id']}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            if (showActions)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () =>
                        _approveDesign(design['id'].toString()),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _rejectDesign(design['id'].toString()),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Custom Designs'),

        // ⭐⭐ SAME TABBAR STYLE AS REVIEWS SCREEN ⭐⭐
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved / Rejected'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchPendingDesigns();
              _fetchProcessedDesigns();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          loading
              ? const Center(child: CircularProgressIndicator())
              : pendingDesigns.isEmpty
                  ? const Center(
                      child: Text(
                        'No pending designs to approve 🎉',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: pendingDesigns.length,
                      itemBuilder: (context, i) => _buildDesignCard(
                        pendingDesigns[i],
                        showActions: true,
                      ),
                    ),
          processedDesigns.isEmpty
              ? const Center(
                  child: Text(
                    'No approved or rejected designs yet',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: processedDesigns.length,
                  itemBuilder: (context, i) => _buildDesignCard(
                    processedDesigns[i],
                    showActions: false,
                  ),
                ),
        ],
      ),
    );
  }
}
