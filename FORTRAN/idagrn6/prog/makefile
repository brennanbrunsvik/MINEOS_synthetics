# FC= g77
FC= gfortran
FFLAGS= $(MYFFLAGS)
LFLAGS= $(MYLFLAGS)
MYBIN= ~/bin
# MYLIB= ~/Unix/libg77
# MYLIB= ~/Unix/lib
MYLIB= ~/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/libgfortran # /Users/russell/Lamont/MINEOS/MINEOS_PATNAT/prog_plotwk/libgfortran/
#
PROG= idagrn6_sac_excite
SUBS= spheroidal5.f toroidal5_excite.f spheroidal_exc5.f toroidal_exc5.f \
      curse4.f source_strains5.f cubic.f zfcns.f load_tables.f dwdd_h.f \
      readint_h.f load_crust20.f load_kern_c51.f avg_crust20.f avg_dbdb5.f \
      dwdd_c51.f dwdd_db.f

OBJS= $(PROG).o $(SUBS:.f=.o)

.f.o:
	$(FC) $(FFLAGS) -c $*.f

#----------------------------------------------------------------------------------

$(PROG): $(OBJS) 
	$(FC) $(FFLAGS) $(LFLAGS) -o $(MYBIN)/$@ $(OBJS) \
	$(MYLIB)/libcip.a \
	/opt/local/sac/lib/sacio.a \
	$(MYLIB)/libharm.a \
	$(MYLIB)/libutil.a

# check object files for dependency on .h files
$(OBJS): parameter5.h
	$(FC) $(FFLAGS) -c $*.f
