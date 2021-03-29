g++ evgen_anyssa.cxx -I$(root-config --incdir) --std=c++17 -I GenExLight/TDecayTFoam $(root-config --libs) -lFoam -lEG GenExLight/TDecayTFoam/TDecay.o -o evgen_anyssa.exe
