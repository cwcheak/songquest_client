import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('My Account'),
            backgroundColor: Colors.white,
            pinned: true,
            elevation: 0,
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Adjust the radius as needed
              ),
              child: Column(
                children: [
                  _buildUserInfoHeader(context),
                  // const Divider(height: 1),
                  // _buildSummarySection(context),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, top: 24, bottom: 8),
              child: Text(
                'Explore',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Adjust the radius as needed
              ),
              child: Column(
                children: [
                  _buildListItem(
                    context,
                    Icons.card_membership,
                    'Song Request History',
                    'View your song request history',
                    null,
                  ),
                  _buildListItem(
                    context,
                    Icons.calendar_today,
                    'My Playlist',
                    'Manage your preferred playlist',
                    () => context.push('/my-playlist'),
                  ),
                  _buildListItem(
                    context,
                    Icons.people,
                    'My Band',
                    'Manage your bands',
                    null,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, top: 24, bottom: 8),
              child: Text(
                'Others',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Adjust the radius as needed
              ),
              child: Column(
                children: [
                  _buildListItem(context, Icons.help_outline, 'FAQ', '', null),
                  _buildListItem(context, Icons.phone, 'Contact Us', '', null),
                  _buildListItem(context, Icons.feedback, 'Feedback', '', null),
                  _buildListItem(
                    context,
                    Icons.star_outline,
                    'Rate Us',
                    '',
                    null,
                  ),
                  _buildListItem(
                    context,
                    Icons.privacy_tip_outlined,
                    'Privacy Policy',
                    '',
                    null,
                  ),
                  _buildListItem(
                    context,
                    Icons.description_outlined,
                    'Terms and Conditions',
                    '',
                    null,
                  ),
                  _buildListItem(context, Icons.logout, 'Logout', '', null),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  12,
                ), // Adjust the radius as needed
              ),
              child: _buildDeleteAccountSection(context),
            ),
          ),
          SliverToBoxAdapter(child: _buildFooter(context)),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            // Placeholder for user avatar
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chan Julius',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '0164570087',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          QrImageView(data: '0164570087', version: QrVersions.auto, size: 60.0),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            context,
            Icons.account_balance_wallet,
            'RM 0.00',
            'Credit',
          ),
          _buildSummaryItem(context, Icons.star, '456', 'Points'),
          _buildSummaryItem(context, Icons.card_giftcard, '2', 'Vouchers'),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountSection(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
      subtitle: const Text('Permanently delete your account'),
      trailing: const Icon(Icons.chevron_right, color: Colors.red),
      onTap: () {
        // TODO: Handle delete account
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          Image.asset(
            'assets/logo.png', // Placeholder for the logo
            height: 50,
          ),
          const SizedBox(height: 8),
          const Text('V1.1.12', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

Widget _buildSummaryItem(
  BuildContext context,
  IconData icon,
  String value,
  String label,
) {
  return Column(
    children: [
      Icon(icon, color: Colors.red, size: 28),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}
