include $(top_srcdir)/src/plugins/Makefile.plugins

plugindir = $(PLUGINDIR)/playlist-sidebar
plugin_LTLIBRARIES = libplaylist-sidebar.la

plugin_in_files = playlist-sidebar.plugin.in

# here we are explicitly specifying gtk+-3.0 to use the vapi
# because vala still cannot parse the gir
AM_VALAFLAGS = \
	--girdir=$(top_srcdir)/src	\
	--pkg Totem-1.0 --pkg libpeas-1.0 --pkg gtk+-3.0

libplaylist_sidebar_la_SOURCES = totem-playlist-sidebar-plugin.vala
libplaylist_sidebar_la_LDFLAGS = $(plugin_ldflags)
libplaylist_sidebar_la_CFLAGS = $(plugin_cflags) $(vala_plugin_cflags)
libplaylist_sidebar_la_LIBADD = $(plugin_libadd)

GITIGNOREFILES = \
	$(libplaylist_sidebar_la_SOURCES:.vala=.c) \
	libplaylist_sidebar_la_vala.stamp \
	$(NULL)

-include $(top_srcdir)/git.mk
