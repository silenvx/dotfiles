// タブは常に表示
user_pref("browser.tabs.autoHide",false);
// タブのclose buttonを消す
user_pref("browser.tabs.closeButtons",2);
// ウィンドウ移動・サイズ変更を許可しない（JavaScript の詳細設定）
user_pref("dom.disable_window_move_resize",true);
// 右クリック禁止ページを回避（JavaScript の詳細設定）
user_pref("dom.event.contextmenu.enabled",false);
// 先読みしない
user_pref("network.prefetch-next",false);
// refererを許可しない
user_pref("network.http.sendRefererHeader",0);
// 戻る・進むのメモリ保存を制御
user_pref("browser.sessionhistory.max_total_viewers",0);
// メモリキャッシュの量を指定
user_pref("browser.cache.memory.capacity",1024);
// 新規タブを右端に開く
user_pref("browser.tabs.insertRelatedAfterCurrent",false);
// キャッシュを無効
user_pref("browser.cache.disk.enable",false);
user_pref("browser.cache.memory.enable",false);
user_pref("browser.cache.offline.enable",false);
user_pref("browser.cache.disk.capacity",0);
user_pref("browser.cache.memory.capacity",0);
// IPv6無効
user_pref("network.dns.disableIPv6",true);
// plugin-container.exe無効
user_pref("dom.ipc.plugins.enabled",false);
// 最小化でメモリ減らす
user_pref("config.trim_on_minimize",true);
// セッションストア
user_pref("browser.sessionstore.interval",600000);
user_pref("browser.sessionstore.max_concurrent_tabs",0);
user_pref("browser.sessionstore.max_windows_undo",0);
// タブ、パノラマ、フルスクリーンのアニメーション 無効
user_pref("browser.panorama.animate_zoom",false);
user_pref("browser.tabs.animate",false);
user_pref("browser.fullscreen.animateUp",0);
// ブックマークバックアップ数
user_pref("browser.bookmarks.max_backups",1);
// 位置情報通知機能を恒久的に無効
user_pref("geo.enabled",false);
// Direct 2D 無効
user_pref("gfx.direct2d.disabled", true);
// ハードウェアアクセラレーション 無効
user_pref("layers.acceleration.disabled", true);
// リンク、外部リンク　バックグラウンドで開く
user_pref("browser.tabs.loadBookmarksInBackground", true);
user_pref("browser.tabs.loadDivertedInBackground", true);
// about:pluginsでフルパス表示
user_pref("plugin.expose_full_path", true);
// サブメニュー開くまでの時間
user_pref("ui.submenuDelay", 0);
// 同時ダウンロード数 30
user_pref("network.http.max-persistent-connections-per-server",30);
// urlのhttp://を表示
user_pref("browser.urlbar.trimURLs",false);
// ドメインハイライトを無効
user_pref("browser.urlbar.formatting.enabled",false);
// javascriptを切る
user_pref("javascript.enabled",false);
// ダウンロード時のウイルススキャンを無効にする
user_pref("browser.download.manager.scanWhenDone",false);
// タブを閉じた後に表示するタブは閉じたタブの1つ左のタブ
user_pref("browser.tabs.selectOwnerOnClose=false",false);
    // 全てのサイトで画像を読み込まない
//user_pref("permissions.default.image",2);
// useragentを送信しない
user_pref("general.useragent.override","");
    // sslを使用しているサイトから使用していないサイトに移動した場合、警告を発する
//user_pref("security.warn_leaving_secure,"true);
// トラッキング拒否をwebに通知
user_pref("privacy.donottrackheader.enabled",true);
// 自動スペルチェックを無効
user_pref("layout.spellcheckDefault",0);
// Windowsの最近開いたファイル（項目）に追加しない
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.taskbar.lists.frequent.enabled", false);
// imageのacceptを送信しない
user_pref("image.http.accept","");
// 言語を指定するacceptを送信しない
user_pref("intl.accept_languages","");
// 扱えるファイル形式のacceptを送信しない
user_pref("network.http.accept.default","");
    // 圧縮形式をacceptで送信しない
//user_pref("network.http.accept-encoding","");
// cookieを許可するか:0全て許可 :1そのサイトのみ :2全て拒否
user_pref("network.cookie.cookieBehavior",2);
// 終了時にタブを保存するか訊かせる
user_pref("browser.showQuitWarning",true);
// firefoxの言語設定を英語にする
user_pref("general.useragent.locale","en-US");
// 偽装サイトとして報告されているサイトをブロックしない
user_pref("browser.safebrowsing.enabled",false);
// 攻撃サイトとして報告されているサイトをブロックしない
user_pref("browser.safebrowsing.malware.enabled",false);
// googleで検索をする
user_pref("browser.search.defaultenginename","Google");
// ページをレンダリングする前の待ち時間
user_pref("nglayout.initialpaint.delay",0);
// アドオンをインストールする時の待ち時間をなくす
user_pref("security.dialog_enable_delay",0);
// 新しいタブをabout:blankにする
user_pref("browser.newtab.url","about:blank");
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
