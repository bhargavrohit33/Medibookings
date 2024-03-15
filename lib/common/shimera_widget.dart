import 'package:flutter/material.dart';
import 'package:medibookings/common/utils.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Card(
          elevation: 10,
            shape:cardShape,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 120,
                        height: 24,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 120,
                        height: 24,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder color
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(cardRadius),
                      bottomRight: Radius.circular(cardRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}