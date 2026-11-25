import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_manicure/models/atendimento_model.dart';

class AtendimentoController {
  final CollectionReference _atendimentos = FirebaseFirestore.instance
      .collection('atendimentos');

  /// Busca os atendimentos do dia informado (padrão: hoje), ordenados por horário.
  /// Retorna um Stream para que a tela atualize em tempo real.
  Stream<List<AtendimentoModel>> carregarAtendimentos({DateTime? dia}) {
    final base = dia ?? DateTime.now();
    final inicio = DateTime(base.year, base.month, base.day);
    final fim = inicio.add(const Duration(days: 1));

    return _atendimentos
        .where('data', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
        .where('data', isLessThan: Timestamp.fromDate(fim))
        .orderBy('data')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AtendimentoModel.fromFirestore(doc))
              .toList(),
        );
  }
}
