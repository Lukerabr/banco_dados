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
      "nome" : "Teste Nome Duplicação",
      "idade" : 35
    };
    int id = await db.insert("usuarios", dadosUsuario);
    print("salvo: $id");

  }

  _listarUsuarios() async{

    Database db = await _recuperarBancoDados();
    //String sql = "SELECT * FROM usuarios WHERE idade = 28";
    String sql = "SELECT * FROM usuarios";
    List usuarios = await db.rawQuery(sql);

    for(var usuario in usuarios){
      print(
        "item id: " + usuario["id"].toString() +
        " nome: " + usuario["nome"] +
        " idade " + usuario["idade"].toString()
      );
    }

    //print("Usuários: " + usuarios.toString());

  }

  _listarUsuarioPeloId(int id) async {

    Database db = await _recuperarBancoDados();

    List usuarios = await db.query(
      "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ?", //? é um caractere coringa
      whereArgs: [id]
    );

    for(var usuario in usuarios){
      print(
          "item id: " + usuario["id"].toString() +
              " nome: " + usuario["nome"] +
              " idade " + usuario["idade"].toString()
      );
    }

  }

  _excluirUsuario(int id) async {

    Database db = await _recuperarBancoDados();
    
    int retorno = await db.delete(
      "usuarios",
      where: "id = ?",
      whereArgs: [id]
    );

    //print("Item qtde removida: $retorno");

  }

  _atualizarUsuario(int id) async {

    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome" : "Qhuareen Paz Aubukerkeh ALTERADA",
      "idade" : 30
    };

    int retorno = await db.update(
      "usuarios",
      dadosUsuario,
      where: "id = ?",
      whereArgs: [id]
    );

    print("Item qtde atualizada: $retorno");

  }

  @override
  Widget build(BuildContext context) {

    //_salvar();
    //_listarUsuarios();
    //_excluirUsuario(9);
    //_listarUsuarioPeloId(2);
    //_atualizarUsuario(2);
    //_listarUsuarioPeloId(2);
    //_listarUsuarios();

    return Container();
  }
}

