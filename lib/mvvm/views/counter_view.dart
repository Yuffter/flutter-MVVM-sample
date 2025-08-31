// 必要なライブラリをインポート
import 'package:flutter/material.dart'; // Flutter UIライブラリ
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod状態管理ライブラリ
import '../viewmodels/counter_viewmodel.dart'; // ViewModelをインポート

/// 【View】- MVVMパターンの「View」部分
///
/// Viewの役割：
/// 1. 画面の見た目（UI）を作る
/// 2. ユーザーの操作（ボタンタップなど）を受け取る
/// 3. ViewModelから状態を受け取って画面に表示する
///
/// ConsumerWidgetとは：
/// - Riverpodの状態を使えるWidget
/// - 状態が変わると自動的に画面が更新される
/// - 普通のStatelessWidgetの進化版
class CounterView extends ConsumerWidget {
  const CounterView({super.key});

  /// buildメソッド：画面の構造を作る
  ///
  /// 引数：
  /// - BuildContext context = 画面の情報
  /// - WidgetRef ref = Riverpodの状態にアクセスするためのオブジェクト
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // 画面の基本構造
      appBar: AppBar(
        // 上部のバー
        title: const Text('Riverpod MVVM Counter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2, // 影の深さ
      ),
      body: const Center(
        // メインコンテンツ
        child: SingleChildScrollView(
          // スクロール可能にする
          padding: EdgeInsets.all(16.0), // 周りの余白
          child: Column(
            // 縦に並べる
            mainAxisAlignment: MainAxisAlignment.center, // 中央寄せ
            children: <Widget>[
              _CounterDisplay(), // カウンター表示部分
              SizedBox(height: 24), // 間隔
              _MessageDisplay(), // メッセージ表示部分
              SizedBox(height: 32), // 間隔
              _LoadingIndicator(), // 読み込み表示部分
              SizedBox(height: 24), // 間隔
              _ActionButtons(), // ボタン群
            ],
          ),
        ),
      ),
      floatingActionButton: const _FloatingActionButton(), // 右下の丸いボタン
    );
  }
}

/// 【カウンター表示ウィジェット】数値を表示する部分
///
/// 役割：
/// - カウンターの現在の数値を大きく表示
/// - 読み込み中はローディングアニメーションを表示
/// - 数値によって色を変える
class _CounterDisplay extends ConsumerWidget {
  const _CounterDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プロバイダーから状態を取得
    final count = ref.watch(counterValueProvider); // カウンター数値を監視
    final isLoading = ref.watch(counterLoadingProvider); // 読み込み状態を監視

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'カウンター',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : Text(
                      '$count',
                      key: ValueKey(count),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getCountColor(count),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCountColor(int count) {
    if (count == 0) return Colors.grey;
    if (count < 10) return Colors.blue;
    if (count < 50) return Colors.green;
    if (count < 100) return Colors.orange;
    return Colors.red;
  }
}

/// メッセージを表示するウィジェット
class _MessageDisplay extends ConsumerWidget {
  const _MessageDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(counterMessageProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(message),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// ローディングインジケーター
class _LoadingIndicator extends ConsumerWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(counterLoadingProvider);

    return AnimatedOpacity(
      opacity: isLoading ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text('処理中...', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

/// アクションボタン群
class _ActionButtons extends ConsumerWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(counterActionsProvider);
    final isLoading = ref.watch(counterLoadingProvider);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: isLoading ? null : () => viewModel.increment(),
          icon: const Icon(Icons.add),
          label: const Text('増加'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: isLoading ? null : () => viewModel.incrementBatch(),
          icon: const Icon(Icons.add_circle),
          label: const Text('+10'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: isLoading ? null : () => viewModel.reset(),
          icon: const Icon(Icons.refresh),
          label: const Text('リセット'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: isLoading
              ? null
              : () => _showSetValueDialog(context, viewModel),
          icon: const Icon(Icons.edit),
          label: const Text('設定'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  /// 値を設定するダイアログを表示
  void _showSetValueDialog(BuildContext context, CounterViewModel viewModel) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('値を設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '新しい値',
                border: OutlineInputBorder(),
                hintText: '0以上の整数を入力',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ヒント: 42や100を試してみてください！',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(textController.text);
              if (value != null) {
                viewModel.setCount(value);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('有効な数値を入力してください')));
              }
            },
            child: const Text('設定'),
          ),
        ],
      ),
    );
  }
}

/// フローティングアクションボタン
class _FloatingActionButton extends ConsumerWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(counterActionsProvider);
    final isLoading = ref.watch(counterLoadingProvider);

    return FloatingActionButton(
      onPressed: isLoading ? null : () => viewModel.increment(),
      tooltip: 'カウンターを増やす',
      backgroundColor: isLoading ? Colors.grey : null,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.add),
    );
  }
}
