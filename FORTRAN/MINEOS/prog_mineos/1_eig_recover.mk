MYBIN = /Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin
FC = gfortran
FFLAGS=-ffixed-line-length-none -O1
#
PROG= eig_recover
SUBS= kblnk.f
OBJS= $(PROG).o $(SUBS:.f=.o)

.f.o:
	$(FC) $(FFLAGS) -c $*.f

#----------------------------------------------------------------------------------

$(PROG): $(OBJS) 
	$(FC) $(FFLAGS) -o $(MYBIN)/$@ $(OBJS)

# check object files for dependency on .h files
$(OBJS): parameter.h
	$(FC) $(FFLAGS) -c $*.f
	
clean: 
	rm -rf *.o
