## アクセシビリティ実装のルール

React/Next.jsのUIコンポーネント実装時は、以下の観点を満たすこと。

### セマンティックHTMLを優先する

`div`/`span`への`onClick`付与でインタラクティブ要素を代用しない。

```tsx
// BAD
<div onClick={handleClick}>送信</div>

// GOOD
<button onClick={handleClick}>送信</button>
```

### フォーム要素にはlabelを関連付ける

```tsx
// BAD
<input type="text" placeholder="名前" />

// GOOD
<label htmlFor="name">名前</label>
<input id="name" type="text" />
```

### 画像には代替テキストを付与する

装飾目的の画像は `alt=""` で明示的に無視させる(alt属性の省略とは区別する)。

```tsx
// BAD
<img src="/logo.png" />

// GOOD
<img src="/logo.png" alt="サービスロゴ" />
<img src="/decoration.png" alt="" />
```

### インタラクティブ要素はキーボードでも操作可能にする

`div`/`span`をカスタムボタン化する場合は `tabIndex={0}` と `onKeyDown`(Enter/Space)を実装する。フォーカスインジケーター(`:focus`のoutline)を理由なく消さない。

### ARIAはセマンティックHTMLで表現できない場合のみ使う

`role`/`aria-*`属性を追加する前に、対応するネイティブHTML要素(`<button>`, `<nav>`, `<dialog>`等)で代替できないか検討する。

### 色だけに意味を持たせない

エラー表示や状態表示を色のみで区別しない。アイコンやテキストを併用する。
