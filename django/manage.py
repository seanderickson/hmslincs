#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("LC_ALL", "en_US.UTF-8")
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "hmslincs_server.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
