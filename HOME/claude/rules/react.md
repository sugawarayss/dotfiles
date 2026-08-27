---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
---

## React実装のルール

### 派生値は`useEffect`で同期せず、レンダー中に計算する

```tsx
// BAD
const [fullName, setFullName] = useState("");
useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);

// GOOD
const fullName = `${firstName} ${lastName}`;
```

### リストの`key`にはindexではなく安定した一意なIDを使う

indexをkeyにすると、並べ替えや要素の追加・削除時にコンポーネントの状態やDOMが誤って対応付けられる。

```tsx
// BAD
{items.map((item, index) => <Item key={index} {...item} />)}

// GOOD
{items.map((item) => <Item key={item.id} {...item} />)}
```

### 再利用するステートフルロジックはカスタムフックに切り出す

コンポーネント内に同じ`useState`/`useEffect`の組み合わせが複数箇所に現れたら、`use〇〇`という名前のカスタムフックへ抽出する。

### `useMemo`/`useCallback`は計測してから使う

重い計算処理、または子コンポーネントへの参照の安定化が実際に必要な場合のみ使う。全ての値・関数へ機械的に付与しない（早すぎる最適化。[[design_principles]]のYAGNI参照）。

### 失敗しうる境界には`ErrorBoundary`を設置する

外部データ取得や実験的機能を含むサブツリーは`ErrorBoundary`で囲み、そのエラーがアプリ全体をクラッシュさせないようにする。
