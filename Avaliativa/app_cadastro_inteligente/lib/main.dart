import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path; // Importando com alias para evitar conflito

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppCadastro(),
  ));
}

class AppCadastro extends StatefulWidget {
  const AppCadastro({super.key});

  @override
  _AppCadastroState createState() => _AppCadastroState();
}

class _AppCadastroState extends State<AppCadastro> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Map<String, dynamic>> _itens = [];
  
  // Controllers para edição
  final TextEditingController _editTituloController = TextEditingController();
  final TextEditingController _editDescricaoController = TextEditingController();
  int? _editId;

  Future<Database> criarBanco() async {
    final caminho = await getDatabasesPath();
    final caminhoCompleto = path.join(caminho, 'cadastro.db'); // Usando path.join com alias

    return openDatabase(
      caminhoCompleto,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dados('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT NOT NULL, '
          'descricao TEXT NOT NULL, '
          'data_criacao TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  // CREATE - Inserir item
  Future<void> inserirItem(String titulo, String descricao) async {
    if (titulo.isEmpty || descricao.isEmpty) return;
    
    final Database db = await criarBanco();
    
    // Obter data atual formatada
    String dataAtual = _getDataAtual();
    
    await db.insert(
      'dados',
      {
        'titulo': titulo,
        'descricao': descricao,
        'data_criacao': dataAtual,
      },
    );
    
    _tituloController.clear();
    _descricaoController.clear();
    await carregarItens();
    
    // Mostrar mensagem de sucesso
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item salvo com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // READ - Carregar itens (ordenados por título - BÔNUS)
  Future<void> carregarItens() async {
    final Database db = await criarBanco();
    final List<Map<String, dynamic>> lista = await db.query(
      'dados',
      orderBy: "titulo ASC", // Bônus: Ordenação por título
    );
    setState(() {
      _itens = lista;
    });
  }

  // UPDATE - Atualizar item
  Future<void> atualizarItem(int id, String titulo, String descricao) async {
    if (titulo.isEmpty || descricao.isEmpty) return;
    
    final Database db = await criarBanco();
    await db.update(
      'dados',
      {
        'titulo': titulo,
        'descricao': descricao,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    
    _fecharModalEdicao();
    await carregarItens();
    
    // Mostrar mensagem de sucesso
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item atualizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // DELETE - Deletar item
  Future<void> deletarItem(int id) async {
    final Database db = await criarBanco();
    await db.delete(
      'dados',
      where: 'id = ?',
      whereArgs: [id],
    );
    await carregarItens();
    
    // Mostrar mensagem de sucesso
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item excluído com sucesso!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Helper para formatar data
  String _getDataAtual() {
    DateTime now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // Abrir modal de edição
  void _abrirModalEdicao(Map<String, dynamic> item) {
    _editId = item['id'];
    _editTituloController.text = item['titulo'];
    _editDescricaoController.text = item['descricao'];
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _editDescricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _fecharModalEdicao,
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                atualizarItem(
                  _editId!,
                  _editTituloController.text,
                  _editDescricaoController.text,
                );
              },
              child: const Text('Atualizar'),
            ),
          ],
        );
      },
    );
  }

  void _fecharModalEdicao() {
    Navigator.pop(context);
    _editTituloController.clear();
    _editDescricaoController.clear();
    _editId = null;
  }

  // Confirmar exclusão
  void _confirmarExclusao(int id, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Tem certeza que deseja excluir "$titulo"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                deletarItem(id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );+
  }

  @override
  void initState() {
    super.initState();
    carregarItens();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _editTituloController.dispose();
    _editDescricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App de Cadastro'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Formulário de cadastro
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título do item',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Digite a descrição do item',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      inserirItem(_tituloController.text, _descricaoController.text);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Item'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Listagem de itens
          Expanded(
            child: _itens.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum item cadastrado', // Bônus: Mensagem quando não há itens
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione seu primeiro item acima',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _itens.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _itens[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            item['titulo'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                item['descricao'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '📅 ${item['data_criacao'] ?? 'Data não disponível'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _abrirModalEdicao(item),
                                tooltip: 'Editar',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmarExclusao(item['id'], item['titulo']),
                                tooltip: 'Excluir',
                              ),
                            ],
                          ),
                          onTap: () => _abrirModalEdicao(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}