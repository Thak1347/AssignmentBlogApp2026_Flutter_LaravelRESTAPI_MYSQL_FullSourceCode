import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (_, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              Container(height: 200, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 14,
                      width: 200,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(radius: 16),
                        const SizedBox(width: 8),
                        Container(
                          height: 14,
                          width: 100,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
