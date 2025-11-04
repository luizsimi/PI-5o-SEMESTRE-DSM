import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_navigation.dart';
import '../../../services/presentation/widgets/service_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../services/presentation/screens/home_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../profile/presentation/screens/meus_dados_screen.dart';

class GanhosScreen extends StatefulWidget {
  const GanhosScreen({super.key});

  @override
  State<GanhosScreen> createState() => _GanhosScreenState();
}

class _GanhosScreenState extends State<GanhosScreen> {
  int _selectedBottomIndex = 2;
  String _selectedFilter = 'DIA';

  final List<Map<String, dynamic>> _finishedServices = [
    {
      'id': '233',
      'title': 'ARGO TRACKER',
      'client': 'Luiz Henrique Simionato',
      'phone': '(19) 99681-6200',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 1000.0,
      'date': DateTime.now(),
    },
    {
      'id': '133',
      'title': 'CIVIC SPORT',
      'client': 'Marina Alves',
      'phone': '(11) 99999-0000',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 450.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '122',
      'title': 'ONIX LTZ',
      'client': 'Pedro Souza',
      'phone': '(19) 98888-7777',
      'status': 'FINALIZADO',
      'statusColor': Colors.green,
      'value': 280.0,
      'date': DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    final now = DateTime.now();
    if (_selectedFilter == 'DIA') {
      return _finishedServices.where((s) =>
          s['date'].year == now.year && s['date'].month == now.month && s['date'].day == now.day).toList();
    }
    if (_selectedFilter == 'MÊS') {
      return _finishedServices.where((s) =>
          s['date'].year == now.year && s['date'].month == now.month).toList();
    }
    // ANO
    return _finishedServices.where((s) => s['date'].year == now.year).toList();
  }

  double _sumTotal(List<Map<String, dynamic>> list) {
    return list.fold<double>(0.0, (acc, e) => acc + (e['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final totalDia = _sumTotal(_finishedServices.where((s) {
      final d = s['date'] as DateTime; final now = DateTime.now();
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList());
    final now = DateTime.now();
    final totalMes = _sumTotal(_finishedServices.where((s) {
      final d = s['date'] as DateTime; return d.year == now.year && d.month == now.month;
    }).toList());
    final totalAno = _sumTotal(_finishedServices.where((s) {
      final d = s['date'] as DateTime; return d.year == now.year;
    }).toList());

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'MEUS GANHOS',
        showBackButton: false,
      ),
      body: Column(
        children: [
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
              children: ['DIA', 'MÊS', 'ANO'].map((tab) {
                final isSelected = _selectedFilter == tab;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = tab),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Builder(
                builder: (_) {
                  String label;
                  double total;
                  if (_selectedFilter == 'DIA') {
                    label = 'Hoje';
                    total = totalDia;
                  } else if (_selectedFilter == 'MÊS') {
                    label = 'Neste mês';
                    total = totalMes;
                  } else {
                    label = 'Neste ano';
                    total = totalAno;
                  }
                  final int qtdServicos = _filteredServices.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'R\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$qtdServicos serviços',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredServices.length,
              itemBuilder: (context, index) {
                final s = _filteredServices[index];
                return ServiceCard(
                  id: s['id'],
                  title: s['title'],
                  subtitle: s['client'],
                  phone: s['phone'],
                  status: 'R\$${(s['value'] as double).toStringAsFixed(2)}',
                  statusColor: AppColors.success,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedBottomIndex,
        onTap: (index) {
          setState(() => _selectedBottomIndex = index);
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
          }
          // index 2 é a tela atual (Ganhos)
          if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MeusDadosScreen()));
          }
        },
      ),
    );
  }
}


