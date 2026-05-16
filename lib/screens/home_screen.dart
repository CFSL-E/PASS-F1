import 'package:flutter/material.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilterIndex = 0;

  final List<Map<String, String>> _passwords = [
    {'title': 'Google', 'account': 'zzyzs666@gmail.com', 'letter': 'G'},
    {'title': 'Apple ID', 'account': 'zzyzs666@icloud.com', 'letter': 'A'},
    {'title': 'Github', 'account': 'zzyzs666', 'letter': 'G'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 搜索栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBar(
                hintText: '搜索密码',
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // 原生进场动画推入导航栈，打开二级设置页
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 筛选标签
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterChip('全部', 0, colorScheme),
                  const SizedBox(width: 12),
                  _buildFilterChip('最近添加', 1, colorScheme),
                  const SizedBox(width: 12),
                  _buildFilterChip('常用', 2, colorScheme),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 密码列表
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: _passwords.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _passwords[index];
                  return _buildPasswordCard(item, colorScheme, textTheme);
                },
              ),
            ),
          ],
        ),
      ),
      // M3 标准悬浮按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 1, // 扁平化倾向，去掉厚重阴影
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, ColorScheme colorScheme) {
    final isSelected = _selectedFilterIndex == index;
    return RawChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: Colors.transparent,
      selectedColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.transparent : colorScheme.outlineVariant,
        ),
      ),
    );
  }

  Widget _buildPasswordCard(Map<String, String> item, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Text(
            item['letter']!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        title: Text(
          item['title']!,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          item['account']!,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onTap: () {
          // 点击查看详情等操作
        },
      ),
    );
  }
}
