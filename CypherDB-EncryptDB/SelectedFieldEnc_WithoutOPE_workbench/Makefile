
CC = gcc
OFLAGS = -O3 -Wall -g -D_FILE_OFFSET_BITS=64 -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION
MFLAGS = `./sysprobe -flags`
MLIBS  = `./sysprobe -libs` -lm
CLIBS  = -L/usr/local/ssl/lib -lcrypto
ENDIAN = `./sysprobe -s`
MAKE = make
AR = ar qcv
AROPT =
RANLIB = ranlib
RM = rm -f
RMDIR = rm -f
LN = ln -s
LNDIR = ln -s
DIFF = diff
OEXT = o
LEXT = a
EEXT =
CS = ;
X=/

#
# all the sources
#

CFLAGS = $(OFLAGS) 

SRCS =	crypto.c dbload.c print.c utils.c \
	lineitem.c orders.c part.c customer.c supplier.c partsupp.c nation.c region.c\
	lineitem_sqlite.c orders_sqlite.c part_sqlite.c customer_sqlite.c \
	supplier_sqlite.c partsupp_sqlite.c nation_sqlite.c region_sqlite.c \
	tpch_sqlite.c sqlite3dbGen.c sqlite3.c sqlite3modify.c

HDRS =	crypto.h dbload.h print.h utils.h record.h\
	lineitem.h orders.h part.h customer.h supplier.h partsupp.h nation.h region.h\
	lineitem_sqlite.h orders_sqlite.h part_sqlite.h customer_sqlite.h \
	supplier_sqlite.h partsupp_sqlite.h nation_sqlite.h region_sqlite.h \
	tpch_sqlite.h sqlite3modify.h sqlite3.h
#
# common objects
#
OBJS =	crypto.$(OEXT) dbload.$(OEXT) print.$(OEXT) utils.$(OEXT) 	\
	lineitem.$(OEXT) orders.$(OEXT) part.$(OEXT) customer.$(OEXT) supplier.$(OEXT) \
	partsupp.$(OEXT) nation.$(OEXT) region.$(OEXT)	\
	lineitem_sqlite.$(OEXT) orders_sqlite.$(OEXT) part_sqlite.$(OEXT) \
	customer_sqlite.$(OEXT) supplier_sqlite.$(OEXT) partsupp_sqlite.$(OEXT)	\
	nation_sqlite.$(OEXT) region_sqlite.$(OEXT) tpch_sqlite.$(OEXT) \
	sqlite3modify.$(OEXT) sqlite3.$(OEXT)\

#
# programs to build
#
PROGS = sqlite3dbGen$(EXT)

#
# all targets, NOTE: library ordvering is important...
#
all: $(PROGS)
	@echo "my work is done here..."

sqlite3dbGen$(EEXT):	sqlite3dbGen.$(OEXT) $(OBJS)
	$(CC) -o sqlite3dbGen$(EEXT) $(CFLAGS) sqlite3dbGen.$(OEXT) $(OBJS) $(CLIBS)

#dbEncryptCTR $(EEXT):	dbEncryptCTR.$(OEXT) $(OBJS)
#	$(CC) -o dbEncryptCTR $(EEXT) $(CFLAGS) dbEncryptCTR.$(OEXT) $(OBJS) $(CLIBS)

.c.$(OEXT):
	$(CC) $(CFLAGS) -c $*.c

clean:
	-$(RM) *.o *.obj *.exe core *~ MAKE.log Makefile.bak $(PROGS)

# DO NOT DELETE THIS LINE -- make depend depends on it.

crypto.$(OEXT): record.h crypto.h
lineitem.$(OEXT): lineitem.h dbload.h print.h crypto.h
orders.$(OEXT): orders.h dbload.h print.h crypto.h
part.$(OEXT): part.h dbload.h print.h crypto.h
customer.$(OEXT): customer.h dbload.h print.h crypto.h
supplier.$(OEXT): supplier.h dbload.h print.h crypto.h
partsupp.$(OEXT): partsupp.h dbload.h print.h crypto.h
nation.$(OEXT): nation.h dbload.h print.h crypto.h
region.$(OEXT): region.h dbload.h print.h crypto.h
#lineitem_main.$(OEXT): record.h utils.h lineitem.h crypto.h
lineitem_sqlite.$(OEXT): record.h utils.h lineitem.h crypto.h dbload.h print.h lineitem_sqlite.h sqlite3.h
orders_sqlite.$(OEXT): record.h utils.h orders.h crypto.h dbload.h print.h orders_sqlite.h sqlite3.h
part_sqlite.$(OEXT): record.h utils.h part.h crypto.h dbload.h print.h part_sqlite.h sqlite3.h
customer_sqlite.$(OEXT): record.h utils.h customer.h crypto.h dbload.h print.h customer_sqlite.h sqlite3.h
supplier_sqlite.$(OEXT): record.h utils.h supplier.h crypto.h dbload.h print.h customer_sqlite.h sqlite3.h
partsupp_sqlite.$(OEXT): record.h utils.h partsupp.h crypto.h dbload.h print.h partsupp_sqlite.h sqlite3.h
nation_sqlite.$(OEXT): record.h utils.h partsupp.h crypto.h dbload.h print.h nation_sqlite.h sqlite3.h
region_sqlite.$(OEXT): record.h utils.h partsupp.h crypto.h dbload.h print.h region_sqlite.h sqlite3.h
tpch_sqlite.$(OEXT): record.h utils.h orders.h lineitem.h crypto.h dbload.h print.h tpch_sqlite.h lineitem_sqlite.h orders_sqlite.h sqlite3.h
#dbEncryptCTR.$(OEXT): record.h crypto.h utils.h lineitem.h print.h dbload.h
dbload.$(OEXT): record.h dbload.h
print.$(OEXT): record.h print.h
utils.$(OEXT): record.h utils.h
#orders.$(OEXT): orders.h dbload.h print.h
#orders_main.$(OEXT): record.h utils.h orders.h crypto.h
sqlite3dbGen.$(OEXT): record.h crypto.h utils.h lineitem_sqlite.h orders_sqlite.h print.h dbload.h lineitem.h orders.h
sqlite3.$(OEXT): sqlite3.h
sqlite3modify.$(OEXT): sqlite3modify.h record.h
