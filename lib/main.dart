import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botão',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MinhaPaginaInicial(),
    );
  }
}

class MinhaPaginaInicial extends StatefulWidget {
  const MinhaPaginaInicial({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MinhaPaginaInicialState createState() => _MinhaPaginaInicialState();
}

class _MinhaPaginaInicialState extends State<MinhaPaginaInicial> {
  bool fundoBranco = true;

  void alterarCorDeFundo() {
    setState(() {
      fundoBranco = !fundoBranco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botão'),
      ),
      body: Container(
        color: fundoBranco ? Colors.white : Colors.black,
        child: Center(
          child: MeuBotaoPersonalizado(
            icone: Icons.add,
            texto:'On/Off',
            aoClicar: alterarCorDeFundo,
          ),  
        ),
      ),
    );
  }
}

class MeuBotaoPersonalizado extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback aoClicar;

  const MeuBotaoPersonalizado({super.key, required this.icone, required this.texto, required this.aoClicar});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aoClicar,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8.0),
          Text(texto),
        ],
      ),
    );
  }
}
