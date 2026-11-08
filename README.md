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

Right now the addon exports one function, `hello()`, which returns
`"Hello from C++!"`. Building needs Node 24+ and a C++ toolchain for
`node-gyp`. CI builds on Linux, macOS and Windows with Node 24.
