import 'package:flutter/material.dart';
import 'package:gestao_manicure/controllers/atendimento_controller.dart';
import 'package:gestao_manicure/models/atendimento_model.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String get _data => _dataHoje();
  final Color colorMelancia = Color.fromARGB(255, 252, 108, 133);
  final Color corRoxo = Color.fromARGB(255, 155, 123, 234);

  final AtendimentoController _controller = AtendimentoController();
  late final Stream<List<AtendimentoModel>> _atendimentosStream;

  @override
  void initState() {
    super.initState();
    _atendimentosStream = _controller.carregarAtendimentos();
  }

  String _dataHoje() {
    final data = DateTime.now();
    const meses = [
      'JAN',
      'FEV',
      'MAR',
      'ABR',
      'MAI',
      'JUN',
      'JUL',
      'AGO',
      'SET',
      'OUT',
      'NOV',
      'DEZ',
    ];

    return 'HOJE, ${data.day} ${meses[data.month - 1]}';
  }

  String _formatarHora(DateTime data) {
    final hora = data.hour.toString();
    final minuto = data.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }

  String _formatarValor(double valor) =>
      'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atendimentos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _data,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorMelancia,
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize: const Size(50, 50),
                    backgroundColor: colorMelancia,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<AtendimentoModel>>(
                stream: _atendimentosStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar atendimentos:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: colorMelancia),
                    );
                  }

                  final atendimentos = snapshot.data ?? [];
                  final qtdAgendados = atendimentos
                      .where((a) => a.status == 'agendado')
                      .length;
                  final qtdConcluidos = atendimentos
                      .where((a) => a.status == 'concluido')
                      .length;

                  return Column(
                    children: [
                      _resumoDoDia(
                        total: atendimentos.length,
                        agendados: qtdAgendados,
                        concluidos: qtdConcluidos,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: atendimentos.isEmpty
                            ? Center(
                                child: Text(
                                  'Nenhum atendimento para hoje.',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: atendimentos.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) =>
                                    _cardAtendimento(atendimentos[index]),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumoDoDia({
    required int total,
    required int agendados,
    required int concluidos,
  }) {
    Widget item(int valor, String rotulo) => Column(
      children: [
        Text(
          valor.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(rotulo, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );

    Widget divisor() => SizedBox(
      height: 30,
      width: 1,
      child: Container(color: Colors.grey.shade300),
    );

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(color: corRoxo.withValues(alpha: 0.15), blurRadius: 12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          item(total, 'Total do dia'),
          divisor(),
          item(agendados, 'Agendados'),
          divisor(),
          item(concluidos, 'Concluídos'),
        ],
      ),
    );
  }

  Widget _cardAtendimento(AtendimentoModel atendimento) {
    final (corStatus, fundoStatus, textoStatus) = switch (atendimento.status) {
      'concluido' => (Colors.green.shade700, Colors.green.shade50, 'Concluído'),
      'cancelado' => (Colors.grey.shade700, Colors.grey.shade200, 'Cancelado'),
      _ => (Colors.orange.shade800, Colors.orange.shade50, 'Agendado'),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horário + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 16, color: colorMelancia),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatarHora(atendimento.data),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: colorMelancia,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: fundoStatus,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      textoStatus,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: corStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Nome da cliente
          Text(
            atendimento.nomeCliente,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 2),

          // Tempo estimado
          Text(
            'Tempo estimado: ${atendimento.duracaoEstimada} min',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),

          // Procedimentos
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: atendimento.procedimentos
                .map(
                  (p) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorMelancia.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      p.descricao,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorMelancia,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),

          // Endereço
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: colorMelancia,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    atendimento.enderecoCliente,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),

          // Valor total + confirmar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VALOR TOTAL',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      _formatarValor(
                        atendimento.valorRecebido ??
                            atendimento.valorTotalPrevisto,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              if (atendimento.status == 'agendado')
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: corRoxo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Concluído'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
