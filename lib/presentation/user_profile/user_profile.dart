import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_settings_widget.dart';
import './widgets/add_edit_address_screen.dart';
import './widgets/address_management_widget.dart';
import './widgets/change_password_screen.dart';
import './widgets/edit_profile_screen.dart';
import './widgets/health_profile_widget.dart';
import './widgets/help_support_widget.dart';
import './widgets/order_history_card_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/security_section_widget.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  
  // User data map with defaults that will be replaced with actual data
  Map<String, dynamic> _userData = {
    'name': '',
    'email': '',
    'phone': '',
    'membershipStatus': 'Basic',
    'avatar': null,
    'emergencyContact': '',
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
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // First try to get data from local storage
      final storedUserData = await _authService.getUserData();
      
      if (storedUserData != null) {
        setState(() {
          _userData = {
            ..._userData,
            ...storedUserData,
          };
        });
      }
      
      // Then fetch the latest from the server
      final profileResponse = await _authService.getProfile();
      if (profileResponse.success && profileResponse.data != null) {
        setState(() {
          _userData = {
            ..._userData,
            ...(profileResponse.data ?? {}),
          };
        });
      }
    } catch (e) {
      // Handle error silently, we already have default values
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          if (Navigator.canPop(context))
            IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back_ios',
                color: colorScheme.onSurface,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            )
          else
            const SizedBox(width: 48),
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
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => Navigator.pushNamed(context, '/shopping-cart'),
              ),
              if (CartService().totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      CartService().totalItems > 99 ? '99+' : CartService().totalItems.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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

  Future<void> _showAddressForm({Map<String, dynamic>? initial}) async {
    final formKey = GlobalKey<FormState>();
    final labelCtrl = TextEditingController(text: initial?['label']?.toString() ?? '');
    final addressCtrl = TextEditingController(text: initial?['address']?.toString() ?? '');
    final cityCtrl = TextEditingController(text: initial?['city']?.toString() ?? '');
    final stateCtrl = TextEditingController(text: initial?['state']?.toString() ?? '');
    final zipCtrl = TextEditingController(text: initial?['zipCode']?.toString() ?? '');
    bool isDefault = (initial?['isDefault'] as bool?) ?? false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        initial == null ? 'Add Address' : 'Edit Address',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: labelCtrl,
                        decoration: const InputDecoration(labelText: 'Label (e.g., Home, Work)'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: addressCtrl,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cityCtrl,
                              decoration: const InputDecoration(labelText: 'City'),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: stateCtrl,
                              decoration: const InputDecoration(labelText: 'State/Province'),
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: zipCtrl,
                        decoration: const InputDecoration(labelText: 'ZIP/Postal Code'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Switch(
                            value: isDefault,
                            onChanged: (val) => setSheetState(() => isDefault = val),
                          ),
                          const SizedBox(width: 8),
                          const Text('Set as default'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          setState(() {
                            if (isDefault) {
                              for (var a in _userData['addresses']) {
                                a['isDefault'] = false;
                              }
                            }
                            if (initial == null) {
                              // new address
                              int newId = 1;
                              final addrs = List<Map<String, dynamic>>.from(_userData['addresses']);
                              if (addrs.isNotEmpty) {
                                try {
                                  newId = addrs.map((e) => e['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
                                } catch (_) {}
                              }
                              _userData['addresses'].add({
                                'id': newId,
                                'label': labelCtrl.text.trim(),
                                'address': addressCtrl.text.trim(),
                                'city': cityCtrl.text.trim(),
                                'state': stateCtrl.text.trim(),
                                'zipCode': zipCtrl.text.trim(),
                                'isDefault': isDefault,
                              });
                            } else {
                              // update existing
                              final id = initial['id'];
                              for (var a in _userData['addresses']) {
                                if (a['id'] == id) {
                                  a['label'] = labelCtrl.text.trim();
                                  a['address'] = addressCtrl.text.trim();
                                  a['city'] = cityCtrl.text.trim();
                                  a['state'] = stateCtrl.text.trim();
                                  a['zipCode'] = zipCtrl.text.trim();
                                  a['isDefault'] = isDefault;
                                  break;
                                }
                              }
                            }
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Address saved')),
                          );
                        },
                        child: Text(initial == null ? 'Add Address' : 'Save Changes'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userData: _userData,
          onSave: (updatedData) {
            setState(() {
              _userData.addAll(updatedData);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          },
        ),
      ),
    );
  }

  void _handleEditPersonalInfo() {
    // Implement personal info editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal info editing feature')),
    );
  }

  void _handleAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          onSave: (newAddress) {
            setState(() {
              // If this is set as default, update other addresses
              if (newAddress['isDefault'] == true) {
                for (var address in _userData['addresses']) {
                  address['isDefault'] = false;
                }
              }
              _userData['addresses'].add(newAddress);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address added successfully')),
            );
          },
        ),
      ),
    );
  }

  void _handleEditAddress(Map<String, dynamic> address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          initialAddress: address,
          onSave: (updatedAddress) {
            setState(() {
              // If this is set as default, update other addresses
              if (updatedAddress['isDefault'] == true) {
                for (var addr in _userData['addresses']) {
                  addr['isDefault'] = false;
                }
              }
              
              // Find and update the address
              final index = _userData['addresses'].indexWhere(
                (addr) => addr['id'] == updatedAddress['id'],
              );
              if (index != -1) {
                _userData['addresses'][index] = updatedAddress;
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address updated successfully')),
            );
          },
        ),
      ),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
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
