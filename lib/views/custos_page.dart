import 'package:flutter/material.dart';

import '../models/despesa_model.dart';

class CustosPage extends StatelessWidget {
  const CustosPage({super.key});

  static const _corRosa = Color(0xFFFC6C85);
  static const _corRoxo = Color(0xFF9B7BEA);

  static final List<DespesaModel> _despesas = [
    DespesaModel(
      descricao: 'Luvas de Nitrilo Rosa (Caixa 100 un)',
      valor: 45.00,
      data: DateTime(2026, 11, 14),
    ),
    DespesaModel(
      descricao: 'Coleção Esmaltes Risqué (4 un)',
      valor: 36.00,
      data: DateTime(2026, 11, 11),
    ),
    DespesaModel(
      descricao: 'Kit de Lixas descartáveis e palitos',
      valor: 28.00,
      data: DateTime(2026, 11, 8),
    ),
    DespesaModel(
      descricao: 'Alicate Mundial 722 Inox',
      valor: 42.00,
      data: DateTime(2026, 11, 5),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final total = _despesas.fold<double>(
      0,
      (soma, despesa) => soma + despesa.valor,
    );

    final totalFormatado = total.toStringAsFixed(2).replaceAll('.', ',');
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MÊS ATUAL',
                      style: TextStyle(
                        color: _corRosa,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gastos & Materiais',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Adicionar despesa',
                style: IconButton.styleFrom(
                  backgroundColor: _corRosa,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cadastro ainda não implementado.'),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8265D5), _corRoxo],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total de Gastos (Novembro)',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'R\$ $totalFormatado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.payments_outlined, color: Colors.white, size: 32),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Histórico de Despesas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${_despesas.length} itens',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._despesas.map((despesa) => _CardCusto(despesa: despesa)),
        ],
      ),
    );
  }
}

class _CardCusto extends StatelessWidget {
  final DespesaModel despesa;

  const _CardCusto({required this.despesa});

  @override
  Widget build(BuildContext context) {
    final dia = despesa.data.day.toString().padLeft(2, '0');
    final mes = despesa.data.month.toString().padLeft(2, '0');
    final dataFormatada = '$dia/$mes/${despesa.data.year}';

    final valorFormatado = despesa.valor
        .toStringAsFixed(2)
        .replaceAll('.', ',');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  despesa.descricao,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dataFormatada,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '- R\$ $valorFormatado',
            style: const TextStyle(
              color: Color(0xFFFC6C85),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
