import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../components/confirmation_modal.dart';

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
  final TextEditingController _partNameController = TextEditingController();
  final TextEditingController _partValueController = TextEditingController();
  final TextEditingController _serviceValueController = TextEditingController();
  final TextEditingController _totalValueController = TextEditingController();

  String _selectedServiceType = 'DADOS';

  @override
  void dispose() {
    _clientNameController.dispose();
    _phoneController.dispose();
    _vehicleModelController.dispose();
    _plateController.dispose();
    _serviceDescriptionController.dispose();
    _partNameController.dispose();
    _partValueController.dispose();
    _serviceValueController.dispose();
    _totalValueController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    double partValue = double.tryParse(_partValueController.text.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
    double serviceValue = double.tryParse(_serviceValueController.text.replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
    double total = partValue + serviceValue;
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
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Descrição do Serviço',
                              controller: _serviceDescriptionController,
                              maxLines: 3,
                            ),
                          ] else if (_selectedServiceType == 'PEÇAS') ...[
                            // Campos de peças
                            CustomTextField(
                              label: 'Nome da Peça',
                              controller: _partNameController,
                            ),
                            const SizedBox(height: 20),
                            
                            CustomTextField(
                              label: 'Valor da Peça',
                              controller: _partValueController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => _calculateTotal(),
                            ),
                          ] else if (_selectedServiceType == 'SERVIÇOS') ...[
                            // Campos de serviços
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
                          // Salvar orçamento e fechar modal
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Orçamento salvo com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}