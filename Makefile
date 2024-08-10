#	xcurcommon
#	SPDX-License-Identifier: MIT
#	Copyright (c) 2024 eweOS developers

CC		?= cc
CCLD		?= cc
INSTALL		?= install

ifneq ($(DEBUG), 1)
DBGFLAGS	:= -g
else
DBGFLAGS	:=
endif

CFLAGS		?=
CCLDFLAGS	?=

SRCS		:= file.c library.c
OBJS		:= $(patsubst %.c, %.o, $(SRCS))

PREFIX		?= /usr
INCDIR		?= $(PREFIX)/include
LIBDIR		?= $(PREFIX)/lib

.PHONY: all clean

all: libxcurcommon.so

libxcurcommon.so: $(OBJS)
	$(CCLD) -o $@ $< -shared $(CCLDFLAGS) $(DBGFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) -fPIC $(DBGFLAGS)

clean:
	rm $(OBJS) libxcurcommon.so

install: xcurcommon.h libxcurcommon.so
	$(INSTALL) -Dm644 xcurcommon.h $(DESTDIR)/$(INCDIR)/xcurcommon.h
	$(INSTALL) -Dm755 libxcurcommon.so	\
		$(DESTDIR)/$(LIBDIR)/libxcurcommon.so

install-compatible: xcurcommon.h libxcurcommon.so
	mkdir -p $(DESTDIR)/$(INCDIR)/X11/Xcursor
	ln -s ../../xcurcommon.h $(DESTDIR)/$(INCDIR)/X11/Xcursor/Xcursor.h
	ln -s libxcurcommon.so $(DESTDIR)/$(INCDIR)/libXcursor.so

