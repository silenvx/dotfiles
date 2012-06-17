<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e90279b54f5c556b41fcb08c56a7c4f9f22a6226
導入方法
========
  
    ./symdot.sh help 
詳しくはこれでヘルプを参照してください

<<<<<<< HEAD
=======
このoverlayの使い方
=======
laymanを使うと非常に簡単です  
  
    # emerge app-portage/layman  
これで導入が可能です  
  
次に  
  
    # vim /etc/layman/layman.cfg  
設定ファイルを開いて  

overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml  
の下に最初にスペースを空けて  
https://raw.github.com/silenvx/portage/master/overlays.xml  
を追加して  
  
    # layman -L|grep silenvx  
出てきたら登録はできているので  
  
    # layman -a silenvx  
laymanに登録してください  
  
後はいつも通りemergeを使うだけです  
このlaymanだけをアップデートしたい場合は  
  
    # layman --sync silenvx
これで可能です
>>>>>>> 744e65b686f68eea63781a7b7dba829765ee37c0
=======
>>>>>>> e90279b54f5c556b41fcb08c56a7c4f9f22a6226
