# share1
#setting.jsonを以下に掲載する。

{
    "workbench.colorTheme": "Atom One Dark",
    "files.autoGuessEncoding": true,
    //latex 
    // 日本語文書で単語移動を使うため、助詞や読点、括弧を区切り文字として指定する
    "editor.wordSeparators": "./\\()\"'-:,.;<>~!@#$%^&*|+=[]{}`~?　、。「」【】『』（）！？てにをはがのともへでや",

    // 設定: LaTeX Workshop

    // LaTeX Workshop ではビルド設定を「Tool」と「Recipe」という2つで考える
    //   Tool: 実行される1つのコマンド。コマンド (command) と引数 (args) で構成される
    //   Recipe: Tool の組み合わわせを定義する。Tool の組み合わせ (tools) で構成される。
    //           tools の中で利用される Tool は "latex-workshop.latex.tools" で定義されている必要がある。
    
    // latex-workshop.latex.tools: Tool の定義
    "latex-workshop.latex.tools": [
      
      // latexmk を利用した lualatex によるビルドコマンド
      {
        "name": "Latexmk (LuaLaTeX)",
        "command": "latexmk",
        "args": [
          "-f", "-gg", "-lualatex", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "-outdir=%OUTDIR%","%DOC%"
        ]
      },
      // latexmk を利用した xelatex によるビルドコマンド
      {
        "name": "Latexmk (XeLaTeX)",
        "command": "latexmk",
        "args": [
          "-f", "-gg", "-xelatex", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"
        ]
      },
      // latexmk を利用した uplatex によるビルドコマンド
      {
        "name": "Latexmk (upLaTeX)",
        "command": "latexmk",
        "args": [
          "-f", "-gg", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"
        ]
      },
      // latexmk を利用した platex によるビルドコマンド
      // 古い LaTeX のテンプレートを使いまわしている (ドキュメントクラスが jreport や jsreport ) 場合のため
      {
        "name": "Latexmk (pLaTeX)",
        "command": "latexmk",
        "args": [
          "-f", "-gg",  "-latex='platex'", "-latexoption='-kanji=utf8 -no-guess-input-env'", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"
        ]
      }
  ],

  // latex-workshop.latex.recipes: Recipe の定義
  "latex-workshop.latex.recipes": [
      // LuaLaTeX で書かれた文書のビルドレシピ
      {
        "name": "LuaLaTeX",
        "tools": [
          "Latexmk (LuaLaTeX)"
        ]
      },
      // XeLaTeX で書かれた文書のビルドレシピ
      {
        
        "name": "XeLaTeX",
        "tools": [
          "Latexmk (XeLaTeX)"
        ]
      },
      // LaTeX(upLaTeX) で書かれた文書のビルドレシピ
      {
        "name": "upLaTeX",
        "tools": [
          "Latexmk (upLaTeX)"
        ]
      },
      // LaTeX(pLaTeX) で書かれた文書のビルドレシピ
      {
        "name": "pLaTeX",
        "tools": [
          "Latexmk (pLaTeX)"
        ]
      },
  ],

    // latex-workshop.latex.magic.args: マジックコメント付きの LaTeX ドキュメントをビルドする設定
    // '%!TEX' で始まる行はマジックコメントと呼ばれ、LaTeX のビルド時にビルドプログラムに解釈され、
    // プログラムの挙動を制御する事ができる。
    // 参考リンク: https://blog.miz-ar.info/2016/11/magic-comments-in-tex/
    "latex-workshop.latex.magic.args": [
      "-f", "-gg", "-pv", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOC%"
    ],

    // latex-workshop.latex.clean.fileTypes: クリーンアップ時に削除されるファイルの拡張子
    // LaTeX 文書はビルド時に一時ファイルとしていくつかのファイルを生成するが、最終的に必要となるのは
    // PDF ファイルのみである場合などが多い。また、LaTeX のビルド時に失敗した場合、失敗時に生成された
    // 一時ファイルの影響で、修正後のビルドに失敗してしまう事がよくある。そのため、一時的なファイルを
    // 削除する機能 (クリーンアップ) が LaTeX Workshop には備わっている。
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux", "*.bbl", "*.blg", "*.idx", "*.ind", "*.lof", "*.lot", "*.out", "*.toc", "*.acn", "*.acr", "*.alg", "*.glg", "*.glo", "*.gls", "*.ist", "*.fls", "*.log", "*.fdb_latexmk", "*.synctex.gz",
        // for Beamer files
        "_minted*", "*.nav", "*.snm", "*.vrb",
    ],

    // latex-workshop.latex.autoClean.run: ビルド失敗時に一時ファイルのクリーンアップを行うかどうか
    // 上記説明にもあったように、ビルド失敗時に生成された一時ファイルが悪影響を及ぼす事があるため、自動で
    // クリーンアップがかかるようにしておく。

    "latex-workshop.latex.autoClean.run": "onBuilt",

    // latex-workshop.view.pdf.viewer: PDF ビューアの開き方
    // VSCode 自体には PDF ファイルを閲覧する機能が備わっていないが、
    // LaTeX Workshop にはその機能が備わっている。
    // "tab" オプションを指定すると、今開いているエディタを左右に分割し、右側に生成されたPDFを表示するようにしてくれる
    // この PDF ビュアーは LaTeX のビルドによって更新されると同期して内容を更新してくれる。
    "latex-workshop.view.pdf.viewer": "tab",

    // latex-workshop.latex.autoBuild.run: .tex ファイルの保存時に自動的にビルドを行うかどうか
    // LaTeX ファイルは .tex ファイルを変更後にビルドしないと、PDF ファイル上に変更結果が反映されないため、
    // .tex ファイルの保存と同時に自動的にビルドを実行する設定があるが、文書が大きくなるに連れてビルドにも
    // 時間がかかってしまい、ビルドプログラムの負荷がエディタに影響するため、無効化しておく。
    "latex-workshop.latex.autoBuild.run": "never",

    "[tex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },

    "[latex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },

    "[bibtex]": {
        // インデント幅を2にする
        "editor.tabSize": 2
    },


    // ---------- LaTeX Workshop ----------

    // 使用パッケージのコマンドや環境の補完を有効にする
    "latex-workshop.intellisense.package.enabled": true,

    // 生成ファイルを "out" ディレクトリに吐き出す
    "latex-workshop.latex.outDir": "out",
    "cmake.showOptionsMovedNotification": false,
    "processing.processingPath": "C:\\Program Files\\processing-4.3\\processing-java",
    "browse-lite.chromeExecutable": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
    "browse-lite.startUrl": "https://www.google.co.jp/",
    "code-runner.runInTerminal": true,
    "terminal.integrated.enableMultiLinePasteWarning": false,
    "diffEditor.hideUnchangedRegions.enabled": true,

}
