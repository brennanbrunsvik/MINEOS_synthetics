MYBIN = /Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin
FC = gfortran
FFLAGS= -O1
#$(MYFFLAGS)
# FFLAGS = -g -C
LFLAGS= -L$(MYLIB)


#-------------------------------------------------------------------------------
#f77 $(FFLAGS) $(LFLAGS) -o $(MYBIN)/get_eigfxn_grvelo_int get_eigfxn_grvelo_int.f
get_eigfxn_grvelo_int: get_eigfxn_grvelo_int.o 
	$(FC) $(FFLAGS) -o $(MYBIN)/get_eigfxn_grvelo_int get_eigfxn_grvelo_int.o
