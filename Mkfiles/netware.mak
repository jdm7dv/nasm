# -*- makefile -*- GNU Makefile for NetWare target

PROOT=.
OBJDIR=release

-include $(OBJDIR)/version.mak

TARGETS=nasm.nlm ndisasm.nlm

PERL=perl

CROSSPREFIX=i586-netware-

CC=$(CROSSPREFIX)gcc
LD=$(CC)

BINSUFFIX=.nlm

VERSION=$(NASM_MAJOR_VER).$(NASM_MINOR_VER).$(NASM_SUBMINOR_VER)

CFLAGS=-g -O2 -Wall -std=c99 -pedantic -D__NETWARE__ -D_POSIX_SOURCE -DHAVE_CONFIG_H -I.
LDFLAGS=-Wl,--nlm-description="NASM $(NASM_VER) - the Netwide Assembler (gcc build)"
LDFLAGS+=-Wl,--nlm-copyright="NASM is licensed under LGPL."
LDFLAGS+=-Wl,--nlm-version=$(VERSION)
LDFLAGS+=-Wl,--nlm-kernelspace
LDFLAGS+=-Wl,--nlm-posixflag
LDFLAGS+=-s

O = o

#-- Begin File Lists --#
# Edit in Makefile.in, not here!
NASM =	nasm.o \
	float.o \
	directiv.o \
	assemble.o labels.o parser.o \
	preproc.o quote.o pptok.o \
	listing.o eval.o exprlib.o \
	stdscan.o \
	strfunc.o tokhash.o \
	segalloc.o \
	preproc-nop.o \
	rdstrnum.o \
	\
	macros.o \
	\
	outform.o outlib.o legacy.o \
	nulldbg.o nullout.o \
	outbin.o outaout.o outcoff.o \
	outelf.o \
	outobj.o outas86.o outrdf2.o \
	outdbg.o outieee.o outmacho.o \
	codeview.o

NDISASM = ndisasm.o disasm.o sync.o

LIBOBJ = snprintf.o vsnprintf.o strlcpy.o \
	strnlen.o \
	ver.o \
	crc64.o malloc.o \
	error.o md5c.o string.o \
	file.o ilog2.o \
	realpath.o filename.o srcfile.o \
	zerobuf.o readnum.o bsi.o \
	rbtree.o hashtbl.o \
	raa.o saa.o \
	common.o \
	insnsa.o insnsb.o insnsd.o insnsn.o \
	regs.o regvals.o regflags.o regdis.o \
	disp8.o iflag.o
#-- End File Lists --#

NASM_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NASM))) $(EOLIST)
NDIS_OBJ = $(addprefix $(OBJDIR)/,$(notdir $(NDISASM))) $(EOLIST)

VPATH  = *.c $(PROOT) $(PROOT)/output


all: $(OBJDIR) config.h $(TARGETS)

