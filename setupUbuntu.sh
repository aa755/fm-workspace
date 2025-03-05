#!/bin/bash
set -e
set -x
export DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y software-properties-common python3-launchpadlib # needed for the next line
apt-add-repository -y ppa:swi-prolog/stable

apt install --no-install-recommends -y git emacs opam swi-prolog pkg-config cmake build-essential gzip gpg libcairo2-dev libexpat1-dev libgmp-dev libgtk-3-dev libgtksourceview-3.0-dev zlib1g-dev rsync libstdc++-14-dev
wget -q https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
./llvm.sh 18 all
# ^ llvm.sh suggests adding LFLAGS/CPPFLAGS. consider adding ghem

opam init --disable-sandboxing --yes
echo "eval \$(opam env)" >> ~/.bashrc 
eval $(opam env) # without this, opam-installed binaries cannot be found
chown -R root:root . # needed when running in a debian docker image and this directory was copied to the docker container via docker cp
./setupEmacs.sh


echo "export PATH=/usr/lib/llvm-18/bin/:\$PATH" >> ~/.bashrc
echo "ulimit -Ss unlimited" >> ~/.bashrc
ulimit -Ss unlimited
source ~/.bashrc
set +e
./setup-fmdeps.sh -p # runs into an inconsequential opam error
set -e
eval $(opam env) # ./setup-fmdeps.sh changes the opam switch

make ast-prepare # generate dune rules for dune to convert demo*.cpp to demo*.v when it needs to
cd monad
# to enable the line below, all deps needed to compile monad execution client need to be installed. currently, we use cached ASTs
#./updateMonadCoqAsts.sh # eagerly convert execute_block.cpp and execute_transaction.cpp to exb.v and ext.v respectively. TODO: integrate with ast-prepare above
cd monadproofs
rm -rf asts
mv ../../asts ./
dune build tutorials/demoprf.vo tutorials/demo2prf.vo ../../BasicCoqTutorial/ proofs/exec_specs.vo ../../_build/default/fmdeps/coq/dev/shim/coqtop
export TERM=xterm-256color
echo "export TERM=xterm-256color" >> ~/.bashrc
source ~/.bashrc
