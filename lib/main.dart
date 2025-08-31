// 必要なライブラリをインポート
import 'package:flutter/material.dart'; // Flutter UIライブラリ
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod状態管理ライブラリ
import 'mvvm/views/counter_view.dart'; // メイン画面をインポート

/// 【エントリーポイント】アプリが最初に実行される場所
///
/// main関数の役割：
/// 1. アプリの設定を行う
/// 2. 最初の画面を起動する
/// 3. Riverpodを使えるようにする設定
void main() {
  runApp(
    // ProviderScopeでアプリ全体をラップする
    // これにより、アプリ全体でRiverpodの状態管理が使えるようになる
    const ProviderScope(
      child: MyApp(), // メインアプリウィジェット
    ),
  );
}

/// 【メインアプリウィジェット】アプリの基本設定を行う
///
/// StatelessWidgetとは：
/// - 状態を持たないウィジェット
/// - 一度作られたら変更されない
/// - アプリの設定など、変更不要な部分に使う
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Googleのマテリアルデザインを使うアプリ
      title: 'Riverpod MVVM Demo', // アプリの名前
      theme: ThemeData(
        // アプリの見た目のテーマ
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 基本色
        useMaterial3: true, // 最新のマテリアルデザインを使用
      ),
      home: const CounterView(), // 最初に表示する画面
      debugShowCheckedModeBanner: false, // 右上の「DEBUG」バナーを非表示
    );
  }
}
