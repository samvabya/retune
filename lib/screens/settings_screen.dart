import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
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
    final Uri url = Uri.parse('https://github.com/samvabya/retune');

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    surface,
                    BlendMode.multiply,
                  ),
                  child: Image.asset('assets/icon_cap.png'),
                ),
                Positioned(
                  right: 15,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () => launchUrl(
                      Uri.parse('https://www.instagram.com/retune.music/'),
                    ),
                    icon: Image.network(
                      'https://icons.veryicon.com/png/o/miscellaneous/offerino-icons/instagram-53.png',
                      width: 25,
                      color: primary,
                    ),
                  ),
                ),
              ],
            ),
            Text(version, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 20),
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
            ),
            ListTile(
              title: Text('Github Repo'),
              subtitle: Text(
                url.toString(),
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
                      if (!await launchUrl(url)) {
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
              value: true,
              onChanged: (_) {
                showSnack('This setting is not available', context);
              },
              title: Text('Vibrant Mode'),
              subtitle: Text('apply vibrant colors to player'),
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
                          showSnack('New version available', context);
                        } else {
                          showSnack('You are on the latest version', context);
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
                  Uri.parse('https://github.com/samvabya/retune/issues/new'),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
