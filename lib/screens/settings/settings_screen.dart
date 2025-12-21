import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:songquest/repo/settings_repo.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsRepository settingsRepo;

  const SettingsScreen({super.key, required this.settingsRepo});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 20,
          onRefresh: () async {
            // context.read<AccountBloc>().add(AccountLoadEvent());
          },
          child: SettingsList(
            sections: [
              SettingsSection(
                title: Text('Account Info'),
                tiles: [
                  SettingsTile.navigation(title: Text('Account Info')),
                  // SettingsTile(
                  //   title: Text(
                  //     state.user!.user.displayName(),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  //   trailing: Row(children: [
                  //     Text(
                  //       AppLocale.accountSettings.getString(context),
                  //       style: TextStyle(
                  //         color: customColors.weakTextColor?.withAlpha(200),
                  //         fontSize: 13,
                  //       ),
                  //     ),
                  //     const Icon(
                  //       CupertinoIcons.chevron_forward,
                  //       size: 18,
                  //       color: Colors.grey,
                  //     ),
                  //   ]),
                  //   onPressed: (context) {
                  //     context.push('/setting/account-security');
                  //   },
                  // ),
                ],
              ),
              SettingsSection(
                title: Text('User Interface'),
                tiles: [
                  SettingsTile.navigation(
                    title: Text('Theme'),
                    // onPressed: (context) {
                    //   Navigation.navigateTo(
                    //     context: context,
                    //     screen: CrossPlatformSettingsScreen(),
                    //     style: NavigationRouteStyle.material,
                    //   );
                    // },
                  ),
                  SettingsTile.navigation(
                    title: Text('Language'),
                    // onPressed: (context) {
                    //   Navigation.navigateTo(
                    //     context: context,
                    //     screen: CrossPlatformSettingsScreen(),
                    //     style: NavigationRouteStyle.material,
                    //   );
                    // },
                  ),
                ],
              ),
              SettingsSection(
                title: Text('System'),
                tiles: [
                  SettingsTile.navigation(
                    title: Text('Terms & Condition'),
                    // onPressed: (context) {
                    //   Navigation.navigateTo(
                    //     context: context,
                    //     screen: CrossPlatformSettingsScreen(),
                    //     style: NavigationRouteStyle.material,
                    //   );
                    // },
                  ),
                  SettingsTile.navigation(
                    title: Text('Privacy Policy'),
                    // onPressed: (context) {
                    //   Navigation.navigateTo(
                    //     context: context,
                    //     screen: CrossPlatformSettingsScreen(),
                    //     style: NavigationRouteStyle.material,
                    //   );
                    // },
                  ),
                  SettingsTile.navigation(
                    title: Text('About'),
                    // onPressed: (context) {
                    //   Navigation.navigateTo(
                    //     context: context,
                    //     screen: CrossPlatformSettingsScreen(),
                    //     style: NavigationRouteStyle.material,
                    //   );
                    // },
                  ),
                ],
              ),
              CustomSettingsSection(
                child: Column(
                  children: [
                    Text(
                      DateTime.now().year == 2025
                          ? 'Copyright © 2025'
                          : 'Copyright © 2025-${DateTime.now().year}',
                      style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
                    ),
                    Text(
                      'Terminus Digital Sdn. Bhd.',
                      style: TextStyle(color: Theme.of(context).hintColor, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // List<SettingsTile> _buildAccountSettingsTiles(
  //     AccountState state, CustomColors customColors) {}
}
