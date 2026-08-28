## TypeScript実装のルール

### 明示的な`any`を避ける

型が不明な場合は`any`ではなく`unknown`を使い、型ガードで絞り込む。

```ts
// BAD
function parse(input: any) {
  return input.value;
}

// GOOD
function parse(input: unknown) {
  if (typeof input === "object" && input !== null && "value" in input) {
    return input.value;
  }
  throw new Error("invalid input");
}
```

### 状態のバリエーションはUnion型で表現する

オプショナルフラグの組み合わせで状態を表現すると、あり得ない組み合わせ（例: `isLoading: true`かつ`data`が存在）を型で防げない。

```ts
// BAD
type State = {
  isLoading: boolean;
  data?: User;
  error?: Error;
};

// GOOD
type State =
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: Error };
```

### 型のみのインポートには`import type`を使う

ビルド時に型情報が消去されることを明示し、不要なランタイム依存や循環importを防ぐ。

```ts
// BAD
import { User } from "./user";

// GOOD
import type { User } from "./user";
```

### リテラル型を保持したい場合は`as const`を使う

```ts
// BAD
const roles = ["admin", "editor"]; // string[]

// GOOD
const roles = ["admin", "editor"] as const; // readonly ["admin", "editor"]
```

### 型を広げずに検証したい場合は`satisfies`を使う

```ts
// BAD(widening: Record<string, string>に広がり、個々のプロパティの具体的な型を失う)
const config: Record<string, string> = { host: "localhost", port: "3000" };

// GOOD(configの各プロパティの型は維持しつつ、形状だけ検証する)
const config = { host: "localhost", port: "3000" } satisfies Record<string, string>;
```
