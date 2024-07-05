# This script is an example of how to compile and test this set of codes. 
# If no changes are required for your computer, this should handle all compilation and testing. 

cd ../FORTRAN

echo 'Starting making MINEOS_synthetics.'

echo 'Make libgfortran'

cd libgfortran 
rm ./*.a
./makelibs.sh

echo 'Done making libgfortran' 

cd .. 

echo 'Make Mineos' 
./makeall_linux.sh # Change this depending on which computer you are on. All Mac probably needs the M2 version, even if have intel chip. 

echo 'Starting test for Mineos' 
echo 'You may need to change the version of matlab that is loaded for the test. '
cd ../run_MINEOS
module load MatLab/R2021b # Or whichever version you have here. 
matlab -nodisplay -nodesktop -nosplash -r "MAIN_DRIVER"