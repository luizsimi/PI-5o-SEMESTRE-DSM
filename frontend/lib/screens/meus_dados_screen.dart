import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/custom_text_field.dart';
import '../components/budget_modal.dart';
import '../components/stat_card.dart';
import 'home_screen.dart';
import 'search_screen.dart';

class MeusDadosScreen extends StatefulWidget {
  const MeusDadosScreen({super.key});

  @override
  State<MeusDadosScreen> createState() => _MeusDadosScreenState();
}

class _MeusDadosScreenState extends State<MeusDadosScreen> {
  int _selectedBottomIndex = 3; // Perfil selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(
        title: 'MEUS DADOS',
        showBackButton: false,
        showLogo: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards de Estatísticas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Primeira linha
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(value: '12', label: 'Pendentes'),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: StatCard(value: '10', label: 'Em Andamento'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Segunda linha
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(value: '9', label: 'Finalizados'),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: StatCard(value: 'R\$1000', label: 'Total do Mês'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Seção Ações Rápidas
            const Text(
              'Ações Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Botão Editar dados Pessoais
            GestureDetector(
              onTap: () {
                _showDadosPessoaisModal(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Editar dados Pessoais',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Clique para editar seus dados pessoais',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          
          // Navegação para Home quando clicar no ícone home
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
          
          // Navegação para a tela de pesquisa quando clicar no ícone de lupa
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
          
          // Navegação para o modal de orçamento quando clicar no botão +
          if (index == 2) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return const BudgetModal();
              },
            );
          }
          
          // Navegação direta - Meus Dados (index 3) já está na tela atual
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showDadosPessoaisModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
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
                      'DADOS PESSOAIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                               
                               // Campo Nome
                               const CustomTextField(label: 'Nome'),
                               const SizedBox(height: 20),
                               
                               // Campo Senha
                               const CustomTextField(
                                 label: 'Senha',
                                 obscureText: true,
                               ),
                               const SizedBox(height: 20),
                               
                               // Campo Nova senha
                               const CustomTextField(
                                 label: 'Nova senha',
                                 obscureText: true,
                               ),
                               const SizedBox(height: 20),
                               
                               // Campo Email
                               const CustomTextField(
                                 label: 'email',
                                 keyboardType: TextInputType.emailAddress,
                               ),
                               const SizedBox(height: 20),
                               
                               // Campo Telefone
                               const CustomTextField(
                                 label: 'Telefone',
                                 keyboardType: TextInputType.phone,
                               ),
                               const SizedBox(height: 40),
                             ],
                           ),
                         ),
                       ),
                       
                       // Botão Salvar
                       SizedBox(
                         width: double.infinity,
                         child: ElevatedButton(
                           onPressed: () {
                             Navigator.pop(context);
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: const Color(0xFF000000),
                             padding: const EdgeInsets.symmetric(vertical: 16),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(25),
                             ),
                           ),
                           child: const Text(
                             'Salvar',
                             style: TextStyle(
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
      },
    );
   }
 }