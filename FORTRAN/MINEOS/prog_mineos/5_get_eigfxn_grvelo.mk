MYBIN = /Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin
FC = gfortran
FFLAGS= -O1
#$(MYFFLAGS)
# FFLAGS = -g -C
LFLAGS= -L$(MYLIB)


#-------------------------------------------------------------------------------
#f77 $(FFLAGS) $(LFLAGS) -o $(MYBIN)/get_eigfxn_grvelo get_eigfxn_grvelo.f
get_eigfxn_grvelo: get_eigfxn_grvelo.o 
	$(FC) $(FFLAGS) -o $(MYBIN)/get_eigfxn_grvelo get_eigfxn_grvelo.o
