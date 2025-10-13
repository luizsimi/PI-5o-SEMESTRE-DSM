import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/budget_modal.dart';
import 'home_screen.dart';
import 'meus_dados_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedBottomIndex = 1; // Índice 1 para o ícone de pesquisa
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVehicles = [];
  
  // Dados mock do histórico de veículos finalizados
  final List<Map<String, dynamic>> _vehicleHistory = [
    {
      'id': 'VH001',
      'plate': 'ABC-1234',
      'model': 'Honda Civic',
      'year': '2020',
      'owner': 'João Silva',
      'service': 'Troca de óleo',
      'completedDate': '15/12/2024',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'totalValue': 'R\$ 150,00',
    },
    {
      'id': 'VH002',
      'plate': 'DEF-5678',
      'model': 'Toyota Corolla',
      'year': '2019',
      'owner': 'Maria Santos',
      'service': 'Revisão completa',
      'completedDate': '12/12/2024',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'totalValue': 'R\$ 450,00',
    },
    {
      'id': 'VH003',
      'plate': 'GHI-9012',
      'model': 'Volkswagen Gol',
      'year': '2018',
      'owner': 'Pedro Costa',
      'service': 'Troca de pastilhas de freio',
      'completedDate': '10/12/2024',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'totalValue': 'R\$ 280,00',
    },
    {
      'id': 'VH004',
      'plate': 'JKL-3456',
      'model': 'Chevrolet Onix',
      'year': '2021',
      'owner': 'Ana Oliveira',
      'service': 'Alinhamento e balanceamento',
      'completedDate': '08/12/2024',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'totalValue': 'R\$ 120,00',
    },
    {
      'id': 'VH005',
      'plate': 'MNO-7890',
      'model': 'Ford Ka',
      'year': '2017',
      'owner': 'Carlos Ferreira',
      'service': 'Troca de bateria',
      'completedDate': '05/12/2024',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'totalValue': 'R\$ 320,00',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredVehicles = _vehicleHistory;
  }

  void _filterVehicles(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVehicles = _vehicleHistory;
      } else {
        _filteredVehicles = _vehicleHistory.where((vehicle) {
          return vehicle['plate'].toLowerCase().contains(query.toLowerCase()) ||
                 vehicle['model'].toLowerCase().contains(query.toLowerCase()) ||
                 vehicle['owner'].toLowerCase().contains(query.toLowerCase()) ||
                 vehicle['service'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'PESQUISAR',
        showBackButton: true,
        showLogo: true,
      ),
      body: Column(
        children: [
          // Campo de pesquisa
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterVehicles,
              decoration: InputDecoration(
                hintText: 'Pesquisar por placa, modelo, proprietário...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterVehicles('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF374957)),
                ),
              ),
            ),
          ),
          
          // Título da seção
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              'Histórico de Veículos Finalizados (${_filteredVehicles.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374957),
              ),
            ),
          ),
          
          // Lista de veículos
          Expanded(
            child: _filteredVehicles.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum veículo encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Cabeçalho do card
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    vehicle['plate'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF374957),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: vehicle['statusColor'],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      vehicle['status'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Informações do veículo
                              Text(
                                '${vehicle['model']} - ${vehicle['year']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Proprietário: ${vehicle['owner']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Serviço realizado
                              Text(
                                'Serviço: ${vehicle['service']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Rodapé do card
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Finalizado em: ${vehicle['completedDate']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    vehicle['totalValue'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF374957),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
          
          // Navegação para Home quando clicar no ícone home
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
          
          // Navegação direta - Search (index 1) já está na tela atual
          
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
          
          // Navegação para Meus Dados quando clicar no ícone de perfil
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MeusDadosScreen()),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}