ubuntu@VM-12-3-ubuntu:~/workGao/my_rime_MaxVersion/script_Max$
ubuntu@VM-12-3-ubuntu:~/workGao/my_rime_MaxVersion/script_Max$ bash run_local.sh  --port 5042
==> Working directory: /home/ubuntu/workGao/my_rime_MaxVersion
==> Installing dependencies with pnpm...
 WARN  deprecated eslint@8.57.1: This version is no longer supported. Please see https://eslint.org/version-support for other options.
 WARN  Request took 12863ms: https://registry.npmjs.org/to-regex-range
 WARN  Request took 33274ms: https://registry.npmjs.org/@types%2Fnode
 WARN  7 deprecated subdependencies found: @humanwhocodes/config-array@0.13.0, @humanwhocodes/object-schema@2.0.3, glob@7.2.3, inflight@1.0.6, rimraf@3.0.2, source-map@0.8.0-beta.0, sourcemap-codec@1.4.8
Packages: +613
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Progress: resolved 678, reused 611, downloaded 0, added 613, done
 WARN  Issues with peer dependencies found
.
└─┬ eslint-config-standard 17.1.0
  └── ✕ unmet peer eslint-plugin-n@"^15.0.0 || ^16.0.0 ": found 17.23.1

devDependencies:
+ @codemirror/language 6.11.3
+ @codemirror/legacy-modes 6.5.2
+ @libreservice/lazy-cache 0.1.2
+ @libreservice/micro-plum 0.2.3
+ @libreservice/my-widget 0.1.4
+ @libreservice/my-worker 0.4.2
+ @libreservice/wasm-code 0.1.5
+ @playwright/test 1.56.1
+ @rollup/plugin-json 6.1.0
+ @rollup/plugin-node-resolve 15.3.1 (16.0.3 is available)
+ @rollup/plugin-replace 5.0.7 (6.0.3 is available)
+ @types/js-yaml 4.0.9
+ @typescript-eslint/eslint-plugin 7.18.0 (8.46.3 is available)
+ @typescript-eslint/parser 7.18.0 (8.46.3 is available)
+ @vicons/fa 0.12.0 (0.13.0 is available)
+ @vicons/fluent 0.12.0 (0.13.0 is available)
+ @vicons/material 0.12.0 (0.13.0 is available)
+ @vitejs/plugin-vue 5.2.4 (6.0.1 is available)
+ client-zip 2.5.0
+ emoji-regex 10.6.0
+ esbuild 0.23.1 (0.25.12 is available)
+ eslint 8.57.1 (9.39.1 is available) deprecated
+ eslint-config-standard 17.1.0
+ eslint-plugin-import 2.32.0
+ eslint-plugin-n 17.23.1
+ eslint-plugin-promise 6.6.0 (7.2.1 is available)
+ eslint-plugin-vue 9.33.0 (10.5.1 is available)
+ glob 11.0.3
+ idb 8.0.3
+ js-yaml 4.1.0
+ luaparse 0.3.1
+ naive-ui 2.43.1
+ rimraf 6.1.0
+ rollup 4.52.5
+ rollup-plugin-esbuild 6.2.1
+ rppi 0.1.0
+ textarea-caret 3.1.0
+ ts-node 10.9.2
+ tslib 2.8.1
+ typescript 5.9.3
+ vite 5.4.21 (7.2.1 is available)
+ vite-plugin-pwa 0.20.5 (1.1.0 is available)
+ vite-plugin-run 0.4.1 (0.6.1 is available)
+ vooks 0.2.12
+ vue 3.5.23
+ vue-router 4.6.3
+ vue-tsc 2.2.12 (3.1.3 is available)

Done in 1m 21.2s using pnpm v10.20.0
==> Approving esbuild postinstall (required by Vite/Rollup)...
There are no packages awaiting approval
==> Downloading prebuilt worker.js...
==> Trying https://cdn.jsdelivr.net/npm/@libreservice/my-rime@0.10.9/dist/worker.js
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:-- 100 19923    0 19923    0     0  22216      0 --:--:-- --:--:-- --:--:-- 22235
==> Downloaded worker.js from https://cdn.jsdelivr.net/npm/@libreservice/my-rime@0.10.9/dist/worker.js
==> Starting API server on port 8787...
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
curl: (7) Failed to connect to localhost port 8787 after 0 ms: Connection refused
==> API server is healthy.
==> Starting Vite dev server on port 5042...
    Open http://localhost:5042/ after server starts.

> @libreservice/my-rime@0.10.9 dev /home/ubuntu/workGao/my_rime_MaxVersion
> vite --host

7:55:05 PM [vite] warning: @rollup/plugin-replace: 'preventAssignment' currently defaults to false. It is recommended to set this option to `true`, as the next major version will default this option to `true`.
  Plugin: replace

  VITE v5.4.21  ready in 565 ms

  ➜  Local:   http://localhost:5042/
  ➜  Network: http://10.0.12.3:5042/
  ➜  Network: http://172.17.0.1:5042/
  ➜  press h + enter to show help

> @libreservice/my-rime@0.10.9 worker /home/ubuntu/workGao/my_rime_MaxVersion
> rollup -c rollup.worker-config.js


src/worker.ts → public...
(!) [plugin replace] @rollup/plugin-replace: 'preventAssignment' currently defaults to false. It is recommended to set this option to `true`, as the next major version will default this option to `true`.
[!] RollupError: Could not resolve "../schema-name.json" from "src/worker.ts"
src/worker.ts
    at getRollupError (/home/ubuntu/workGao/my_rime_MaxVersion/node_modules/.pnpm/rollup@4.52.5/node_modules/rollup/dist/shared/parseAst.js:285:41)
    at Object.error (/home/ubuntu/workGao/my_rime_MaxVersion/node_modules/.pnpm/rollup@4.52.5/node_modules/rollup/dist/shared/parseAst.js:281:42)
    at ModuleLoader.handleInvalidResolvedId (/home/ubuntu/workGao/my_rime_MaxVersion/node_modules/.pnpm/rollup@4.52.5/node_modules/rollup/dist/shared/rollup.js:22794:36)
    at /home/ubuntu/workGao/my_rime_MaxVersion/node_modules/.pnpm/rollup@4.52.5/node_modules/rollup/dist/shared/rollup.js:22754:26


 ELIFECYCLE  Command failed with exit code 1.