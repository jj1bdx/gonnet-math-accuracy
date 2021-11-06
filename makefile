
CC = echo ARCH not set

ifeq ($(ARCH),darwin)
	CC= clang
	OPT= -O3 -ffast-math -ftree-vectorize -march=native
	TITLE = "Apple macOS, darwin"
endif

ifeq ($(ARCH),axp)
	CC= cc
	OPT= -O4
	TITLE = "DEC Alpha, OSF1"
endif

ifeq ($(ARCH),solaris)
	CC= cc
	OPT= -xO4
	TITLE = "Sun Sparc, Solaris"
endif

ifeq ($(ARCH),irix)
	CC= cc
	OPT= -O3
	TITLE = "SGI - Octane, Irix64"
endif

ifeq ($(ARCH),linux)
	CC=gcc
	OPT= -O9
	TITLE = "Intel Pentium or AMD PC, Linux"
endif

ifeq ($(ARCH),linux64)
	CC=gcc
	OPT= -O9 -DFORCE_FPU_DOUBLE
	TITLE = "Intel Pentium or AMD PC (FPU_DOUBLE set), Linux"
endif

ifeq ($(ARCH),armv7l)
	CC=gcc
	OPT= -O9
	TITLE = "ARM armv7l, Linux"
endif

results = $(ARCH)/acos.res \
        $(ARCH)/acosh.res \
        $(ARCH)/asin.res \
        $(ARCH)/asinh.res \
        $(ARCH)/atan.res \
        $(ARCH)/atanh.res \
        $(ARCH)/cos.res \
        $(ARCH)/cosh.res \
        $(ARCH)/erf.res \
        $(ARCH)/erfc.res \
        $(ARCH)/exp.res \
        $(ARCH)/Gamma.res \
        $(ARCH)/INV.res \
        $(ARCH)/j0.res \
        $(ARCH)/j1.res \
        $(ARCH)/lgamma.res \
        $(ARCH)/log.res \
        $(ARCH)/log10.res \
        $(ARCH)/Pix.res \
        $(ARCH)/pow2_x.res \
        $(ARCH)/powx_275.res \
        $(ARCH)/sin.res \
        $(ARCH)/sinh.res \
        $(ARCH)/sqrt.res \
        $(ARCH)/tan.res \
        $(ARCH)/tanh.res \
        $(ARCH)/y0.res \
        $(ARCH)/y1.res


.SECONDARY:
.SUFFIXES: .res .c .M .html

clean :
	rm -rf $(ARCH)
	mkdir $(ARCH)

C/%.c : %.M GenTest.M float.M
	cat GenTest.M $*.M | maple -q >C/$*.c

$(ARCH)/%.res : C/%.c C/header.h C/trailer.h
	$(CC) $(OPT) C/$*.c -lm
	./a.out >$(ARCH)/$*.res

$(ARCH)/summary.html : page1.html page2.html page3.html $(results)
	cp page1.html $(ARCH)/summary.html
	date "+%c on" >>$(ARCH)/summary.html
	hostname  >>$(ARCH)/summary.html
	echo "<p>Hardware, operating system and compiling command<pre>" >> $(ARCH)/summary.html
	echo $(TITLE), $(CC) $(OPT) "-lm</pre>" >>$(ARCH)/summary.html
	cat page2.html >>$(ARCH)/summary.html
	grep -h "<tr>" $(ARCH)/*.res >>$(ARCH)/summary.html
	cat page3.html >>$(ARCH)/summary.html

NastyValues.ps : NastyValues.tex
	latex NastyValues
	dvips -o NastyValues.ps NastyValues

all.tar.Z : makefile C/* *.M *.html background.jpg axp/* irix/* \
	solaris/* linux/* NastyValues.tex NastyValues.ps
	tar -cf all.tar makefile C *.M *.html background.jpg axp irix \
	  solaris linux linux64 NastyValues.tex NastyValues.ps
	compress -v all.tar
