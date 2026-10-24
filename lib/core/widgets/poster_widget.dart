import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({super.key, required this.url, this.radius = 16});

  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Mostrado enquanto carrega, se der erro ou se não houver imagem
    Widget placeholder() => Container(
          color: scheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(Icons.movie_outlined, size: 40, color: scheme.onSurfaceVariant),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url == null
          ? placeholder()
          : CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (_, _) => placeholder(),
              errorWidget: (_, _, _) => placeholder(),
            ),
    );
  }
}
