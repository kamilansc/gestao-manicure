import 'package:flutter/material.dart';

import 'agenda_page.dart';
import 'custos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSelecionado,
        children: const [AgendaPage(), CustosPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelecionado,
        selectedItemColor: const Color.fromARGB(255, 252, 108, 133),
        onTap: (indice) {
          setState(() {
            _indiceSelecionado = indice;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Dia'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell_outlined),
            label: 'Custos',
          ),
        ],
      ),
    );
  }
}
