import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'confirmation_modal.dart';
import 'success_modal.dart';

class BudgetModal extends StatefulWidget {
  const BudgetModal({super.key});

  @override
  State<BudgetModal> createState() => _BudgetModalState();
}

class _BudgetModalState extends State<BudgetModal> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  final TextEditingController _serviceValueController = TextEditingController();
  final TextEditingController _totalValueController = TextEditingController();

  String _selectedServiceType = 'DADOS';
  
  // Lista de peças dinâmica
  List<Map<String, TextEditingController>> _partsList = [];

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneController.dispose();
    _vehicleModelController.dispose();
    _plateController.dispose();
    _serviceDescriptionController.dispose();
    _serviceValueController.dispose();
    _totalValueController.dispose();
    
    // Dispose dos controllers das peças
    for (var part in _partsList) {
      part['name']?.dispose();
      part['value']?.dispose();
    }
    
    super.dispose();
  }

  void _addPart() {
    setState(() {
      _partsList.add({
        'name': TextEditingController(),
        'value': TextEditingController(),
      });
    });
  }

  void _removePart(int index) {
    setState(() {
      _partsList[index]['name']?.dispose();
      _partsList[index]['value']?.dispose();
      _partsList.removeAt(index);
    });
    _calculateTotal();
  }

  void _calculateTotal() {
    double totalPartsValue = 0.0;
    
    // Somar valores de todas as peças
    for (var part in _partsList) {
      String valueText = part['value']?.text ?? '';
      double partValue = double.tryParse(valueText.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
      totalPartsValue += partValue;
    }
    
    double serviceValue = double.tryParse(_serviceValueController.text.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
    double total = totalPartsValue + serviceValue;
    _totalValueController.text = 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header do Modal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ORÇAMENTO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final shouldClose = await ConfirmationModal.show(
                      context,
                      title: 'Cancelar',
                      confirmText: 'Cancelar',
                      cancelText: 'Continuar',
                    );
                    
                    if (shouldClose == true) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs de navegação
          Container(
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'DADOS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'DADOS' ? Colors.grey[700] : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'DADOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'PEÇAS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'PEÇAS' ? Colors.grey[700] : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'PEÇAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServiceType = 'SERVIÇOS';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedServiceType == 'SERVIÇOS' ? Colors.grey[700] : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SERVIÇOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Conteúdo do Modal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Campos do formulário
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          
                          // Conteúdo baseado na aba selecionada
                          if (_selectedServiceType == 'DADOS') ...[
                            // Campos de dados do cliente e veículo
                            CustomTextField(
                              label: 'Nome do Cliente',
                              controller: _clientNameController,
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Telefone',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Modelo do Veículo',
                              controller: _vehicleModelController,
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Placa',
                              controller: _plateController,
                            ),
                          ] else if (_selectedServiceType == 'PEÇAS') ...[
                            // Lista dinâmica de cards de peças
                            ..._partsList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, TextEditingController> part = entry.value;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Peça ${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (_partsList.length > 1)
                                          IconButton(
                                            onPressed: () => _removePart(index),
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    CustomTextField(
                                      label: 'Nome da Peça',
                                      controller: part['name']!,
                                    ),
                                    const SizedBox(height: 12),
                                    CustomTextField(
                                      label: 'Valor da Peça',
                                      controller: part['value']!,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      onChanged: (value) => _calculateTotal(),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            
                            // Botão Adicionar Item
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton.icon(
                                onPressed: _addPart,
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  'Adicionar Item',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ] else if (_selectedServiceType == 'SERVIÇOS') ...[
                            // Campos de serviços
                            CustomTextField(
                              label: 'Digite qual tipo de serviço',
                              controller: _serviceDescriptionController,
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Valor do Serviço',
                              controller: _serviceValueController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => _calculateTotal(),
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Valor Total',
                              controller: _totalValueController,
                              enabled: false,
                            ),
                          ],
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  
                  // Botão Próximo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_selectedServiceType == 'DADOS') {
                            setState(() {
                              _selectedServiceType = 'PEÇAS';
                            });
                          } else if (_selectedServiceType == 'PEÇAS') {
                            setState(() {
                              _selectedServiceType = 'SERVIÇOS';
                            });
                          } else {
                            // Salvar orçamento e mostrar modal de sucesso
                            await SuccessModal.show(
                              context,
                              title: 'Orçamento Realizado',
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000000),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _selectedServiceType == 'SERVIÇOS' ? 'Salvar' : 'Próximo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
