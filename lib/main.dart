import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );

    //print("Aberto: " + bd.isOpen.toString());

    return bd;

  }

  _salvar() async{

    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Kharen Paes de Albuquerque",
      "idade" : 27
    };
    int id = await db.insert("usuarios", dadosUsuario);
    print("salvo: $id");

  }

  @override
  Widget build(BuildContext context) {

    _salvar();

    return Container();
  }
}

