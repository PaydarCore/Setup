#!/usr/bin/env python3
import gi
gi.require_version('Wnck', '3.0')
from gi.repository import Wnck
import sys

subjects = ["gnome-terminal-server", "Gnome-terminal", "Code", "code", "gedit", "Gedit", "bcompare", "Bcompare", "gnome-system-monitor", "Gnome-system-monitor", "google-chrome", "Google-chrome", "anydesk", "Anydesk"]

wnck_scr = Wnck.Screen.get_default()
wnck_scr.force_update()
wlist = wnck_scr.get_windows()
for w in wlist:
    if all([
        w.get_class_group_name() in subjects,
        w.get_xid() == (int(sys.argv[1]))
    ]):
        w.maximize()
