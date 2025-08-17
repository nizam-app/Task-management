import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shift_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shift_card.dart';
import '../../widgets/shift_details_dialog.dart';

class ShiftClaimingScreen extends StatefulWidget {
  const ShiftClaimingScreen({super.key});

  @override
  State<ShiftClaimingScreen> createState() => _ShiftClaimingScreenState();
}

class _ShiftClaimingScreenState extends State<ShiftClaimingScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with search and filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Shifts',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Consumer<ShiftProvider>(
                      builder: (context, shiftProvider, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.lightBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${shiftProvider.availableShifts.length} Available',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search shifts...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.gray200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppTheme.gray200),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          Provider.of<ShiftProvider>(context, listen: false)
                              .filterShifts(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _showFilterDialog,
                      icon: const Icon(Icons.tune, size: 18),
                      label: const Text('Filter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Shifts list
          Expanded(
            child: Consumer<ShiftProvider>(
              builder: (context, shiftProvider, _) {
                if (shiftProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (shiftProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load shifts',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shiftProvider.error!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => shiftProvider.loadShifts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final availableShifts = shiftProvider.availableShifts;
                
                if (availableShifts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No shifts available',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for new opportunities',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => shiftProvider.loadShifts(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => shiftProvider.loadShifts(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: availableShifts.length,
                    itemBuilder: (context, index) {
                      final shift = availableShifts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ShiftCard(
                          shift: shift,
                          onClaim: () => _claimShift(context, shift),
                          onViewDetails: () => _showShiftDetails(context, shift),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Shifts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Urgent Only'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Day Shifts'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Night Shifts'),
              value: false,
              onChanged: (value) {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Department'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Distance'),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showShiftDetails(BuildContext context, shift) {
    showDialog(
      context: context,
      builder: (context) => ShiftDetailsDialog(shift: shift),
    );
  }

  void _claimShift(BuildContext context, shift) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Shift'),
        content: Text('Are you sure you want to claim this shift at ${shift.facility}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<ShiftProvider>(context, listen: false)
                  .claimShift(shift.id)
                  .then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Shift claimed successfully!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              });
            },
            child: const Text('Claim'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}