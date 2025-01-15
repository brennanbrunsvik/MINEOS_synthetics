# MINEOS_synthetics
Calculate mode-based dispersion for layered models using MINEOS:
- phase & group velocity dispersion (Rayleigh and Love)
- sensitivity kernels (Vsv, Vsh, Vpv, Vph, eta, rho; A, C, F, L, N)
- eigenfunctions (toroidal and spheroidal)

Mode tables are used as input to idagrn6, which produces synthetic seismograms for the given layered model. This package also includes branch stripping which produces seismograms for individual modes as well as the excitation terms for each mode.

## Contents
- ./FORTRAN : contains all Fortran binaries required to build MINEOS and idagrn6
- ./run_MINEOS : contains the MATLAB wrappers for running MINEOS to build the mode tables and idagrn6 to calculate synthetic seismograms

## Getting Started

!!!
Need to add the bin to your .bash_profile (or your shells path). I added this to my .bash_profile: 
export PATH=~/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin:$PATH

Must have installed
- gfortran (other Fortran compilers might work but have not been tested)
- MATLAB

### For compiling fortran binaries, see [./FORTRAN/README](https://github.com/jbrussell/MINEOS_synthetics/blob/master/FORTRAN/README)

# Brennan's notes: ~2024 
- The attenuation reference frequency was hard coded into this version of Mineos. I changed it to 1 Hz (or 1000 mHz). 