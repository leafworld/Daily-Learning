#######################################################
# Buflab.pm - CS:APP Buffer Lab Configuration File
#
# Copyright (c) 2003-2011, R. Bryant and D. O'Hallaron.
#######################################################
package Buflab;

use Time::Local;

######
# Section 1: Required Configuration Variables (INSTRUCTOR)
#
# This section defines lab-specific configuration variables that
# instructors need to set each time they offer the course.  
#
# NOTE: If you are giving your students quiet buffer bombs, then you
# can safely ignore everything in this section.

# What is the name of the host that the buffer lab servers and daemons
# are running on? Note that you don't need root access to run the
# buflab.  Any Linux desktop will do.

$SERVER_NAME = "cs.nju.edu.cn";

# How frequently (secs) is the realtime scoreboard updated?

$UPDATE_PERIOD = 30;

# What ports do the servers listen on? Note: You should never need to
# change any of these. The only exception would be the unlikely
# event that there is a port conflict on your machine. Because we're 
# not running as root, this value must be greater than 1024.
#
# NOTE: these should be different from the ports used by the Bomb Lab.

$REQUESTD_PORT = 18213;  # Request server's port 
$RESULTD_PORT = 18214;   # Result server's port 

#####
# Section 2: Optional Configuration Variables (LAB DEVELOPER)
#
# This section defines any other configuration variables that the lab
# developer wants to use. Instructors should not need to modify these.
#

######
# Part 3. Internal configuration constants (LAB DEVELOPER)
#
# This section contains internal constants that instructors should not
# have to modify
#

# What are the filenames of the scripts
$REQUESTD = "buflab-requestd.pl"; # Request server program
$RESULTD = "buflab-resultd.pl";   # Result server program
$REPORTD = "buflab-reportd.pl";   # Report daemon program
$UPDATE = "buflab-update.pl";     # Script that updates the web page
$MAKEBOMB = "makebomb.pl";        # Script that constructs a bomb

# What are the names of the logfiles 
$LOGFILE = "./log.txt";           # Logfile for autoresults from clients
$STATUSLOG = "./log-status.txt";  # Logfile for server error/status msgs

# What are the names of some key directories
$BOMBSRC = "./src";    # Directory containing bomb source files

# Handout directory
$HANDOUTDIR = "buflab-handout";

# Handin directory
$HANDINDIR = "./handin";

# Class scoreboard web page and score file for update script
$SCOREFILE = "./scores.txt";
$SCOREBOARDPAGE = "./buflab-scoreboard.html";

# If true, redirect output to logfile instead of stdout.
$QUIET = 1;                       

# Shades of grey or color that are used in tables
$DARK_GREY = '#b8d8ff';
$LIGHT_GREY = '#dfefff';

#####
# Widths of various table and form fields
#
$WIDTH_USERID = 100;
$WIDTH_EMAIL = 225;
$WIDTH_INTEGER = 50;
$WIDTH_SHORTDATE = 120;
$WIDTH_TEXTTABLE = 600;
$CELLPADDING = 1;
$CELLSPACING = 1;

# Some miscellaneous constants
$MAXHDRLEN = 16384;  # Max bytes in an HTTP request header
$MAX_TEXTBOX = 32;   # Max bytes in a form text box

#####
# Part 4. Helper functions used by all of the server programs
#
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
             log_msg
             log_die
	     date2time
	     short_date
	     );

#
# log_msg - Append a message to the status log
#
sub log_msg {
    my $date = scalar localtime();

    if ($QUIET) {
	if (open(STATUSLOG, ">>$STATUSLOG")) {
	    print STATUSLOG "$date:$0:@_\n";
	    close(STATUSLOG);
	}
    }
    else {
	print("@_\n");
    }
}

#
# log_die - Append a message to the status log and then die
#
sub log_die {
    log_msg(@_);
    exit(1);
}

#
# date2time - Convert a date string to seconds since the epoch
#
# We need this function because it is not provided by any of the standard
# Perl modules, and we made a firm design decision not to rely on any 
# non-standard modules from places like CPAN.
#
# Examples of valid date strings:
#
# Aug 4 11:01:05 2003 
# August 4 11:01:05 2003 
# aug 4 11:01:05 2003 
# august 4 11:01:05 2003 
#
# Returns -1 on error, number of seconds if OK
#
sub date2time   {
    my $orig_date = shift;
    my $date;
    my $mon;
    my $mon_str;
    my $mday;
    my $hours;
    my $min;
    my $sec;
    my $time_str;
    my $year_str;
    my $year;
    my $rest;
    my $str;
    my $day_str;

    my %days = (sun => 0,
		mon => 1,
		tue => 2,
		wed => 3,
		thu => 4,
		fri => 5,
		sat => 6);

    my %months = (jan => 0, 
		  feb => 1, 
		  mar => 2, 
		  apr => 3,
		  may => 4, 
		  jun => 5, 
		  jul => 6, 
		  aug => 7,
		  sep => 8, 
		  oct => 9,
		  nov => 10,
		  dec => 11);

    # Convert everything in the date string to lowercase and 
    # compress white spaces
    $date = lc($orig_date);
    $date =~ s/\s+/ /g;

    # Is the first field a day of the week or a month?
    ($str, $rest) = split(/ /, $date, 2);
    ($str) = $str =~ /^(...)/; # Get first three letters

    if (exists($days{$str})) {
	($day_str, $mon_str, $mday, $time_str, $year_str)  = split(/ /, $date);
    }
    else {
	($mon_str, $mday, $time_str, $year_str)= split(/ /, $date);
    }

    # Extract month number (use first three letters of name as hash index)
    ($mon_str) = $mon_str =~ /^(...)/;
    if (!exists($months{$mon_str})) {
	log_msg(3, "Error: Invalid month field ($mon_str) in date string $orig_date");
	return -1;
    }
    $mon = $months{$mon_str};

    # Extract day of the month
    if ($mday < 0 or $mday > 31) {
	log_msg(3, "Error: Invalid day of month field in date string $orig_date");
	return -1;
    }

    # Extract time fields 
    ($hours, $min, $sec) = split(/:/, $time_str);
    if ($hours < 0 or $hours > 23) {
	log_msg(3, "Error: Invalid hours field in date string $orig_date");
	return -1;
    } 
    if ($min < 0 or $min > 59) {
	log_msg(3, "Error: Invalid minutes field in date string $orig_date");
	return -1;
    }
    if ($sec < 0 or $sec > 59) {
	log_msg(3, "Error: Invalid seconds field in date string $orig_date");
	return -1;
    }

    # Extract year field
    $year = $year_str - 1900;
    if ($year < 0) {
	log_msg(0, "Error: Invalid year field in date string $orig_date");
	return -1;
    }

    return timelocal($sec, $min, $hours, $mday, $mon, $year);
}

#
# short_date - returns an abbreviated string version of an epoch time
#
sub short_date {
    my $time = shift;

    my $day;
    my $month;
    my $dom;
    my $timestr;
    my $year;
    my $hour;
    my $min;
    my $sec;
    my $date = localtime($time);

    ($day, $month, $dom, $timestr, $year) = 
	split(" ", $date, 5);
    ($hour, $min, $sec) = split(/:/, $timestr);
    return "$day $month $dom $hour:$min";
}

#
# Always end a module with a 1 so that it returns TRUE
#
1;

