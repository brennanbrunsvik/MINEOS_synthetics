FBIN = /Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin
FC = gfortran
FFLAGS=-ffixed-line-length-none -O1
#-L/usr/local/include 
#FFLAGS2=-march=x86_64

all:  $(FBIN)/frechet_Q 

.f.o: 
	$(FC) $(FFLAGS) $(FFLAGS2) -c $*.f

#----------------------------------

$(FBIN)/frechet_Q: frechet_Q.f
	$(FC) $(FFLAGS) -o $(FBIN)/frechet_Q frechet_Q.f
	
clean: 
	rm -rf *.o $(FBIN)/frechet_Q