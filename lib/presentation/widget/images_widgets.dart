import 'package:flutter/material.dart';

class NoImageWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const NoImageWidget({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }
}



class ImageWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageWithPlaceholder({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the URL is valid
    if (Uri.tryParse(imageUrl)?.isAbsolute ?? false) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const NoImageWidget();
        },
      );
    } else {
      // If URL is not valid, display a placeholder
      return  NoImageWidget(height: height,width: width,);
    }
  }
}
