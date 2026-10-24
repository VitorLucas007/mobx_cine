import 'package:mobx_cine/features/tickets/domain/entities/seat_status.dart';
import 'package:flutter/material.dart';

class SeatTile extends StatelessWidget {
  const SeatTile({
    super.key,
    required this.seatId,
    required this.number,
    required this.size,
    required this.status,
    required this.onTap,
  });

  final String seatId; // ex.: "B4" (usado na acessibilidade)
  final int number;
  final double size;
  final SeatStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (background, foreground) = switch (status) {
      SeatStatus.free => (scheme.surfaceContainerHighest, scheme.onSurface),
      SeatStatus.selected => (scheme.primary, scheme.onPrimary),
      SeatStatus.occupied => (scheme.outlineVariant, scheme.onSurface.withValues(alpha: 0.3)),
    };

    return Semantics(
      label: 'Assento $seatId',
      button: true,
      selected: status == SeatStatus.selected,
      enabled: status != SeatStatus.occupied,
      child: GestureDetector(
        onTap: status == SeatStatus.occupied ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            // Formato de "poltrona": topo bem arredondado
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(size * 0.4),
              bottom: const Radius.circular(6),
            ),
          ),
          child: size >= 28
              ? Text('$number', style: TextStyle(fontSize: 11, color: foreground))
              : null,
        ),
      ),
    );
  }
}
