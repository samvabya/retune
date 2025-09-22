import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const SearchSection({
    Key? key,
    required this.title,
    required this.children,
    this.showViewAll = false,
    this.onViewAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              if (showViewAll && onViewAllTap != null)
                TextButton(
                  onPressed: onViewAllTap,
                  child: const Text('View All'),
                ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
