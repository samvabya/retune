import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String type;
  final VoidCallback? onTap;

  const SearchResultCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(type == 'Song' ? 50 : 0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          // width: 56,
          // height: 56,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 56,
            height: 56,
            color: Colors.grey[300],
            child: const Icon(Icons.music_note),
          ),
          errorWidget: (context, url, error) => Container(
            width: 56,
            height: 56,
            color: Colors.grey[300],
            child: const Icon(Icons.music_note),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
          // const SizedBox(height: 2),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Text(
          //     type.toUpperCase(),
          //     style: TextStyle(
          //       fontSize: 10,
          //       fontWeight: FontWeight.bold,
          //       color: Theme.of(context).colorScheme.secondary,
          //     ),
          //   ),
          // ),
        ],
      ),
      onTap: onTap,
    );
  }
}
