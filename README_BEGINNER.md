# 🚀 初心者向け Flutter MVVM サンプルアプリ

このアプリは **MVVM（Model-View-ViewModel）パターン** と **Riverpod** を使ったカウンターアプリです。

## 📚 初心者向け解説

### 🏗️ MVVMパターンとは？

MVVMは、アプリを3つの部分に分けて整理する方法です：

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│    View     │◄──►│  ViewModel   │◄──►│    Model    │
│  (画面UI)   │    │(状態管理)    │    │  (データ)   │
└─────────────┘    └──────────────┘    └─────────────┘
```

#### 🎨 **View（ビュー）**
- **役割**: 画面の見た目を作る
- **ファイル**: `lib/mvvm/views/counter_view.dart`
- **具体例**: ボタン、文字、色など

#### 🧠 **ViewModel（ビューモデル）**
- **役割**: 画面の状態を管理する
- **ファイル**: `lib/mvvm/viewmodels/counter_viewmodel.dart`
- **具体例**: ボタンが押されたときの処理

#### 📦 **Model（モデル）**
- **役割**: データの形を決める
- **ファイル**: `lib/mvvm/models/counter_model.dart`
- **具体例**: カウント数、メッセージの保存

### 🔄 Riverpodとは？

**Riverpod**は、アプリの状態を管理するツールです。

```dart
// ViewModelで状態を変更
viewModel.increment();

↓ 自動的に

// Viewが更新される
Text('$count') // 新しい数値が表示される
```

## 📁 ファイル構造

```
lib/
├── main.dart                    # アプリの開始点
└── mvvm/
    ├── models/
    │   └── counter_model.dart   # データの形を定義
    ├── viewmodels/
    │   └── counter_viewmodel.dart # 状態管理とロジック
    └── views/
        └── counter_view.dart    # 画面のUI
```

## 🎯 主な機能

### 1. **カウンター増加**
```dart
// ボタンを押すと
viewModel.increment();

// カウントが1増える
count: 0 → 1
```

### 2. **まとめて増加**
```dart
// +10ボタンを押すと
viewModel.incrementBatch();

// カウントが10増える
count: 5 → 15
```

### 3. **リセット機能**
```dart
// リセットボタンを押すと
viewModel.reset();

// カウントが0に戻る
count: 25 → 0
```

### 4. **カスタム設定**
```dart
// 好きな数字を設定
viewModel.setCount(42);

// 特別なメッセージが表示される
"42 - 生命、宇宙、そして全ての答え！"
```

## 🔍 コードの読み方

### 1. **状態の監視**
```dart
// ViewModelの状態を監視
final count = ref.watch(counterValueProvider);

// 状態が変わると自動的に画面が更新される
Text('$count') // ← ここが自動で変わる
```

### 2. **状態の変更**
```dart
// ViewModelのメソッドを呼び出し
final viewModel = ref.read(counterActionsProvider);
viewModel.increment(); // ← 状態を変更

// → 監視している部分が自動更新される
```

### 3. **非同期処理**
```dart
Future<void> increment() async {
  // 1. ローディング開始
  state = state.copyWith(isLoading: true);
  
  // 2. 時間のかかる処理
  await Future.delayed(Duration(milliseconds: 300));
  
  // 3. 結果を反映
  state = state.copyWith(count: newCount, isLoading: false);
}
```

## 🚀 アプリの実行方法

1. **依存関係のインストール**
```bash
flutter pub get
```

2. **アプリの実行**
```bash
flutter run
```

3. **デバイスの選択**
- Windows、Chrome、Edgeから選択できます

## 💡 学習のポイント

### ✅ **覚えておきたいこと**

1. **MVVMの分離**
   - View: 見た目だけ
   - ViewModel: ロジックと状態
   - Model: データの形

2. **Riverpodの基本**
   - `ref.watch()`: 状態を監視（変更時に更新）
   - `ref.read()`: 状態を一回だけ取得

3. **状態の不変性**
   - 状態は直接変更しない
   - `copyWith()`で新しい状態を作成

### 🔧 **カスタマイズしてみよう**

1. **新しいボタンを追加**
   - 例: カウントを2倍にするボタン

2. **メッセージの変更**
   - 例: 100の倍数で特別なメッセージ

3. **色の変更**
   - 例: カウントが偶数/奇数で色を変える

## 📖 参考資料

- [Flutter公式ドキュメント](https://flutter.dev/)
- [Riverpod公式ドキュメント](https://riverpod.dev/)
- [Dart言語ガイド](https://dart.dev/guides)

---

**Happy Coding! 🎉**

このサンプルを参考に、自分だけのアプリを作ってみてください！
