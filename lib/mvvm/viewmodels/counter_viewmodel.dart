// Riverpodライブラリをインポート（状態管理のため）
import 'package:flutter_riverpod/flutter_riverpod.dart';
// カウンターのデータモデルをインポート
import '../models/counter_model.dart';

/// 【ViewModel】- MVVMパターンの「ViewModel」部分
///
/// ViewModelの役割：
/// 1. 画面（View）の状態を管理する
/// 2. ユーザーの操作（ボタンを押すなど）を受け取ってデータを更新する
/// 3. 画面に表示するためのデータを準備する
///
/// StateNotifier<CounterModel>を継承することで：
/// - CounterModel型の状態を管理できる
/// - 状態が変更されると、その状態を使っている画面が自動的に更新される
class CounterViewModel extends StateNotifier<CounterModel> {
  /// コンストラクタ（ViewModelを作るときに最初に呼ばれる）
  /// super(CounterModel.initial()) = 最初の状態を設定
  CounterViewModel() : super(CounterModel.initial());

  /// 【メソッド】カウンターを1つ増やす機能
  ///
  /// Future<void>の意味：
  /// - Future = 非同期処理（時間がかかる処理）
  /// - void = 戻り値なし
  /// - async = この関数は非同期処理を含む
  Future<void> increment() async {
    // 1. まず「読み込み中」の状態にする
    // state = 現在の状態
    // copyWith = 一部だけ変更した新しい状態を作る
    state = state.copyWith(isLoading: true);

    // 2. 少し待つ（実際のアプリでは、サーバーとの通信などで時間がかかる）
    // Duration(milliseconds: 300) = 300ミリ秒（0.3秒）待つ
    await Future.delayed(const Duration(milliseconds: 300));

    // 3. カウンターを1増やす
    final newCount = state.count + 1;

    // 4. 新しい状態を設定
    state = state.copyWith(
      count: newCount, // 新しいカウント値
      message: _getMessageForCount(newCount), // カウントに応じたメッセージ
      isLoading: false, // 読み込み完了
    );
  }

  /// 【メソッド】カウンターを0にリセットする機能
  Future<void> reset() async {
    // 1. 読み込み中の状態にする
    state = state.copyWith(isLoading: true);

    // 2. 少し待つ（リセット処理のシミュレーション）
    await Future.delayed(const Duration(milliseconds: 200));

    // 3. 初期状態に戻す + カスタムメッセージ
    // CounterModel.initial() = 最初の状態（count: 0など）
    state = CounterModel.initial().copyWith(message: 'カウンターがリセットされました');
  }

  /// 【メソッド】カウンターを好きな数字に設定する機能
  ///
  /// 引数：int value = 設定したい数字
  Future<void> setCount(int value) async {
    // 1. エラーチェック：負の数はダメ
    if (value < 0) {
      // エラーメッセージを表示して、処理を終了
      state = state.copyWith(message: 'エラー: 負の値は設定できません');
      return; // この時点で関数を終了
    }

    // 2. 読み込み中の状態にする
    state = state.copyWith(isLoading: true);

    // 3. 少し待つ
    await Future.delayed(const Duration(milliseconds: 250));

    // 4. 指定された値に設定
    state = state.copyWith(
      count: value, // 指定された数値
      message: _getCustomMessage(value), // 数値に応じた特別なメッセージ
      isLoading: false, // 読み込み完了
    );
  }

  /// 【メソッド】カウンターを一度に10増やす機能（まとめて処理の例）
  Future<void> incrementBatch() async {
    // 1. 読み込み中の状態にする
    state = state.copyWith(isLoading: true);

    // 2. 少し長めに待つ（大きな処理のシミュレーション）
    await Future.delayed(const Duration(milliseconds: 500));

    // 3. 現在の値に10を足す
    final newCount = state.count + 10;

    // 4. 新しい状態を設定
    state = state.copyWith(
      count: newCount,
      message: '一度に10増やしました！現在: $newCount',
      isLoading: false,
    );
  }

  /// 【プライベートメソッド】カウント数に応じたメッセージを作る
  ///
  /// プライベート（_で始まる）= このクラスの中でだけ使える関数
  /// 外部からは呼び出せない
  String _getMessageForCount(int count) {
    // if文で条件分岐：カウント数によって違うメッセージを返す
    if (count == 0) return 'カウントはゼロです';
    if (count < 5) return 'カウント: $count - まだまだですね！';
    if (count < 10) return 'カウント: $count - いい調子です！';
    if (count < 20) return 'カウント: $count - すごいですね！';
    if (count == 50) return '🎉 50回達成！おめでとうございます！';
    if (count == 100) return '🏆 100回達成！素晴らしい！';
    // どの条件にも当てはまらない場合の基本メッセージ
    return 'カウント: $count - 頑張ってますね！';
  }

  /// 【プライベートメソッド】カスタム値設定時の特別なメッセージを作る
  String _getCustomMessage(int value) {
    // 特定の数字に対して特別なメッセージを用意
    if (value == 0) return 'カウンターを0に設定しました';
    if (value == 42) return '42 - 生命、宇宙、そして全ての答え！'; // 有名な数字
    if (value == 100) return '100 - 完璧な数字ですね！';
    if (value > 1000) return '$value - とても大きな数字ですね！';
    // 普通の数字の場合の基本メッセージ
    return 'カウンターを$value に設定しました';
  }
}

// ========================================
// 【プロバイダー】- Riverpodで状態を管理するための設定
// ========================================

/// 【メインプロバイダー】ViewModelを提供する
///
/// StateNotifierProviderの役割：
/// - CounterViewModelのインスタンスを作成・管理
/// - 状態（CounterModel）の変更を監視
/// - 画面で状態を使えるようにする
final counterViewModelProvider =
    StateNotifierProvider<CounterViewModel, CounterModel>((ref) {
      // 新しいCounterViewModelを作成して返す
      return CounterViewModel();
    });

// ========================================
// 【最適化プロバイダー】- パフォーマンス向上のため
// ========================================
// 以下のプロバイダーは、全体の状態から特定の部分だけを取り出す
// これにより、必要な部分だけが更新されて、アプリが速くなる

/// カウンターの数値だけを提供するプロバイダー
/// 例：数値が変わったときだけ、数値を表示している部分が更新される
final counterValueProvider = Provider<int>((ref) {
  // ref.watch = 状態の変更を監視
  return ref.watch(counterViewModelProvider).count;
});

/// メッセージだけを提供するプロバイダー
/// 例：メッセージが変わったときだけ、メッセージ表示部分が更新される
final counterMessageProvider = Provider<String>((ref) {
  return ref.watch(counterViewModelProvider).message;
});

/// 読み込み状態だけを提供するプロバイダー
/// 例：読み込み中かどうかが変わったときだけ、ローディング表示が更新される
final counterLoadingProvider = Provider<bool>((ref) {
  return ref.watch(counterViewModelProvider).isLoading;
});

/// ViewModelの操作（メソッド）にアクセスするためのプロバイダー
///
/// ref.read = 一度だけ値を取得（状態の変更は監視しない）
/// .notifier = StateNotifierの本体（CounterViewModel）を取得
///
/// 使い方の例：
/// final actions = ref.read(counterActionsProvider);
/// actions.increment(); // カウンターを増やす
final counterActionsProvider = Provider<CounterViewModel>((ref) {
  return ref.read(counterViewModelProvider.notifier);
});
