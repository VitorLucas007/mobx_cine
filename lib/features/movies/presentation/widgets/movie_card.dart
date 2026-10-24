import 'package:mobx_cine/core/widgets/poster_widget.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Hero: o pôster "voa" até a tela de detalhes
            child: Hero(
              tag: 'poster_${movie.id}',
              child: PosterImage(url: movie.posterUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(movie.rating.toStringAsFixed(1), style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
