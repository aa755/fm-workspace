cat emacs/.emacs >> ~/.emacs
cd emacs/PG
make clean
make
cd -
echo "(load \"$(pwd)/emacs/PG/generic/proof-site\")" >> ~/.emacs
echo "(add-to-list 'load-path \"$(pwd)/emacs/company-coq/\")" >> ~/.emacs
echo "(load \"$(pwd)/emacs/company-coq/company-coq\")" >> ~/.emacs
echo "(load \"$(pwd)/emacs/cat.el\")" >> ~/.emacs
echo "(load \"$(pwd)/dev/fmdev.el\")" >> ~/.emacs
