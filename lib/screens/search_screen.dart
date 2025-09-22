import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Hero(
              tag: 'search',
              child: Material(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context).textTheme.titleSmall,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search songs, albums and artists',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    Card(child: SizedBox(height: 100)),
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
