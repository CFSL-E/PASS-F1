import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 返回一个全新的 Scaffold，这确保了它是真正的二级页面并占据整个系统导航视图
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // automaticallyImplyLeading 为 true，会自动推断并带上原生的返回按钮
        automaticallyImplyLeading: true,
        title: const Text('设置'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(Icons.palette_outlined, color: colorScheme.primary),
            title: const Text('主题设置'),
            subtitle: const Text('跟随系统动态色彩提取'),
            onTap: () {
              // 在这里可以继续调用 Navigator.push() 进入三级页面
            },
          ),
          ListTile(
            leading: Icon(Icons.security_outlined, color: colorScheme.primary),
            title: const Text('安全设置'),
            subtitle: const Text('本地生物识别、安全锁'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.folder_outlined, color: colorScheme.primary),
            title: const Text('数据备份'),
            subtitle: const Text('本地加密导出'),
            onTap: () {},
          ),
          Divider(color: colorScheme.surfaceContainerHigh, height: 32),
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.primary),
            title: const Text('关于'),
            subtitle: const Text('版本 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