$(OBJDIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

nasm$(BINSUFFIX): $(NASM_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

ndisasm$(BINSUFFIX): $(NDIS_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(OBJDIR):
	@mkdir $@

config.h: $(PROOT)/Mkfiles/netware.mak
	@echo Creating $@
	@echo $(DL)/* $@ for NetWare target.$(DL) > $@
	@echo $(DL)** Do not edit this file - it is created by make!$(DL) >> $@
	@echo $(DL)** All your changes will be lost!!$(DL) >> $@
	@echo $(DL)*/$(DL) >> $@
	@echo $(DL)#ifndef __NETWARE__$(DL) >> $@
	@echo $(DL)#error This $(notdir $@) is created for NetWare platform!$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define PACKAGE_VERSION "$(NASM_VER)"$(DL) >> $@
	@echo $(DL)#define OS "i586-pc-libc-NetWare"$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_DECL_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_INTTYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_LIMITS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_MEMORY_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SNPRINTF 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDBOOL_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDINT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STDLIB_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRCSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRINGS_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRING_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNCASECMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRNICMP 1$(DL) >> $@
	@echo $(DL)#define HAVE_STRSPN 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_STAT_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_SYS_TYPES_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_UNISTD_H 1$(DL) >> $@
	@echo $(DL)#define HAVE_VSNPRINTF 1$(DL) >> $@
	@echo $(DL)#define STDC_HEADERS 1$(DL) >> $@
	@echo $(DL)#ifndef _GNU_SOURCE$(DL) >> $@
	@echo $(DL)#define _GNU_SOURCE 1$(DL) >> $@
	@echo $(DL)#endif$(DL) >> $@
	@echo $(DL)#define ldiv __CW_ldiv$(DL) >> $@

clean:
	-$(RM) -r $(OBJDIR)
	-$(RM) config.h

distclean: clean
	-$(RM) $(TARGETS)

$(OBJDIR)/version.mak: $(PROOT)/version $(PROOT)/version.pl $(OBJDIR)
	@$(PERL) $(PROOT)/version.pl make < $< > $@

#-- Magic hints to mkdep.pl --#
# @object-ending: ".o"
# @path-separator: ""
# @continuation: "\"
#-- Everything below is generated by mkdep.pl - do not edit --#
assemble.o: assemble.c assemble.h directiv.h listing.h pptok.h preproc.h \
 tokens.h config.h compiler.h disp8.h iflag.h insns.h nasm.h nasmint.h \
 nasmlib.h opflags.h tables.h iflaggen.h insnsi.h regs.h
directiv.o: directiv.c directiv.h pptok.h preproc.h config.h compiler.h \
 hashtbl.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
eval.o: eval.c directiv.h eval.h float.h pptok.h preproc.h config.h \
 compiler.h labels.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h \
 regs.h
exprlib.o: exprlib.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
float.o: float.c directiv.h float.h pptok.h preproc.h config.h compiler.h \
 nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
labels.o: labels.c directiv.h pptok.h preproc.h config.h compiler.h \
 hashtbl.h labels.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h \
 regs.h
listing.o: listing.c directiv.h listing.h pptok.h preproc.h config.h \
 compiler.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
nasm.o: nasm.c assemble.h directiv.h eval.h float.h listing.h parser.h \
 pptok.h preproc.h stdscan.h tokens.h config.h compiler.h iflag.h insns.h \
 labels.h nasm.h nasmint.h nasmlib.h opflags.h raa.h saa.h tables.h ver.h \
 outform.h iflaggen.h insnsi.h regs.h
parser.o: parser.c directiv.h eval.h float.h parser.h pptok.h preproc.h \
 stdscan.h tokens.h config.h compiler.h iflag.h insns.h nasm.h nasmint.h \
 nasmlib.h opflags.h tables.h iflaggen.h insnsi.h regs.h
pptok.o: pptok.c pptok.h preproc.h config.h compiler.h hashtbl.h nasmint.h \
 nasmlib.h
preproc-nop.o: preproc-nop.c directiv.h listing.h pptok.h preproc.h config.h \
 compiler.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
preproc.o: preproc.c directiv.h eval.h listing.h pptok.h preproc.h quote.h \
 stdscan.h tokens.h config.h compiler.h hashtbl.h nasm.h nasmint.h nasmlib.h \
 opflags.h tables.h insnsi.h regs.h
quote.o: quote.c quote.h config.h compiler.h nasmint.h nasmlib.h
rdstrnum.o: rdstrnum.c directiv.h pptok.h preproc.h config.h compiler.h \
 nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
segalloc.o: segalloc.c directiv.h pptok.h preproc.h tokens.h config.h \
 compiler.h iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h tables.h \
 iflaggen.h insnsi.h regs.h
stdscan.o: stdscan.c directiv.h pptok.h preproc.h quote.h stdscan.h tokens.h \
 config.h compiler.h iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h \
 tables.h iflaggen.h insnsi.h regs.h
strfunc.o: strfunc.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
tokhash.o: tokhash.c directiv.h pptok.h preproc.h stdscan.h tokens.h \
 config.h compiler.h hashtbl.h iflag.h insns.h nasm.h nasmint.h nasmlib.h \
 opflags.h tables.h iflaggen.h insnsi.h regs.h
common.o: common.c directiv.h pptok.h preproc.h tokens.h config.h compiler.h \
 iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h tables.h iflaggen.h \
 insnsi.h regs.h
disasm.o: disasm.c directiv.h pptok.h preproc.h tokens.h config.h disasm.h \
 sync.h compiler.h disp8.h iflag.h insns.h nasm.h nasmint.h nasmlib.h \
 opflags.h tables.h iflaggen.h insnsi.h regdis.h regs.h
ndisasm.o: ndisasm.c directiv.h pptok.h preproc.h tokens.h config.h disasm.h \
 sync.h compiler.h iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h \
 tables.h ver.h iflaggen.h insnsi.h regs.h
sync.o: sync.c config.h sync.h compiler.h nasmint.h nasmlib.h
macros.o: macros.c directiv.h pptok.h preproc.h config.h compiler.h \
 hashtbl.h nasm.h nasmint.h nasmlib.h opflags.h tables.h outform.h insnsi.h \
 regs.h
bsi.o: bsi.c config.h compiler.h nasmint.h nasmlib.h
crc64.o: crc64.c config.h compiler.h hashtbl.h nasmint.h nasmlib.h
error.o: error.c config.h compiler.h nasmint.h nasmlib.h
file.o: file.c config.h compiler.h nasmint.h nasmlib.h
filename.o: filename.c config.h compiler.h nasmint.h nasmlib.h
hashtbl.o: hashtbl.c directiv.h pptok.h preproc.h config.h compiler.h \
 hashtbl.h nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
ilog2.o: ilog2.c config.h compiler.h nasmint.h nasmlib.h
malloc.o: malloc.c config.h compiler.h nasmint.h nasmlib.h
md5c.o: md5c.c config.h compiler.h md5.h nasmint.h
raa.o: raa.c config.h compiler.h nasmint.h nasmlib.h raa.h
rbtree.o: rbtree.c config.h compiler.h nasmint.h rbtree.h
readnum.o: readnum.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
realpath.o: realpath.c config.h compiler.h nasmint.h nasmlib.h
saa.o: saa.c config.h compiler.h nasmint.h nasmlib.h saa.h
srcfile.o: srcfile.c config.h compiler.h hashtbl.h nasmint.h nasmlib.h
string.o: string.c config.h compiler.h nasmint.h nasmlib.h
ver.o: ver.c ver.h version.h
zerobuf.o: zerobuf.c config.h compiler.h nasmint.h nasmlib.h
codeview.o: codeview.c directiv.h pptok.h preproc.h config.h compiler.h \
 hashtbl.h md5.h nasm.h nasmint.h nasmlib.h opflags.h saa.h tables.h \
 outlib.h pecoff.h version.h insnsi.h regs.h
legacy.o: legacy.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
nulldbg.o: nulldbg.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h outlib.h insnsi.h regs.h
nullout.o: nullout.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h outlib.h insnsi.h regs.h
outaout.o: outaout.c directiv.h eval.h pptok.h preproc.h stdscan.h config.h \
 compiler.h nasm.h nasmint.h nasmlib.h opflags.h raa.h saa.h tables.h \
 outform.h outlib.h insnsi.h regs.h
outas86.o: outas86.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h raa.h saa.h tables.h outform.h outlib.h \
 insnsi.h regs.h
outbin.o: outbin.c directiv.h eval.h pptok.h preproc.h stdscan.h config.h \
 compiler.h labels.h nasm.h nasmint.h nasmlib.h opflags.h saa.h tables.h \
 outform.h outlib.h insnsi.h regs.h
outcoff.o: outcoff.c directiv.h eval.h pptok.h preproc.h config.h compiler.h \
 nasm.h nasmint.h nasmlib.h opflags.h raa.h saa.h tables.h outform.h \
 outlib.h pecoff.h insnsi.h regs.h
outdbg.o: outdbg.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h outform.h outlib.h insnsi.h regs.h
outelf.o: outelf.c directiv.h eval.h pptok.h preproc.h stdscan.h config.h \
 compiler.h nasm.h nasmint.h nasmlib.h opflags.h raa.h rbtree.h saa.h \
 tables.h ver.h dwarf.h elf.h outelf.h outform.h outlib.h stabs.h insnsi.h \
 regs.h
outform.o: outform.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h outform.h insnsi.h regs.h
outieee.o: outieee.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h ver.h outform.h outlib.h insnsi.h \
 regs.h
outlib.o: outlib.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h tables.h outlib.h insnsi.h regs.h
outmacho.o: outmacho.c directiv.h pptok.h preproc.h config.h compiler.h \
 nasm.h nasmint.h nasmlib.h opflags.h raa.h rbtree.h saa.h tables.h \
 outform.h outlib.h insnsi.h regs.h
outobj.o: outobj.c directiv.h eval.h pptok.h preproc.h stdscan.h config.h \
 compiler.h nasm.h nasmint.h nasmlib.h opflags.h tables.h ver.h outform.h \
 outlib.h insnsi.h regs.h
outrdf2.o: outrdf2.c directiv.h pptok.h preproc.h config.h compiler.h nasm.h \
 nasmint.h nasmlib.h opflags.h rdoff.h saa.h tables.h outform.h outlib.h \
 insnsi.h regs.h
snprintf.o: snprintf.c config.h compiler.h nasmint.h nasmlib.h
strlcpy.o: strlcpy.c config.h compiler.h nasmint.h
strnlen.o: strnlen.c config.h compiler.h nasmint.h
vsnprintf.o: vsnprintf.c config.h compiler.h nasmint.h nasmlib.h
disp8.o: disp8.c directiv.h pptok.h preproc.h config.h compiler.h disp8.h \
 nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
iflag.o: iflag.c config.h compiler.h iflag.h nasmint.h iflaggen.h
insnsa.o: insnsa.c directiv.h pptok.h preproc.h tokens.h config.h compiler.h \
 iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h tables.h iflaggen.h \
 insnsi.h regs.h
insnsb.o: insnsb.c directiv.h pptok.h preproc.h tokens.h config.h compiler.h \
 iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h tables.h iflaggen.h \
 insnsi.h regs.h
insnsd.o: insnsd.c directiv.h pptok.h preproc.h tokens.h config.h compiler.h \
 iflag.h insns.h nasm.h nasmint.h nasmlib.h opflags.h tables.h iflaggen.h \
 insnsi.h regs.h
insnsn.o: insnsn.c config.h compiler.h nasmint.h tables.h insnsi.h
regdis.o: regdis.c regdis.h regs.h
regflags.o: regflags.c directiv.h pptok.h preproc.h config.h compiler.h \
 nasm.h nasmint.h nasmlib.h opflags.h tables.h insnsi.h regs.h
regs.o: regs.c config.h compiler.h nasmint.h tables.h insnsi.h
regvals.o: regvals.c config.h compiler.h nasmint.h tables.h insnsi.h
