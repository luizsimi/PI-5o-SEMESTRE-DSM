import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../theme/colors.dart';

class ItensAuditadosScreen extends StatefulWidget {
  final String vehicleTitle;
  final String clientName;
  final String quilometragem;
  
  const ItensAuditadosScreen({
    super.key,
    required this.vehicleTitle,
    required this.clientName,
    required this.quilometragem,
  });

  @override
  State<ItensAuditadosScreen> createState() => _ItensAuditadosScreenState();
}

class _ItensAuditadosScreenState extends State<ItensAuditadosScreen> {
  final TextEditingController _pecaController = TextEditingController();
  final List<String> _itensAuditados = [];

  @override
  void dispose() {
    _pecaController.dispose();
    super.dispose();
  }

  void _adicionarItem() {
    if (_pecaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite o nome da peça'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _itensAuditados.add(_pecaController.text.trim());
      _pecaController.clear();
    });
  }

  void _removerItem(int index) {
    setState(() {
      _itensAuditados.removeAt(index);
    });
  }

  void _proximo() {
    if (_itensAuditados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, adicione pelo menos um item'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Aqui você pode salvar os dados e ir para próxima tela
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Check-in finalizado com sucesso!'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Volta para tela inicial após 1 segundo
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'ITENS AUDITADOS',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _pecaController,
                decoration: const InputDecoration(
                  hintText: 'Escreva a peça',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
                onSubmitted: (_) => _adicionarItem(),
              ),
            ),

            const SizedBox(height: 20),

            // Lista de itens auditados
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _itensAuditados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum item adicionado',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _itensAuditados.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              _itensAuditados[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _removerItem(index),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // Botão Adicionar Item
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _adicionarItem,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Adicionar Item',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Botão Próximo
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proximo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Próximo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

