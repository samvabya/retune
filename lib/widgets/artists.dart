import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retune/data/data.dart';
import 'package:retune/models/models.dart';
import 'package:retune/util.dart';

class Artists extends StatelessWidget {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.23),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...featuredArtists.map(
                    (artist) => _buildArtistCard(
                      artist,
                      featuredArtists.indexOf(artist) == 0,
                      context,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCard(
    ArtistInfo artist,
    bool isFirst,
    BuildContext context,
  ) => Container(
    width: isFirst ? 150 : 120,
    margin: EdgeInsets.only(right: 10, left: isFirst ? 20 : 0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: 150,
              width: 150,
              imageUrl: artist.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          artist.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
