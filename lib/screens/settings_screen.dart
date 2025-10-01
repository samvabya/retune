import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retune/util.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse('https://github.com/samvabya/retune');

    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            ],
          ),
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
                      ClipboardData(text: 'https://github.com/samvabya/retune'),
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
        ],
      ),
    );
  }
}
