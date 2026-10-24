import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/utils/formatters.dart';
import 'package:mobx_cine/core/widgets/primary_button.dart';
import 'package:mobx_cine/core/widgets/responsive_body.dart';
import 'package:mobx_cine/features/tickets/domain/entities/ticket.dart';
import 'package:flutter/material.dart';

/// O que a página precisa saber para se desenhar.
class ResultArgs {
  const ResultArgs.success(Ticket this.ticket)
      : success = true,
        message = null;

  const ResultArgs.failure(String this.message)
      : success = false,
        ticket = null;

  final bool success;
  final Ticket? ticket;
  final String? message;
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.args});

  final ResultArgs args;

  void _goHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = args.success ? Colors.green : theme.colorScheme.error;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 480,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        // Animação de "pulinho" no ícone
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.elasticOut,
                          builder: (_, value, child) => Transform.scale(scale: value, child: child),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              args.success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              size: 88,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          args.success ? 'Compra confirmada!' : 'Não foi possível comprar',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          args.success
                              ? 'Seu ingresso está garantido. Bom filme! 🍿'
                              : args.message ?? 'Tente novamente em instantes.',
                          textAlign: TextAlign.center,
                        ),
                        if (args.success) ...[
                          const SizedBox(height: 24),
                          _TicketSummary(ticket: args.ticket!),
                        ],
                      ],
                    ),
                  ),
                ),
                if (args.success)
                  PrimaryButton(label: 'Voltar para os filmes', onPressed: () => _goHome(context))
                else ...[
                  PrimaryButton(
                    label: 'Tentar novamente',
                    onPressed: () => Navigator.pop(context), // volta para os assentos
                  ),
                  TextButton(
                    onPressed: () => _goHome(context),
                    child: const Text('Voltar para o início'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketSummary extends StatelessWidget {
  const _TicketSummary({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget line(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            line('Filme', ticket.movieTitle),
            line('Horário', ticket.time),
            line('Assentos', ticket.seats.join(', ')),
            const Divider(height: 24),
            line('Total', Formatters.currency(ticket.total)),
          ],
        ),
      ),
    );
  }
}
