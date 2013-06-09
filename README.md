MCSample
====================

DESCRIPTION
--------------------

主に loopback インターフェイスでアプリケーション内 IP Multicast
パケットの送受信処理を検証するためのサンプル。


PLATFORM
--------------------

iOS 6.1 以上。但しそれ以下でもコード自体は動作するだろう。


PREPARATION
--------------------

コンパイルにあたっては ARC を有効化すること。

USAGE
--------------------

Consoleへ接続した上での実行が前提。実行すると Multicast を受
信するサーバが起動し、一秒後に、ただひとつの Multicast パケッ
トが送出される。受信できたか否かは、ログを見ること。UI上は空
のView以外、何も表示されない。

INFORMATION
--------------------

`MCSample-Prefix.pch` 内の define により設定変更が可能である。
詳細はコードを参照のこと。

### クライアント設定

* `SEND_PACKET_TO_LOOPBACK`

自分の送出した Multicast パケットを自身で受信するか否か。受
信しない場合、サーバはいずれのパケットも受信しないはずである。

* `SETUP_SEND_MULTICAST_IF_LO0`
* `SETUP_SEND_MULTICAST_IF_EN0`

Multicast パケットの送出を lo0、en0 のどちらで行うか。設定は
排他である。両者ともに設定しない場合、Kernelが自動的に決定す
る。

### サーバ設定

* `BIND_ACCEPT_INADDR`

サーバのbindをINADDR_ANYで行うか、特定 Multicast address で行うか。

* `BIND_ACCEPT_MULTICAST_IF_LO0`
* `BIND_ACCEPT_MULTICAST_IF_EN0`

Multicast address への join パケットを lo0 から送出するか、
en0 から送出するか。設定は排他である。両者ともに設定しない場
合、INADDR_ANYが設定され、Kernelが自動的に決定する。


AUTHOR
--------------------

MIYOKAWA, Nobuyoshi

* E-Mail: n-miyo@tempus.org
* Twitter: nmiyo
* Blog: http://blogger.tempus.org/


COPYRIGHT
--------------------

PDS。著作権は主張しない。
