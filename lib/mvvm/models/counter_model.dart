/// 【Model】- MVVMパターンの「Model」部分
///
/// Modelの役割：
/// 1. アプリで使うデータの形を決める（設計図のようなもの）
/// 2. データを保存する（カウント数、メッセージなど）
/// 3. ビジネスロジック（計算や処理）は含まない→ ViewModelが担当
///
/// このクラスは「イミュータブル」（変更不可能）：
/// - 一度作ったインスタンスの中身は変えられない
/// - 値を変更したいときは、新しいインスタンスを作る
/// - これにより、バグが起きにくくなる
class CounterModel {
  // final = 一度設定したら変更できない変数
  final int count; // カウンターの数値
  final String message; // 画面に表示するメッセージ
  final bool isLoading; // 読み込み中かどうか（true/false）

  /// コンストラクタ（インスタンスを作るときの設定）
  ///
  /// const = コンパイル時に値が決まる（メモリ効率が良い）
  /// required = 必須パラメータ（必ず値を指定する必要がある）
  /// this.isLoading = false = デフォルト値（省略した場合はfalse）
  const CounterModel({
    required this.count,
    required this.message,
    this.isLoading = false,
  });

  /// 【ファクトリーコンストラクタ】アプリ開始時の初期状態を作る
  ///
  /// factory = 特別なコンストラクタ（毎回新しいインスタンスを作るとは限らない）
  /// .initial() = 「初期状態」という意味の名前
  ///
  /// アプリが最初に起動したときの状態：
  /// - カウント: 0
  /// - メッセージ: 案内文
  /// - 読み込み中: false
  factory CounterModel.initial() {
    return const CounterModel(count: 0, message: 'ボタンを押してカウントを開始してください');
  }

  /// 【copyWithメソッド】一部の値だけを変更した新しいインスタンスを作る
  ///
  /// イミュータブルなクラスでは、値を「変更」する代わりに、
  /// 一部だけ変更した「新しいインスタンス」を作る
  ///
  /// 使い方の例：
  /// final newModel = oldModel.copyWith(count: 5);
  /// → countだけ5に変更、他の値は元のまま
  ///
  /// パラメータの?の意味：
  /// - int? count = countは省略可能（nullも許可）
  /// - 省略した項目は元の値をそのまま使う
  CounterModel copyWith({
    int? count, // 新しいカウント値（省略可能）
    String? message, // 新しいメッセージ（省略可能）
    bool? isLoading, // 新しい読み込み状態（省略可能）
  }) {
    return CounterModel(
      // ?? の意味：「左がnullなら右を使う」
      count: count ?? this.count, // 新しい値があればそれを、なければ現在の値を使う
      message: message ?? this.message, // 新しい値があればそれを、なければ現在の値を使う
      isLoading: isLoading ?? this.isLoading, // 新しい値があればそれを、なければ現在の値を使う
    );
  }

  // ========================================
  // 【自動生成メソッド】- Dartが自動で作ってくれる便利な機能
  // ========================================
  // 以下のメソッドは@overrideがついている = 親クラス（Object）のメソッドを上書き

  /// 【==演算子】二つのCounterModelが同じかどうかを判定する
  ///
  /// 使い方の例：
  /// if (model1 == model2) { ... } // 同じ内容なら真
  ///
  /// 判定基準：
  /// - count, message, isLoadingがすべて同じなら「同じ」
  /// - 一つでも違えば「違う」
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // 全く同じインスタンスか
      other is CounterModel && // 相手もCounterModelか
          runtimeType == other.runtimeType && // 型が同じか
          count == other.count && // カウントが同じか
          message == other.message && // メッセージが同じか
          isLoading == other.isLoading; // 読み込み状態が同じか

  /// 【hashCodeゲッター】オブジェクトの「指紋」のような値を作る
  ///
  /// この値は：
  /// - 同じ内容のオブジェクトは同じhashCodeを返す
  /// - HashMapやSetなどでオブジェクトを高速検索するのに使われる
  /// - ^演算子 = XOR（排他的論理和）で各値を組み合わせ
  @override
  int get hashCode => count.hashCode ^ message.hashCode ^ isLoading.hashCode;

  /// 【toStringメソッド】オブジェクトを文字列として表現する
  ///
  /// 使い方の例：
  /// print(model); // CounterModel(count: 5, message: hello, isLoading: false)
  ///
  /// デバッグ時にオブジェクトの中身を確認するのに便利
  @override
  String toString() =>
      'CounterModel(count: $count, message: $message, isLoading: $isLoading)';
}
