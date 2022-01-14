# Used by "mix format"
[
  inputs: [
    "mix.exs",
    "config/*.exs",
    "apps/*/{config,lib,priv,rel,test,browser_tests}/**/*.{ex,exs}",
    ],
  subdirectories: ["apps/*"],
  line_length: 120
]
