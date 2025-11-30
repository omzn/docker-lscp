# 汎用識別子抽出器 lscp : Docker化

汎用識別子抽出器 lscp (https://github.com/doofuslarge/lscp) をDockerからコマンドのように実行します．

## Dockerイメージのビルド

以下のコマンドでビルドします．
```
docker build ./ -t lscp 
```

Dockerイメージを作ったら，以下のようにして実行します．(ヘルプが表示されます)
```
docker run --rm -it -v .:/home/user_dir lscp lscp -h
```

shellのエイリアスで以下のように設定しておくと良いでしょう．
```
alias lscp='docker run --rm -it -v .:/home/user_dir lscp lscp'
```
以降は，コマンドから次のように実行するだけで良くなります．

```
lscp
```

## lscpの実行

`-h`オプションでヘルプが表示されます．

```
lscp [-hilo] [long options...]
    --in_path STR (or -i)              Directory to read input files from
    --out_path STR (or -o)             Directory to write output files to

    --[no-]is_code                     (default) Whether the input files
                                       are source code files or not
    --[no-]do_identifiers              (default) Whether to extract
                                       identifiers
    --[no-]do_string_literals          Whether to extract string literals
    --[no-]do_comments                 Whether to process comments
    --[no-]do_remove_digits            (default) Whether to remove digits
    --[no-]do_lower_case               (default) Whether to convert to
                                       lower case
    --[no-]do_stemming                 Whether to apply stemming
    --[no-]do_tokenize                 (default) Whether to tokenize
                                       words (e.g., camelCase,
                                       under_scores)
    --[no-]do_remove_punctuation       (default) Whether to remove
                                       punctuation
    --[no-]do_remove_small_words       (default) Whether to remove small
                                       words
    --small_word_size INT              (default = 1) Size threshold for
                                       small words
    --[no-]do_stopwords_english        Whether to remove English stop
                                       words
    --[no-]do_stopwords_keywords       Whether to remove programming
                                       language keywords
    --custom_stopwords STR             comma-separated custom stop words
    --[no-]do_remove_email_addresses   Whether to remove email addresses
    --[no-]do_remove_email_signatures  Whether to remove email signatures
    --[no-]do_remove_urls              Whether to remove URLs
    --[no-]do_remove_wrote_lines       Whether to remove lines that
                                       contain 'On , wrote:'
    --[no-]do_remove_quoted_emails     Whether to remove quoted email
                                       contents
    --[no-]do_remove_email_headers     Whether to remove email headers
    --file_extensions STR              comma-separated file extensions to
                                       process (e.g., java,py,cpp)

    --num_of_threads INT               number of threads to use

    --log_level STR (or -l)            log level (debug, info, warning,
                                       error)
    --log_file_path STR                log file path

    --help (or -h)                     print usage and exit
```

必須なのは，`-i` と `-o` の指定です．

* `--in_path` または `-i` で対象ファイルの入ったディレクトリを指定します．
* `--out_path` または `-o` で，抽出された識別子の出力されるディレクトリを指定します．

その他のオプションは必要に応じて設定してください．
一般的にリポジトリマイニングで使うことになりそうなオプションがデフォルトになっています．

### 使用例

次のようなディレクトリで，lscpを実行します．
```
.
├── in
│   ├── exp_lscp.py
│   └── lscpcmd.pl
└── out
```
実行は次のようにします．
```
$ lscp -i in -o out
```
実行後に，outにファイルが生成されます．
```
.
├── in
│   ├── exp_lscp.py
│   └── lscpcmd.pl
└── out
    ├── exp_lscp.py
    └── lscpcmd.pl
```
outの中のファイルは全て抽出した識別子だけになっています．
```
$ cat out/lscpcmd.pl 
usr
bin
perl
use
warnings
use
strict
use
lscp
use
getopt
long
descriptive
```

### 注意
* `--in_path`の中のファイルは再帰的に取得しますが，`--out_path`にはディレクトリ構造が保持されない形で書き出されます．(下の例参照)
```
.
├── in
│   ├── exp_lscp.py
│   └── sub
│       └── lscpcmd.pl
└── out
    ├── exp_lscp.py
    └── lscpcmd.pl
```