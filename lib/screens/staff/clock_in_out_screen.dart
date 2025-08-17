import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme/app_theme.dart';

class ClockInOutScreen extends StatefulWidget {
  const ClockInOutScreen({super.key});

  @override
  State<ClockInOutScreen> createState() => _ClockInOutScreenState();
}

class _ClockInOutScreenState extends State<ClockInOutScreen> {
  bool _isOnShift = false;
  bool _isOnBreak = false;
  String _locationStatus = 'checking';
  String? _clockInTime;
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    setState(() => _locationStatus = 'checking');

    try {
      // Check location permission
      var status = await Permission.location.status;
      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isGranted) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        
        // Simulate facility location check
        await Future.delayed(const Duration(seconds: 2));
        
        // Mock location validation (in real app, this would check against facility coordinates)
        bool isAtFacility = _validateLocation(position);
        
        setState(() {
          _locationStatus = isAtFacility ? 'valid' : 'invalid';
          _currentLocation = 'Mercy General Hospital';
        });
      } else {
        setState(() => _locationStatus = 'disabled');
      }
    } catch (e) {
      setState(() => _locationStatus = 'error');
    }
  }

  bool _validateLocation(Position position) {
    // Mock validation - in real app, would check distance to facility
    return true; // Simulating valid location
  }

  void _clockIn() {
    if (_locationStatus != 'valid') return;
    
    setState(() {
      _isOnShift = true;
      _clockInTime = TimeOfDay.now().format(context);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clocked in successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _clockOut() {
    setState(() {
      _isOnShift = false;
      _isOnBreak = false;
      _clockInTime = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clocked out successfully!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _toggleBreak() {
    setState(() => _isOnBreak = !_isOnBreak);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnBreak ? 'Break started' : 'Break ended'),
        backgroundColor: AppTheme.warningYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Text(
              'Time Clock',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your work hours securely',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.gray600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Current shift info
            _buildCurrentShiftCard(),
            
            const SizedBox(height: 16),
            
            // Location status
            _buildLocationStatusCard(),
            
            const SizedBox(height: 16),
            
            // Security notice
            _buildSecurityNotice(),
            
            const SizedBox(height: 24),
            
            // Clock actions
            _buildClockActions(),
            
            const SizedBox(height: 24),
            
            // Recent activity
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentShiftCard() {
    return Card(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.lightBlue, AppTheme.lightTeal],
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mercy General Hospital',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Registered Nurse - ICU',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scheduled',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                      Text(
                        '7:00 AM - 7:00 PM',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isOnShift ? AppTheme.successGreen : AppTheme.gray200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _isOnShift ? 'On Shift' : 'Not Clocked In',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _isOnShift ? Colors.white : AppTheme.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStatusCard() {
    IconData icon;
    Color iconColor;
    String statusText;
    String statusMessage;

    switch (_locationStatus) {
      case 'checking':
        icon = Icons.location_searching;
        iconColor = AppTheme.primaryBlue;
        statusText = 'Checking...';
        statusMessage = 'Verifying your location...';
        break;
      case 'valid':
        icon = Icons.check_circle;
        iconColor = AppTheme.successGreen;
        statusText = 'Verified';
        statusMessage = 'You are at the correct facility location';
        break;
      case 'invalid':
        icon = Icons.error;
        iconColor = AppTheme.errorRed;
        statusText = 'Invalid Location';
        statusMessage = 'You must be at the facility to clock in';
        break;
      case 'disabled':
        icon = Icons.location_disabled;
        iconColor = AppTheme.gray600;
        statusText = 'GPS Disabled';
        statusMessage = 'Please enable GPS to clock in';
        break;
      default:
        icon = Icons.error_outline;
        iconColor = AppTheme.errorRed;
        statusText = 'Error';
        statusMessage = 'Unable to verify location';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Location Verification',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: iconColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusMessage,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.gray600,
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

  Widget _buildSecurityNotice() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.security,
              color: Colors.amber,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Notice',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our system uses advanced GPS and network verification to prevent location spoofing. Any attempts to manipulate location data will be detected and reported.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber.shade800,
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

  Widget _buildClockActions() {
    if (!_isOnShift) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _locationStatus == 'valid' ? _clockIn : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login),
              const SizedBox(width: 8),
              const Text('Clock In'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Current session info
        Card(
          color: AppTheme.successGreen.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Currently On Shift',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.successGreen.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isOnBreak ? AppTheme.warningYellow : AppTheme.successGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isOnBreak ? 'On Break' : 'Active',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Clocked In',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.successGreen,
                            ),
                          ),
                          Text(
                            _clockInTime ?? '',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.successGreen.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours Worked',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.successGreen,
                            ),
                          ),
                          Text(
                            '3.5 hrs',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.successGreen.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Break button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _toggleBreak,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: _isOnBreak ? AppTheme.primaryBlue : AppTheme.warningYellow,
              ),
              foregroundColor: _isOnBreak ? AppTheme.primaryBlue : AppTheme.warningYellow,
            ),
            child: Text(_isOnBreak ? 'End Break' : 'Start Break'),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Clock out button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _clockOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: 8),
                const Text('Clock Out'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {'date': '2025-08-15', 'action': 'Clocked Out', 'duration': '12.0 hrs', 'facility': 'Mercy General'},
      {'date': '2025-08-14', 'action': 'Clocked Out', 'duration': '8.0 hrs', 'facility': 'Valley Care'},
      {'date': '2025-08-13', 'action': 'Clocked Out', 'duration': '12.0 hrs', 'facility': 'Mercy General'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            ...activities.map((activity) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['facility']!,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          activity['date']!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        activity['duration']!,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        activity['action']!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}