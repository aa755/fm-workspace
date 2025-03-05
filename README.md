Basic Coq tutorials from the logical foundations book are in BasicCoqTutorial. 
They cover the logic of Coq, but not C++ verfication.
It has 4 chapters, each in a .v file with c1 to c4 as prefix, indicating the order in which the files should be read. 
```
~/fv-workspace/BasicCoqTutorial$ls
LICENSE  c1Basics.v  c2Induction.v  c3Lists.v  c4Poly.v  dune  dune-project
```
These files should ideally be read in a live Coq editor as it illustrates how to run live Coq queries and explains the live proof goals.
Emacs is preconfigured with Coq support for .v files.
To open a file with live Coq assistance, use `emacs -nw`, e.g. `emacs -nw BasicCoqTutorial/c1Basics.v`
This runs emacs in console mode in the terminal, matching what was shown in the c++ verification tutorials at Category labs.
The top of that file has instructions on how to interact with Coq in emacs.
(It should be possible to install sshd in the container and then run emacs gui over ssh -Y by dropping `-nw`, but the console mode already has all the important features for editing coq files live)

Other files can be similarly opened. Files of interest are demo*.cpp and demo*prf.v:
```
~/fv-workspace/monad/monadproofs/tutorials$ls
atomic_specs.v	demo.cpp  demo2.cpp  demo2prf.v  demo3.cpp  demomisc.v	demoprf.v  dune-gen.sh	ext_flags.sh
```
demo.cpp and demo2.cpp are the C++ files use in the 1st and 2nd c++ verification tutorials, respectively.
demoprf.v and demo2prf.v have their proofs, respectively.

The specifications of execute_block, execute_transaction, BlockState etc. can be fould in exec_specs.v
```
~/fv-workspace/monad/monadproofs/proofs$ls
evmopsem.v  exec_specs.v  execproofs  libspecs.v  misc.v
```
