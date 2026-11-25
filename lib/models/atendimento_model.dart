import 'package:cloud_firestore/cloud_firestore.dart';

class ItemProcedimentoAtendimento {
  final String idProcedimento;
  final String descricao;
  final double valorAplicado;
  final bool realizado;

  ItemProcedimentoAtendimento({
    required this.idProcedimento,
    required this.descricao,
    required this.valorAplicado,
    this.realizado = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_procedimento': idProcedimento,
      'descricao': descricao,
      'valor_aplicado': valorAplicado,
      'realizado': realizado,
    };
  }

  factory ItemProcedimentoAtendimento.fromMap(Map<String, dynamic> map) {
    return ItemProcedimentoAtendimento(
      idProcedimento: map['id_procedimento'] ?? '',
      descricao: map['descricao'] ?? '',
      valorAplicado: (map['valor_aplicado'] ?? 0).toDouble(),
      realizado: map['realizado'] ?? true,
    );
  }
}

class AtendimentoModel {
  final String? id;
  final String nomeCliente;
  final String enderecoCliente;
  final DateTime data;
  final int duracaoEstimada;
  final String status; // 'agendado', 'concluido', 'cancelado'
  final double? valorRecebido;
  final List<ItemProcedimentoAtendimento> procedimentos;

  AtendimentoModel({
    this.id,
    required this.nomeCliente,
    required this.enderecoCliente,
    required this.data,
    required this.duracaoEstimada,
    this.status = 'agendado',
    this.valorRecebido,
    required this.procedimentos,
  });

  // Soma automática dos procedimentos marcados como realizados
  double get valorTotalPrevisto => procedimentos
      .where((item) => item.realizado)
      .fold(0.0, (soma, item) => soma + item.valorAplicado);

  Map<String, dynamic> toMap() {
    return {
      'nome_cliente': nomeCliente,
      'endereco_cliente': enderecoCliente,
      'data': Timestamp.fromDate(data),
      'duracao_estimada': duracaoEstimada,
      'status': status,
      'valor_recebido': valorRecebido,
      'procedimentos': procedimentos.map((item) => item.toMap()).toList(),
    };
  }

  factory AtendimentoModel.fromFirestore(DocumentSnapshot doc) {
    final dataMap = doc.data() as Map<String, dynamic>;
    final listaRaw = dataMap['procedimentos'] as List<dynamic>? ?? [];

    return AtendimentoModel(
      id: doc.id,
      nomeCliente: dataMap['nome_cliente'] ?? '',
      enderecoCliente: dataMap['endereco_cliente'] ?? '',
      data: (dataMap['data'] as Timestamp).toDate(),
      duracaoEstimada: (dataMap['duracao_estimada'] ?? 0).toInt(),
      status: dataMap['status'] ?? 'agendado',
      valorRecebido: dataMap['valor_recebido'] != null
          ? (dataMap['valor_recebido'] as num).toDouble()
          : null,
      procedimentos: listaRaw
          .map(
            (item) => ItemProcedimentoAtendimento.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}
