// browser.*{{{
// browser.tabs.*{{{
// タブは常に表示
user_pref("browser.tabs.autoHide",false);
// タブのclose buttonを消す
user_pref("browser.tabs.closeButtons",2);
// 新規タブを右端に開く
user_pref("browser.tabs.insertRelatedAfterCurrent",false);
// ブックマークを新規タブで開いた時にバックグラウンドで開く
user_pref("browser.tabs.loadBookmarksInBackground", true);
// 外部アプリケーションからURLを渡された場合はバックグラウンドで開く
user_pref("browser.tabs.loadDivertedInBackground", true);
// タブを閉じた後に表示するタブは閉じたタブの1つ左のタブ
user_pref("browser.tabs.selectOwnerOnClose",false);
// タブ開閉時のアニメーションを無効
user_pref("browser.tabs.animate",false);
// }}}browser.tabs.*
// browser.sessionstore.*{{{
// セッションを保存する間隔
user_pref("browser.sessionstore.interval",600000);
// 起動時に読み込むタブの数
user_pref("browser.sessionstore.max_concurrent_tabs",0);
// 以前閉じた復元可能なウィンドウの数
user_pref("browser.sessionstore.max_windows_undo",0);
// }}}browser.sessionstore.*
// 戻る・進むのメモリ保存を制御
user_pref("browser.sessionhistory.max_total_viewers",0);
//タブグループ切替時時のアニメーションを無効
user_pref("browser.panorama.animate_zoom",false);
// フルスクリーンのアニメーションを無効
user_pref("browser.fullscreen.animateUp",0);
// ブックマークバックアップ数
user_pref("browser.bookmarks.max_backups",1);
// 終了時にタブを保存するか訊かせる
user_pref("browser.showQuitWarning",true);
// googleで検索をする
user_pref("browser.search.defaultenginename","Google");
// 新しいタブをabout:blankにする
user_pref("browser.newtab.url","about:blank");
// browser.cache.*{{{
// メモリキャッシュの量を指定
user_pref("browser.cache.memory.capacity",1024);
// ハードディスクのキャッシュを無効
user_pref("browser.cache.disk.enable",false);
// メモリのキャッシュを無効
user_pref("browser.cache.memory.enable",false);
// オフラインのキャッシュを無効
user_pref("browser.cache.offline.enable",false);
// ハードディスクのキャッシュの容量
user_pref("browser.cache.disk.capacity",0);
// メモリのキャッシュの容量
user_pref("browser.cache.memory.capacity",0);
// }}}browser.cache.*
// browser.safebrowsing.*{{{
// 偽装サイトとして報告されているサイトをブロックしない
user_pref("browser.safebrowsing.enabled",false);
// 攻撃サイトとして報告されているサイトをブロックしない
user_pref("browser.safebrowsing.malware.enabled",false);
// }}}browser.safebrowsing.*
// browser.urlbar.*{{{
// urlのhttp://を表示
user_pref("browser.urlbar.trimURLs",false);
// ドメインハイライトを無効
user_pref("browser.urlbar.formatting.enabled",false);
// }}}browser.urlbar.*
// browser.download.*{{{
// ダウンロード時のウイルススキャンを無効にする
user_pref("browser.download.manager.scanWhenDone",false);
// Windowsの最近開いたファイル（項目）に追加しない
user_pref("browser.download.manager.addToRecentDocs", false);
// ダウンロード履歴を 0:残さない 1:終了時にクリアする 2:クリアしない
user_pref("browser.download.manager.retention",0);
// }}}browser.download.*
// browser.taskbar.*{{{
// よく見るページ
user_pref("browser.taskbar.lists.frequent.enabled", false);
//最近見たページ
user_pref("browser.taskbar.lists.recent.enabled", false);
//タスク
user_pref("browser.taskbar.lists.tasks.enabled", false);
//タスクバープレビュー
user_pref("browser.taskbar.previews.enable", false);
// }}}browser.taskbar.*
// }}}browser.*
// network.*{{{
// 先読みしない
user_pref("network.prefetch-next",false);
// refererを許可しない
user_pref("network.http.sendRefererHeader",0);
// IPv6無効
user_pref("network.dns.disableIPv6",true);
// 圧縮形式をacceptで送信しない
//user_pref("network.http.accept-encoding","");
// cookieを許可するか:0全て許可 :1そのサイトのみ :2全て拒否
user_pref("network.cookie.cookieBehavior",2);
// network.http.*{{{
// 同時ダウンロード数 30
user_pref("network.http.max-persistent-connections-per-server",30);
// 扱えるファイル形式のacceptを送信しない
user_pref("network.http.accept.default","");
// }}}network.http.*
// network.protocol-handler.*{{{
// 全てのスキームを処理することを許可しない (直接リンクを開いた場合は強制的に許可されている)
user_pref("network.protocol-handler.expose-all", false);
// httpプロトコルを処理することを許可する
user_pref("network.protocol-handler.expose.http", true);
// httpsプロトコルを処理することを許可する
user_pref("network.protocol-handler.expose.https", true);
// ftpプロトコルを処理することを許可する
user_pref("network.protocol-handler.expose.ftp", true);
// 処理できない全てのスキームをOSで定義されているアプリケーションに渡すことを許可しない
user_pref("network.protocol-handler.external-default", false);
// 全てのスキームを外部のアプリケーションで処理する際に警告を表示する
user_pref("network.protocol-handler.warn-external-default", true);
// }}}network.protocol-handler.*
// }}}network.*
// dom.*{{{
// ウィンドウ移動・サイズ変更を許可しない（JavaScript の詳細設定）
user_pref("dom.disable_window_move_resize",true);
// 右クリック禁止ページを回避（JavaScript の詳細設定）
user_pref("dom.event.contextmenu.enabled",false);
// plugin-container.exe無効
user_pref("dom.ipc.plugins.enabled",false);
// }}}dom.*
// config.*{{{
// 最小化でメモリ減らす
user_pref("config.trim_on_minimize",true);
// }}}config.*
// geo.*{{{
// 位置情報通知機能を恒久的に無効
user_pref("geo.enabled",false);
// }}}geo.*
// gfx.*{{{
// Direct 2D 無効
user_pref("gfx.direct2d.disabled", true);
// }}}gfx.*
// layers.*{{{
// ハードウェアアクセラレーション 無効
user_pref("layers.acceleration.disabled", true);
// }}}layers.*
// plugin.*{{{
// about:pluginsでフルパス表示
user_pref("plugin.expose_full_path", true);
// }}}plugin.*
// ui.*{{{
// サブメニュー開くまでの時間
user_pref("ui.submenuDelay", 0);
// }}}ui.*
// javascript.*{{{
// javascriptを切る
user_pref("javascript.enabled",false);
// }}}javascript.*
// permissions.*{{{
// 全てのサイトで画像を読み込まない
//user_pref("permissions.default.image",2);
// }}}permissions.*
// general.*{{{
// useragentを送信しない
user_pref("general.useragent.override","");
// firefoxの言語設定を英語にする
user_pref("general.useragent.locale","en-US");
// }}}general.*
// security.*{{{
// sslを使用しているサイトから使用していないサイトに移動した場合、警告を発する
//user_pref("security.warn_leaving_secure",true);
// アドオンをインストールする時の待ち時間をなくす
user_pref("security.dialog_enable_delay",0);
// }}}security.*
// layout.*{{{
// 自動スペルチェックを無効
user_pref("layout.spellcheckDefault",0);
// }}}layout.*
// image.*{{{
// imageのacceptを送信しない
user_pref("image.http.accept","");
// }}}image.*
// intl.*{{{
// 言語を指定するacceptを送信しない
user_pref("intl.accept_languages","");
// }}}intl.*
// nglayout.*{{{
// ページをレンダリングする前の待ち時間
user_pref("nglayout.initialpaint.delay",0);
// }}}nglayout.*
// privacy.*{{{
// 終了時にcacheを削除
user_pref("privacy.clearOnShutdown.cache",true);
// 終了時にcookieを削除
user_pref("privacy.clearOnShutdown.cookies",true);
// 終了時にダウンロード履歴を削除
user_pref("privacy.clearOnShutdown.downloads",true);
// 終了時にテキストボックスの履歴を削除
user_pref("privacy.clearOnShutdown.formdata",true);
// 終了時に閲覧履歴を削除
user_pref("privacy.clearOnShutdown.history",true);
// 終了時にオフラインデータを削除
user_pref("privacy.clearOnShutdown.offlineApps",true);
// 終了時にパスワードを削除
user_pref("privacy.clearOnShutdown.passwords",true);
// 終了時にactive loginsを削除
user_pref("privacy.clearOnShutdown.sessions",true);
// 終了時にsite preferenceを削除
user_pref("privacy.clearOnShutdown.siteSettings",true);
// トラッキング拒否をwebに通知
user_pref("privacy.donottrackheader.enabled",true);
// }}}privacy.*
// vim: set foldmethod=marker:
