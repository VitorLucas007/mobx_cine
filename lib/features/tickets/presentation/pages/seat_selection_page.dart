import 'package:mobx_cine/core/di/injection.dart';
import 'package:mobx_cine/core/routes/app_routes.dart';
import 'package:mobx_cine/core/utils/formatters.dart';
import 'package:mobx_cine/core/utils/view_state.dart';
import 'package:mobx_cine/core/widgets/error_view.dart';
import 'package:mobx_cine/core/widgets/primary_button.dart';
import 'package:mobx_cine/core/widgets/responsive_body.dart';
import 'package:mobx_cine/features/movies/domain/entities/movie.dart';
import 'package:mobx_cine/features/tickets/domain/entities/cinema_room.dart';
import 'package:mobx_cine/features/tickets/presentation/pages/result_page.dart';
import 'package:mobx_cine/features/tickets/presentation/stores/seat_selection_store.dart';
import 'package:mobx_cine/features/tickets/presentation/widgets/seat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({super.key, required this.movie});

  final Movie movie;

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  // Store nova para cada filme (registrada como factory com parâmetro)
  late final SeatSelectionStore _store = getIt<SeatSelectionStore>(param1: widget.movie);
  late final ReactionDisposer _warningDisposer;

  @override
  void initState() {
    super.initState();
    _store.loadOccupiedSeats();

    // REACTION: quando surgir um aviso, mostra um SnackBar e limpa o aviso.
    _warningDisposer = reaction<String?>((_) => _store.warning, (message) {
      if (message == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      _store.clearWarning();
    });
  }

  @override
  void dispose() {
    _warningDisposer(); // ⚠️ sempre cancele reactions
    super.dispose();
  }

  Future<void> _onBuy() async {
    final success = await _store.purchase();
    if (!mounted) return;

    if (success) {
      // Sucesso: limpa a pilha até a home (não dá para "voltar" para a compra)
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.result,
        (route) => route.settings.name == AppRoutes.home,
        arguments: ResultArgs.success(_store.purchasedTicket!),
      );
    } else {
      // Erro: empilha por cima, para o usuário poder voltar e tentar de novo
      Navigator.pushNamed(
        context,
        AppRoutes.result,
        arguments: ResultArgs.failure(
          _store.purchaseError ?? 'Não foi possível concluir a compra.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title, overflow: TextOverflow.ellipsis)),
      body: ResponsiveBody(
        maxWidth: 560,
        child: Column(
          children: [
            _buildTimeSelector(),
            _buildScreenIndicator(),
            Expanded(child: Observer(builder: (_) => _buildSeatsArea())),
            _buildLegend(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ───────── Horários ─────────
  Widget _buildTimeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Observer(
        builder: (_) => Wrap(
          spacing: 8,
          children: [
            for (final time in CinemaRoom.showtimes)
              ChoiceChip(
                label: Text(time),
                selected: _store.selectedTime == time,
                onSelected: _store.isPurchasing ? null : (_) => _store.selectTime(time),
              ),
          ],
        ),
      ),
    );
  }

  // ───────── "Tela" do cinema ─────────
  Widget _buildScreenIndicator() {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 8),
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 16, spreadRadius: 1),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text('TELA', style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }

  // ───────── Área das cadeiras ─────────
  Widget _buildSeatsArea() {
    switch (_store.seatsState) {
      case ViewState.initial:
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewState.error:
        return ErrorView(
          message: _store.seatsError ?? 'Erro desconhecido',
          onRetry: _store.loadOccupiedSeats,
        );

      case ViewState.success:
        return LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(child: _buildGrid(constraints.maxWidth)),
          ),
        );
    }
  }

  Widget _buildGrid(double maxWidth) {
    const spacing = 6.0;
    const labelWidth = 24.0;

    // RESPONSIVO: calcula o tamanho da cadeira conforme a largura da tela
    final available = maxWidth - 32 - labelWidth - spacing * (CinemaRoom.seatsPerRow + 2);
    final seatSize = (available / CinemaRoom.seatsPerRow).clamp(22.0, 40.0).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in CinemaRoom.rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: spacing / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: labelWidth,
                  child: Text(row, style: Theme.of(context).textTheme.labelMedium),
                ),
                for (var number = 1; number <= CinemaRoom.seatsPerRow; number++) ...[
                  // Corredor no meio da sala
                  if (number == CinemaRoom.seatsPerRow ~/ 2 + 1) const SizedBox(width: spacing * 2),
                  Padding(
                    padding: const EdgeInsets.only(left: spacing),
                    // Um Observer POR CADEIRA: só a cadeira tocada redesenha
                    child: Observer(
                      builder: (_) {
                        final seatId = '$row$number';
                        return SeatTile(
                          seatId: seatId,
                          number: number,
                          size: seatSize,
                          status: _store.statusOf(seatId),
                          onTap: () => _store.toggleSeat(seatId),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  // ───────── Legenda ─────────
  Widget _buildLegend() {
    final scheme = Theme.of(context).colorScheme;

    Widget item(Color color, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 16,
        children: [
          item(scheme.surfaceContainerHighest, 'Livre'),
          item(scheme.primary, 'Selecionado'),
          item(scheme.outlineVariant, 'Ocupado'),
        ],
      ),
    );
  }

  // ───────── Barra inferior (resumo + comprar) ─────────
  Widget _buildBottomBar() {
    final theme = Theme.of(context);

    return Material(
      elevation: 8,
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Observer(
            builder: (_) => Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _store.selectedSeats.isEmpty
                            ? 'Nenhum assento'
                            : _store.sortedSeats.join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.currency(_store.total),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 170,
                  child: PrimaryButton(
                    label: 'Comprar',
                    isLoading: _store.isPurchasing,
                    onPressed: _store.canBuy ? _onBuy : null,
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
