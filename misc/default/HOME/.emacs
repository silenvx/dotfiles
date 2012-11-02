; メニューバーは非表示
(menu-bar-mode 0)

; navi2ch{{{
(require 'navi2ch)
; proxy on navi2ch
(setq navi2ch-net-http-proxy "127.0.0.1:8118")
;スレッド全体を表示
(setq navi2ch-article-auto-range nil)
; }}}navi2ch

; emacs-w3m{{{
(require 'w3m-load)
; add search engine
(eval-after-load "w3m-search"
                 '(add-to-list 'w3m-search-engine-alist
                               '("google" "https://encrypted.google.com/search?num=100&ie=utf-8&oe=utf-8&hl=ja&safe=off&filter=0&pws=0&complete=0&gbv=1&q=%s" utf-8)))
(eval-after-load "w3m-search"
                 '(add-to-list 'w3m-search-engine-alist
                               '("yahoo" "http://search.yahoo.co.jp/search?fl=0&n=100&ei=UTF-8&p=%s" utf-8)))
; select search engine
(setq w3m-search-default-engine "google")
; image auto view
;(setq w3m-default-display-inline-images t)
; cookieを有効
(setq w3m-use-cookies 1)
; ホームページの設定
(setq w3m-home-page "about:blank")
; リファラーを送信しない
(setq w3m-add-referer nil)
; }}}emacs-w3m

; default browser
(setq browse-url-browser-function 'w3m-browse-url url)

; input method
(set-language-environment "Japanese")
;(require 'mozc)
;(setq default-input-method "japanese-mozc")

;(require 'site-gentoo)

; 画面外に出た時のスクロール幅
(setq scroll-conservatively 1)
(setq scroll-step 1)
; スタート画面のメッセージを消す
(setq inhibit-startup-message 1)
; 下のラインに行番号などを表示
(line-number-mode 1)
(column-number-mode 1)

; bindてきな{{{
; 半画面スクロール{{{
(define-key global-map (kbd "H-d") '(lambda () (interactive) (scroll-up (/ (window-height) 2))))
(define-key global-map (kbd "H-u") '(lambda () (interactive) (scroll-down (/ (window-height) 2))))
(define-key global-map (kbd "ESC <f12> d") '(lambda () (interactive) (scroll-up (/ (window-height) 2))))
(define-key global-map (kbd "ESC <f12> u") '(lambda () (interactive) (scroll-down (/ (window-height) 2))))
; }}}半画面スクロール
; 一行スクロール{{{
(define-key global-map (kbd "H-n") '(lambda (arg) (interactive "p") (scroll-up arg)))
(define-key global-map (kbd "H-p") '(lambda (arg) (interactive "p") (scroll-down arg)))
(define-key global-map (kbd "ESC <f12> n") '(lambda (arg) (interactive "p") (scroll-up arg)))
(define-key global-map (kbd "ESC <f12> p") '(lambda (arg) (interactive "p") (scroll-down arg)))
; }}}一行スクロール
; }}}bindてきな

; vim: set fdm=marker:
