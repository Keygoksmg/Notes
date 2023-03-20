# BigQuery tips  
<small>*Google cloudの開発が比較的早いので参考記事など古い可能性あり。(2022/12)</small>

## CSSの苦手を克服するときに躓いたメモ

### CSS / SCCS の違い。
- e.g., nestでかけるかどうか。

### z-index
- 初期値: auto
- 大きいほど上にくる。マイナスの値も指定可
- 使えないposition: statc
- 子要素のz-indexプロパティは、親要素のz-indexプロパティの値を継承しない。親要素のz-indexプロパティの値を継承するためには、z-index: inherit; を指定。


### position: static/ relation / absoluteの違い ([参考](https://midorigame-jo.com/css-position/))
- static: デフォルト。
	- 何も指定しなけれあstaticが使われる。
	- top/ left, bottomなどの位置指定ができない。
	- z-index(重なり)を指定できない
- relative
	- staticの位置を起点とする
	- top, left, bottomなどが指定可能。z-indexも可能。
	- absoluteの基準要素となる。
- absolute
	- relativeを含めたstatic以外が指定された親要素を起点とする
	- top, left, bottomなどが指定可能。z-indexも可能。
- fixed
	- 要素の位置を固定。スクロールしても動かない

	
### display: block/ inline/ inline-block ([参考](https://zero-plus.io/media/css-display-format-difference/))
- block
	-  縦に要素が並ぶ
	-  指定可能：幅と高さ、空白
	-  指定不可能：要素の位置
- inline
	-  横に要素が並ぶ
	-  指定可能：要素の位置
	-  指定不可能：幅と高さ、上下の空白
	-  blockの要素の中で使う
- inline-block
	-  縦に要素が並ぶ
	-  指定可能：幅、高さ、空白、要素の位置
	-  指定不可能： -
	-  横並びで、幅と高さ、余白を調整したい時に使う

### display: flex ([参考](https://webst8.com/blog/css-flex))
- 親要素をdisplay:flexを設定して(フレックスコンテナにして)、子要素を横(縦)並びにすることができる。
- 親要素のプロパティ
	- dissplay: flex 
	- justify-content: 小要素同士の間隔 (center: 主軸の中央, flex-start: 主軸の始点)
	- flex-wrap: 小要素を１行に並べるか、複数に並べるか　(初期値 nowrap: 1行, wrap: 複数行にする)
	- flex-direction: 小要素をどの方向で並べるか (row: 左から右、column: 上から下)
	- align-items: 交差軸に対して小要素をどの間隔で並べるか (strech: 始点から, center: 交差軸の中央)

- 子要素のプロパティ
	- order: 順番
	- flex-grow: flex itemを他の要素を比べてどれくらい伸ばすか	- flex-shrink: flex itemを他の要素を比べてどれくらい縮めるか
	- flex-basis: widthみたいなもの。初期値はauto。
	- flex: flex-grow、flex-shrink、flex-basisを１つにまとめて記載できる


### ::bofore, ::after([参考](https://mukolog.com/post-1594/))

### background-size: cover, contatin, auto([参考](https://www.keicode.com/script/css-background-size.php))

* * * *
