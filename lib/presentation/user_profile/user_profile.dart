import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/account_settings_widget.dart';
import './widgets/address_management_widget.dart';
import './widgets/health_profile_widget.dart';
import './widgets/help_support_widget.dart';
import './widgets/order_history_card_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/security_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@email.com',
    'phone': '+1 (555) 123-4567',
    'membershipStatus': 'Premium',
    'avatar':
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'emergencyContact': '+1 (555) 987-6543',
    'addresses': [
      {
        'id': 1,
        'label': 'Home',
        'address': '123 Main Street, Apt 4B',
        'city': 'New York',
        'state': 'NY',
        'zipCode': '10001',
        'isDefault': true,
      },
      {
        'id': 2,
        'label': 'Work',
        'address': '456 Business Ave, Suite 200',
        'city': 'New York',
        'state': 'NY',
        'zipCode': '10002',
        'isDefault': false,
      },
    ],
    'healthProfile': {
      'allergies': ['Penicillin', 'Shellfish'],
      'conditions': ['Hypertension', 'Diabetes Type 2'],
      'medications': ['Lisinopril 10mg', 'Metformin 500mg'],
    },
    'settings': {
      'notifications': {
        'orderUpdates': true,
        'promotions': false,
        'healthReminders': true,
      },
      'privacy': {
        'shareHealthData': false,
        'marketingEmails': true,
      },
      'theme': 'light',
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(colorScheme),
            _buildTabBar(colorScheme),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileTab(),
                  _buildAddressesTab(),
                  _buildOrdersTab(),
                  _buildHealthTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
<<<<<<< HEAD
          currentIndex:2,
          cartItemCount: 3,
        ),
=======
        currentIndex: 2,
        cartItemCount: 3,
      ),
>>>>>>> 433df56c2af04b054ab4899e73a887e23f80d614
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: colorScheme.onSurface,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Profile',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 20,
            ),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: AppTheme.textSecondaryLight,
        indicatorColor: colorScheme.primary,
        labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.bodyMedium,
        isScrollable: true,
        tabs: const [
          Tab(text: 'Profile'),
          Tab(text: 'Addresses'),
          Tab(text: 'Orders'),
          Tab(text: 'Health'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ProfileHeaderWidget(
            userData: _userData,
            onEditAvatar: _handleEditAvatar,
            onEditProfile: _handleEditProfile,
          ),
          SizedBox(height: 3.h),
          PersonalInfoSectionWidget(
            userData: _userData,
            onEdit: _handleEditPersonalInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: AddressManagementWidget(
        addresses: _userData['addresses'],
        onAddAddress: _handleAddAddress,
        onEditAddress: _handleEditAddress,
        onDeleteAddress: _handleDeleteAddress,
        onSetDefault: _handleSetDefaultAddress,
      ),
    );
  }

  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: OrderHistoryCardWidget(
        onViewAllOrders: () {
          Navigator.pushNamed(context, '/order-tracking');
        },
        onReorder: _handleReorder,
      ),
    );
  }

  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: HealthProfileWidget(
        healthData: _userData['healthProfile'],
        onUpdateHealth: _handleUpdateHealth,
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AccountSettingsWidget(
            settings: _userData['settings'],
            onSettingsChanged: _handleSettingsChange,
          ),
          SizedBox(height: 3.h),
          SecuritySectionWidget(
            onChangePassword: _handleChangePassword,
            onToggleBiometrics: _handleToggleBiometrics,
          ),
          SizedBox(height: 3.h),
          HelpSupportWidget(
            onContactSupport: _handleContactSupport,
            onViewFAQ: _handleViewFAQ,
          ),
          SizedBox(height: 3.h),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorLight,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Logout',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(iconName: 'share', size: 24),
              title: const Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                _handleShareProfile();
              },
            ),
            ListTile(
              leading: const CustomIconWidget(iconName: 'download', size: 24),
              title: const Text('Export Data'),
              onTap: () {
                Navigator.pop(context);
                _handleExportData();
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'delete',
                color: Colors.red,
                size: 24,
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleDeleteAccount();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Event handlers
  void _handleEditAvatar() {
    // Implement avatar editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avatar editing feature')),
    );
  }

  void _handleEditProfile() {
    // Implement profile editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing feature')),
    );
  }

  void _handleEditPersonalInfo() {
    // Implement personal info editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal info editing feature')),
    );
  }

  void _handleAddAddress() {
    // Implement add address
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add address feature')),
    );
  }

  void _handleEditAddress(Map<String, dynamic> address) {
    // Implement edit address
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${address["label"]} address')),
    );
  }

  void _handleDeleteAddress(int addressId) {
    setState(() {
      _userData['addresses'].removeWhere((addr) => addr['id'] == addressId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address deleted')),
    );
  }

  void _handleSetDefaultAddress(int addressId) {
    setState(() {
      for (var addr in _userData['addresses']) {
        addr['isDefault'] = addr['id'] == addressId;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default address updated')),
    );
  }

  void _handleReorder(int orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reordering items from order #$orderId')),
    );
  }

  void _handleUpdateHealth(Map<String, dynamic> healthData) {
    setState(() {
      _userData['healthProfile'] = healthData;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Health profile updated')),
    );
  }

  void _handleSettingsChange(Map<String, dynamic> newSettings) {
    setState(() {
      _userData['settings'] = newSettings;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings updated')),
    );
  }

  void _handleChangePassword() {
    // Implement password change
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password change feature')),
    );
  }

  void _handleToggleBiometrics(bool enabled) {
    // Implement biometrics toggle
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Biometrics ${enabled ? 'enabled' : 'disabled'}')),
    );
  }

  void _handleContactSupport() {
    // Implement contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacting support...')),
    );
  }

  void _handleViewFAQ() {
    // Implement FAQ view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening FAQ...')),
    );
  }

  void _handleShareProfile() {
    // Implement profile sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing profile...')),
    );
  }

  void _handleExportData() {
    // Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting data...')),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).clearSnackBars();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
