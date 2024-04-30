import 'package:flutter/material.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Category"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: OutlinedButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text("Create Category"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.add_circle_outline),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
