import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/utils/formatters.dart';
import 'package:mobx_cine/core/widgets/poster_widget.dart';
import 'package:mobx_cine/core/widgets/primary_button.dart';
import 'package:mobx_cine/core/widgets/responsive_body.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/domain/entities/cinema_room.dart';
import 'package:flutter/material.dart';

/// Tela sem estado mutável: não precisa de store. 
class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: ResponsiveBody(
        maxWidth: 900,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // RESPONSIVO: lado a lado se houver espaço, empilhado se não
              final isWide = constraints.maxWidth > 600;

              final poster = SizedBox(
                width: isWide ? 260 : 220,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Hero(
                    tag: 'poster_${movie.id}',
                    child: PosterImage(url: movie.posterUrl),
                  ),
                ),
              );

              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1)),
                      const SizedBox(width: 16),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text(Formatters.date(movie.releaseDate)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Sinopse', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isEmpty ? 'Sem sinopse disponível.' : movie.overview,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ingresso: ${Formatters.currency(CinemaRoom.ticketPrice)}',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              );

              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [poster, const SizedBox(width: 24), Expanded(child: info)],
                    )
                  : Column(children: [poster, const SizedBox(height: 20), info]);
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Escolher assentos',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.seats, arguments: movie),
          ),
        ),
      ),
    );
  }
}
