import 'package:cloud_firestore/cloud_firestore.dart';

class DespesaModel {
  final String? id;
  final String descricao;
  final double valor;
  final DateTime data;

  DespesaModel({
    this.id,
    required this.descricao,
    required this.valor,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valor': valor,
      'data': Timestamp.fromDate(data),
    };
  }

  factory DespesaModel.fromFirestore(DocumentSnapshot doc) {
    final dataMap = doc.data() as Map<String, dynamic>;
    return DespesaModel(
      id: doc.id,
      descricao: dataMap['descricao'] ?? '',
      valor: (dataMap['valor'] ?? 0).toDouble(),
      data: (dataMap['data'] as Timestamp).toDate(),
    );
  }
}
