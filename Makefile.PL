#!/usr/local/bin/perl

use inc::Module::Install;

name        ('Filter-Macro');
author      ('Autrijus Tang <autrijus@autrijus.org>');
abstract    ('Make macro modules that are expanded inline');
license	    ('perl');
version_from('lib/Filter/Macro.pm');
requires    ('Filter::Simple');
WriteAll    ( sign => 1 );
