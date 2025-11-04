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
  String _selectedFilter = 'MÊS'; // Começa com MÊS (mais útil para mecânico)
  
  // Meta mensal do mecânico (pode ser configurável depois)
  final double _metaMensal = 5000.0;

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
          // Card Principal com Total e Métricas
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Card do Total
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Builder(
                    builder: (_) {
                      String label;
                      double total;
                      if (_selectedFilter == 'DIA') {
                        label = 'Ganhos de Hoje';
                        total = totalDia;
                      } else if (_selectedFilter == 'MÊS') {
                        label = 'Ganhos do Mês';
                        total = totalMes;
                      } else {
                        label = 'Ganhos do Ano';
                        total = totalAno;
                      }
                      final int qtdServicos = _filteredServices.length;
                      final double ticketMedio = qtdServicos > 0 ? total / qtdServicos : 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.attach_money, color: Colors.white, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'R\$ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoChip(
                                icon: Icons.build,
                                label: '$qtdServicos serviços',
                              ),
                              _buildInfoChip(
                                icon: Icons.trending_up,
                                label: 'Média R\$ ${ticketMedio.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                // Meta Mensal (apenas quando filtro é MÊS)
                if (_selectedFilter == 'MÊS') ...[
                  const SizedBox(height: 16),
                  _buildMetaCard(totalMes),
                ],
                
                // Cards de Estatísticas Rápidas
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.star,
                        title: 'Melhor Cliente',
                        value: _getMelhorCliente(),
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.calendar_today,
                        title: 'Melhor Dia',
                        value: _getMelhorDia(),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
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

  // Widget para chips de informação no card principal
  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget do card de meta mensal
  Widget _buildMetaCard(double totalMes) {
    final progresso = (totalMes / _metaMensal).clamp(0.0, 1.0);
    final porcentagem = (progresso * 100).toInt();
    final faltam = _metaMensal - totalMes;
    final atingiuMeta = totalMes >= _metaMensal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: atingiuMeta ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    atingiuMeta ? Icons.emoji_events : Icons.flag,
                    color: atingiuMeta ? Colors.amber : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Meta do Mês',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Text(
                'R\$ ${_metaMensal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                atingiuMeta ? Colors.green : Colors.blue,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                atingiuMeta
                    ? '🎉 Meta atingida!'
                    : 'Faltam R\$ ${faltam.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: atingiuMeta ? Colors.green : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$porcentagem%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: atingiuMeta ? Colors.green : Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget de card de estatística
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Retorna o nome do melhor cliente (quem mais gastou)
  String _getMelhorCliente() {
    if (_filteredServices.isEmpty) return 'Nenhum';
    
    // Agrupar por cliente e somar valores
    final Map<String, double> clienteValores = {};
    for (var service in _filteredServices) {
      final cliente = service['client'] as String;
      final valor = service['value'] as double;
      clienteValores[cliente] = (clienteValores[cliente] ?? 0) + valor;
    }
    
    // Encontrar o cliente com maior valor
    String melhorCliente = '';
    double maiorValor = 0;
    clienteValores.forEach((cliente, valor) {
      if (valor > maiorValor) {
        maiorValor = valor;
        melhorCliente = cliente;
      }
    });
    
    // Retornar apenas o primeiro nome
    return melhorCliente.split(' ').first;
  }

  // Retorna o melhor dia (dia com mais ganhos)
  String _getMelhorDia() {
    if (_filteredServices.isEmpty) return 'Nenhum';
    
    if (_selectedFilter == 'DIA') {
      return 'Hoje';
    } else if (_selectedFilter == 'MÊS') {
      // Agrupar por dia do mês e somar valores
      final Map<int, double> diaValores = {};
      for (var service in _filteredServices) {
        final date = service['date'] as DateTime;
        final dia = date.day;
        final valor = service['value'] as double;
        diaValores[dia] = (diaValores[dia] ?? 0) + valor;
      }
      
      // Encontrar o dia com maior valor
      int melhorDia = 0;
      double maiorValor = 0;
      diaValores.forEach((dia, valor) {
        if (valor > maiorValor) {
          maiorValor = valor;
          melhorDia = dia;
        }
      });
      
      return 'Dia $melhorDia';
    } else {
      // Para ANO, mostrar o mês
      final Map<int, double> mesValores = {};
      for (var service in _filteredServices) {
        final date = service['date'] as DateTime;
        final mes = date.month;
        final valor = service['value'] as double;
        mesValores[mes] = (mesValores[mes] ?? 0) + valor;
      }
      
      int melhorMes = 0;
      double maiorValor = 0;
      mesValores.forEach((mes, valor) {
        if (valor > maiorValor) {
          maiorValor = valor;
          melhorMes = mes;
        }
      });
      
      const meses = ['', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 
                     'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      return meses[melhorMes];
    }
  }
}


