import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('My Account'),
            pinned: true,
            elevation: 3,
            centerTitle: true,
          ),
          SliverToBoxAdapter(child: _buildCard(context, [_buildUserInfoHeader(context)].toList())),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, top: 24, bottom: 8),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              context,
              [
                _buildListItem(context, Icons.card_membership, 'Song Request History', '', null),
                _buildListItem(
                  context,
                  Icons.calendar_today,
                  'My Playlist',
                  '',
                  () => context.push('/my-playlist'),
                ),
                // _buildListItem(context, Icons.people, 'My Bands', '', () => context.push('/my-bands')),
              ].toList(),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, top: 24, bottom: 8),
              child: Text(
                'Others',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCard(
              context,
              [
                _buildListItem(context, Icons.help_outline, 'FAQ', '', null),
                _buildListItem(context, Icons.phone, 'Contact Us', '', null),
                _buildListItem(context, Icons.feedback, 'Feedback', '', null),
                _buildListItem(context, Icons.star_outline, 'Rate Us', '', null),
                _buildListItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', '', null),
                _buildListItem(
                  context,
                  Icons.description_outlined,
                  'Terms and Conditions',
                  '',
                  null,
                ),
                _buildListItem(context, Icons.logout, 'Logout', '', null),
              ].toList(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
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
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  // Placeholder for user avatar
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Chan Julius', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '0164570087',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                QrImageView(data: '0164570087', version: QrVersions.auto, size: 60.0),
              ],
            ),
          ),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Row(
              spacing: 8,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '185',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Songs Performed',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '\$200',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Tipping',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '185 cm',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Height',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(context, Icons.account_balance_wallet, 'RM 0.00', 'Credit'),
          _buildSummaryItem(context, Icons.star, '456', 'Points'),
          _buildSummaryItem(context, Icons.card_giftcard, '2', 'Vouchers'),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
      ),
      child: Column(children: items.toList()),
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
      dense: true,
      leading: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.2),
      ),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor, size: 22),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountSection(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
      title: Text('Delete Account', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      subtitle: Text(
        'Permanently delete your account',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.error),
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
          Text('V1.1.12', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ],
      ),
    );
  }
}

Widget _buildSummaryItem(BuildContext context, IconData icon, String value, String label) {
  return Column(
    children: [
      Icon(icon, color: Theme.of(context).primaryColor, size: 28),
      const SizedBox(height: 4),
      Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    ],
  );
}
