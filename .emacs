; メニューバーは非表示
(menu-bar-mode nil)

; navi2ch
(require 'navi2ch)
; proxy on navi2ch
(setq navi2ch-net-http-proxy "127.0.0.1:8118")
;スレッド全体を表示
(setq navi2ch-article-auto-range nil)

; emacs-w3m
(require 'w3m-load)
; add search engine
(eval-after-load "w3m-search"
                 '(add-to-list 'w3m-search-engine-alist
                               '("google" "https://encrypted.google.com/search?num=100&ie=utf-8&oe=utf-8&hl=ja&safe=off&filter=0&pws=0&complete=0&gbv=1&q=%s" utf-8)))
(eval-after-load "w3m-search"
                 '(add-to-list 'w3m-search-engine-alist
                               '("yahoo" "http://search.yahoo.co.jp/search?fl=0&n=100&ei=UTF-8&p=%s" utf-8)))
; select search engine
;(setq w3m-search-default-engine "yahoo")
;
; image auto view
;(setq w3m-default-display-inline-images t)

; default browser
(setq browse-url-browser-function 'w3m-browse-url url)

; input method
(require 'mozc)
(setq default-input-method "japanese-mozc")

(require 'site-gentoo)

; emacs-skype
(setq load-path
      (append
        (list
          (expand-file-name "~/.emacs.d/skype/")
          )
        load-path))
(require 'skype)
