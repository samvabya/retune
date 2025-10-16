import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:retune/providers/settings_provider.dart';
import 'package:retune/util.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sendData = true;
  String version = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = 'v${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(settingsProvider);
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Vibrancy',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => state.setVibrancy(false),
                            child: Container(
                              width: 90,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE25A5A),
                                borderRadius: BorderRadius.circular(10),
                                border: state.vibrancy
                                    ? null
                                    : Border.all(color: text, width: 2),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: surface,
                                    radius: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Divider(
                                      color: surface,
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => state.setVibrancy(true),
                            child: Container(
                              width: 90,
                              height: 160,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 8, 8),
                                borderRadius: BorderRadius.circular(10),
                                border: !state.vibrancy
                                    ? null
                                    : Border.all(color: text, width: 2),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: surface,
                                    radius: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Divider(
                                      color: surface,
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Apply vibrant colors to player, colors will be adjusted from music thumbnail.',
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SwitchListTile(
                  value: state.autoPlay,
                  onChanged: (value) async => await state.setAutoPlay(value),
                  title: Badge(
                    label: Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: surface,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    offset: Offset(-115, 0),
                    child: Text('Auto Play'),
                  ),
                  subtitle: Text(
                    'Play similar songs automatically',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  secondary: Icon(Icons.auto_fix_high),
                ),
                ListTile(
                  leading: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: CircleAvatar(),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://avatars.githubusercontent.com/u/127547778',
                        ),
                      ),
                    ],
                  ),
                  title: Text('Creators of retune'),
                  trailing: IconButton(
                    onPressed: () => showSnack(
                      'We are not accepting sponsors at the moment! Thank you for your interest😃',
                      context,
                    ),
                    tooltip: 'Sponsor this app',
                    icon: Icon(Icons.money),
                  ),
                ),
                ListTile(
                  title: Text('Github Repo'),
                  subtitle: Text(
                    'https://github.com/samvabya/retune',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: 'https://github.com/samvabya/retune',
                            ),
                          );
                        },
                        icon: Icon(Icons.copy),
                      ),
                      IconButton.filledTonal(
                        onPressed: () async {
                          if (!await launchUrl(
                            Uri.parse('https://github.com/samvabya/retune'),
                          )) {
                            showSnack('Cannot open link', context);
                          }
                        },
                        icon: Icon(Icons.open_in_new),
                      ),
                    ],
                  ),
                ),
                Card.filled(
                  color: Theme.of(context).colorScheme.secondaryFixedDim,
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'This app is open source. In case you want to contribute or report an issue, you can find the repo here.',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SwitchListTile(
                  value: sendData,
                  onChanged: (_) => setState(() => sendData = !sendData),
                  title: Text('Send Diagnostics'),
                ),
                ListTile(
                  title: Text('Check for Updates'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () async {
                    await http
                        .get(
                          Uri.parse(
                            'https://api.github.com/repos/samvabya/retune/releases/latest',
                          ),
                          headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                          },
                        )
                        .then((value) {
                          if (value.statusCode == 200) {
                            final data = json.decode(value.body);
                            final latestVersion = data['tag_name'];
                            if (latestVersion != version) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('A new version is available'),
                                  duration: Duration(seconds: 5),
                                  action: SnackBarAction(
                                    label: 'Update',
                                    backgroundColor: surface,
                                    onPressed: () async {
                                      await launchUrl(
                                        Uri.parse(
                                          'https://github.com/samvabya/retune/releases/latest',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              showSnack(
                                'You are on the latest version',
                                context,
                              );
                            }
                          }
                          debugPrint(value.body);
                        });
                  },
                ),
                ListTile(
                  title: Text('Report an Issue'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(
                        'https://github.com/samvabya/retune/issues/new',
                      ),
                    );
                  },
                ),
                Text(version, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }
}
