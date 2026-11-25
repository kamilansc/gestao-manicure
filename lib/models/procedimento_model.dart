import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedimentoModel {
  final String? id;
  final String descricao;
  final double preco;
  final bool status;

  ProcedimentoModel({
    this.id,
    required this.descricao,
    required this.preco,
    this.status = true,
  });

  Map<String, dynamic> toMap() {
    return {'descricao': descricao, 'preco': preco, 'status': status};
  }

  factory ProcedimentoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProcedimentoModel(
      id: doc.id,
      descricao: data['descricao'] ?? '',
      preco: (data['preco'] ?? 0).toDouble(),
      status: data['status'] ?? true,
    );
  }
}
