# Node.js Addons Playground

This repo is where I'm learning how Node.js addons work.

I'm experimenting with native modules (mostly using N-API and C++) to understand how to extend Node.js beyond JavaScript. Right now, I'm still figuring things out, but I'm starting to build my own small libraries as I go.

I may or may not build something more similar to [a template repository like this really good example by xan](https://github.com/xan105/node-addons/)

Nothing here is final, so it's all just part of the learning process.

## Layout

- `src/addon.cc` is the C++ addon, built by `node-gyp` via `binding.gyp`.
- `lib/index.ts` wraps it in a typed ESM entry point. Because `.node` files
  can't be imported as ESM, it loads the binary through `createRequire()`.
- `test/` holds the Jest suite, which exercises the built addon.

## Scripts

| Script | What it does |
| --- | --- |
| `npm run build` | Build the native addon (`node-gyp`) and compile TypeScript. |
| `npm run build:debug` | Build the native addon with debug symbols. |
| `npm run clean` | Remove native build output and `dist/`. |
| `npm test` | Build, then run the Jest suite. |
| `npm run typecheck` | Type-check without emitting. |
| `npm run lint` / `lint:fix` | Run ESLint (optionally auto-fixing). |
| `npm run format` | Format C/C++ sources with clang-format. |
| `npm run docs` | Generate HTML API docs into `docs/` with TypeDoc. |
| `npm run changelog` | Regenerate `CHANGELOG.md` from the commit history. |

Commits follow [Conventional Commits](https://www.conventionalcommits.org);
`commitlint` checks the message and [lefthook](https://lefthook.dev) runs ESLint
and `clang-format` on staged files before each commit. Hooks install themselves
via the `prepare` script on `npm install`.

## Releasing

`./release.sh v[X.Y.Z]` bumps the version in `package.json`, regenerates
`CHANGELOG.md`, commits, and creates an annotated tag. Then
`git push && git push --tags`.

Only `dist/`, `build/Release`, `src/` and `binding.gyp` are published (the
`"files"` allowlist in `package.json`).
