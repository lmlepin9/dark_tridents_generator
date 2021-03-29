# dark_tridents_generator
Dark tridents generator to be run on the grid

## Installation
### Step 1: Install BdNMC
The generator uses the BdNMC generator to create a beam of dark matter particles. 
You will need to install BdNMC in the same repository as this generator. 
You can find it here: https://github.com/pgdeniverville/BdNMC.git

### Step 2: Compile
Compile evgen using the command: 
``` 
source compile_evgen.sh
```



### Step 4: Update paths
Several paths are defined in `jobsub_dark_tridents.py`. Don't forget to change all paths to your own repositories. 

## Usage

### Basic usage
First, setup your working environment with:
```
source setup_dm_grid.sh
```

Then, submit jobs using the command:
```
python3 jobsub_darks_trident.py 
```

