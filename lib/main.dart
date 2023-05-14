import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botão',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MinhaPaginaInicial(),
    );
  }
}

class MinhaPaginaInicial extends StatefulWidget {
  @override
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
        title: Text('Botão'),
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

  MeuBotaoPersonalizado({required this.icone, required this.texto, required this.aoClicar});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: aoClicar,
      style: ElevatedButton.styleFrom(
        primary: Colors.purple,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 8.0),
          Text(texto),
        ],
      ),
    );
  }
}
