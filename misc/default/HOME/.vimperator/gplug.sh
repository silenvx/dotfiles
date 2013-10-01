#!/bin/sh
# ~/.vimperator/plugin/にpluginをwgetするだけ
mkdir -p ~/.vimperator/plugin
cd ~/.vimperator/plugin
LIST="https://raw.github.com/vimpr/vimperator-plugins/master/appendAnchor.js
https://raw.github.com/vimpr/vimperator-plugins/master/copy.js
https://raw.github.com/caisui/vimperator/master/plugin/hints-ext.js
https://raw.github.com/vimpr/vimperator-plugins/master/_libly.js
https://raw.github.com/vimpr/vimperator-plugins/master/statusline-toolbar.js
https://raw.github.com/vimpr/vimperator-plugins/master/stella.js
https://raw.github.com/vimpr/vimperator-plugins/master/walk-input.js
"

for TMP in $LIST;do
    wget -c "${TMP}"
    sleep 2
done
