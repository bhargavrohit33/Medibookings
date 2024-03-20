import 'package:flutter/material.dart';

class NoImageWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const NoImageWidget({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
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
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

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
          return NoImageWidget();
        },
      );
    } else {
      // If URL is not valid, display a placeholder
      return NoImageWidget();
    }
  }
}
