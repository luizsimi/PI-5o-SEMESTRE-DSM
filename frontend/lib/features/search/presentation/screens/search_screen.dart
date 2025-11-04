import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';
import '../../../earnings/presentation/screens/ganhos_screen.dart';
import '../widgets/vehicle_search_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedBottomIndex = 1; // Índice 1 para o ícone de pesquisa
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVehicles = [];
  
  // Dados mock do histórico de veículos
  final List<Map<String, dynamic>> _vehicleHistory = [
    {
      'plate': 'ABC-1234',
      'model': 'Honda Civic 2020',
      'owner': 'João Silva',
      'totalValue': 'R\$ 150,00',
    },
    {
      'plate': 'DEF-5678',
      'model': 'Toyota Corolla 2019',
      'owner': 'Maria Santos',
      'totalValue': 'R\$ 450,00',
    },
    {
      'plate': 'GHI-9012',
      'model': 'VW Gol 2018',
      'owner': 'Pedro Costa',
      'totalValue': 'R\$ 280,00',
    },
    {
      'plate': 'JKL-3456',
      'model': 'Chevrolet Onix 2021',
      'owner': 'Ana Oliveira',
      'totalValue': 'R\$ 120,00',
    },
    {
      'plate': 'MNO-7890',
      'model': 'Ford Ka 2017',
      'owner': 'Carlos Ferreira',
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
                 vehicle['owner'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'PESQUISAR',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Header com campo de pesquisa integrado
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterVehicles,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar placa, modelo ou proprietário',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[700], size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[700], size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _filterVehicles('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          // Título da seção
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Histórico',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_filteredVehicles.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de veículos
          Expanded(
            child: _filteredVehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum veículo encontrado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return VehicleSearchCard(
                        plate: vehicle['plate'],
                        model: vehicle['model'],
                        owner: vehicle['owner'],
                        totalValue: vehicle['totalValue'],
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
          
          // Navegar para Meus Ganhos ao clicar no ícone de $ (index 2)
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const GanhosScreen()),
            );
          }
          
          // Navegar para Meus Dados ao clicar no ícone de perfil (index 3)
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