import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_text_field.dart';
import '../theme/colors.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _serviceDescriptionController = TextEditingController();
  final TextEditingController _serviceValueController = TextEditingController();
  final TextEditingController _totalValueController = TextEditingController();

  String _selectedServiceType = 'DADOS';
  
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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: 'ORÇAMENTO',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
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
                      ),
                      child: const Text(
                        'DADOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
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
                      ),
                      child: const Text(
                        'PEÇAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
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
                      ),
                      child: const Text(
                        'SERVIÇOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          if (_selectedServiceType == 'DADOS') ...[
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
                            ..._partsList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Map<String, TextEditingController> part = entry.value;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
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
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: ElevatedButton.icon(
                                onPressed: _addPart,
                                icon: const Icon(Icons.add, color: AppColors.white),
                                label: const Text(
                                  'Adicionar Item',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ] else if (_selectedServiceType == 'SERVIÇOS') ...[
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedServiceType == 'DADOS') {
                          setState(() {
                            _selectedServiceType = 'PEÇAS';
                          });
                        } else if (_selectedServiceType == 'PEÇAS') {
                          setState(() {
                            _selectedServiceType = 'SERVIÇOS';
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Orçamento salvo com sucesso!')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        _selectedServiceType == 'SERVIÇOS' ? 'Salvar' : 'Próximo',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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

