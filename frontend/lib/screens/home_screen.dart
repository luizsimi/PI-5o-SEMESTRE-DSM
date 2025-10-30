import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/service_card.dart';
import '../theme/colors.dart';
import 'meus_dados_screen.dart';
import 'ganhos_screen.dart';
import 'search_screen.dart';
import 'service_details_screen.dart';
import 'budget_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _selectedBottomIndex = 0;
  final List<String> _tabs = ['TODOS', 'PENDENTES', 'APROVADOS'];

  // Mock data for services
  final List<Map<String, dynamic>> _services = [
    {
      'id': '233',
      'title': 'ARGO TRACKER',
      'subtitle': 'Luiz Henrique Simionato',
      'phone': '(19) 99681-6200',
      'status': 'APROVADO',
      'statusColor': Colors.green,
      'partName': 'Cabo',
      'partValue': 'R\$1200',
      'serviceType': 'Não sei',
      'serviceValue': 'R\$1000',
    },
    {
      'id': '133',
      'title': 'ARGO TRACKER',
      'subtitle': 'Luiz Henrique Simionato',
      'phone': '(19) 99484-6200',
      'status': 'PENDENTE',
      'statusColor': Colors.orange,
      'partName': 'Filtro de Ar',
      'partValue': 'R\$80',
      'serviceType': 'Troca de Filtro',
      'serviceValue': 'R\$50',
    },
    {
      'id': '122',
      'title': 'ARGO TRACKER',
      'subtitle': 'Luiz Henrique Simionato',
      'phone': '(19) 99484-6200',
      'status': 'REPROVADO',
      'statusColor': Colors.red,
      'partName': 'Pastilha de Freio',
      'partValue': 'R\$200',
      'serviceType': 'Troca de Pastilha',
      'serviceValue': 'R\$150',
    },
  ];

  // Method to filter services based on selected tab
  List<Map<String, dynamic>> get _filteredServices {
    switch (_selectedTabIndex) {
      case 0: // TODOS
        return _services;
      case 1: // PENDENTES
        return _services.where((service) => 
          service['status'] == 'PENDENTE').toList();
      case 2: // APROVADOS
        return _services.where((service) => 
          service['status'] == 'APROVADO').toList();
      default:
        return _services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'SERVIÇOS',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Tab Bar with Horizontal Scroll - Minimalist Design
          Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = _selectedTabIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Services List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                final service = _filteredServices[index];
                return ServiceCard(
                  id: service['id'],
                  title: service['title'],
                  subtitle: service['subtitle'],
                  phone: service['phone'],
                  status: service['status'],
                  statusColor: service['statusColor'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailsScreen(
                          id: service['id'],
                          title: service['title'],
                          clientName: service['subtitle'],
                          phone: service['phone'],
                          status: service['status'],
                          statusColor: service['statusColor'],
                          partName: service['partName'],
                          partValue: service['partValue'],
                          serviceType: service['serviceType'],
                          serviceValue: service['serviceValue'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
          
          // Navegação direta - Home (index 0) já está na tela atual
          
          // Navegação para a tela de pesquisa quando clicar no ícone de lupa
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          }
          
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BudgetScreen()),
            );
          }
          
          // Navegar para Meus Ganhos ao clicar no ícone de $ (index 3)
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GanhosScreen()),
            );
          }
          
          // Navegar para Meus Dados ao clicar no ícone de perfil (index 4)
          if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeusDadosScreen()),
            );
          }
        },
      ),
    );
  }
}