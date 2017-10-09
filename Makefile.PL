#!/usr/bin/perl -w
# Makefile.PL
# $Id: $
# $Date: $
#
use strict;

my $debug = 0;

my $baseDir = `pwd`;
chomp $baseDir;

system("git log > changelog");

# software version
-f "VERSION" or die "No version file";
my $swVersion = `cat VERSION`;
chomp $swVersion;

# software release
-f "RELEASE" or die "No release file";
my $swRelease = `cat RELEASE`;
chomp $swRelease;

sub changeFiles {
	# Edit Makefile
	my $file = 'Makefile';
	open (INPUT,"<$file") or die;
	my @input_array=<INPUT>;
	close(INPUT);
	my $input_scalar=join("",@input_array);

	if ($input_scalar =~ /^Version=/m) {
		my $origStr = 'Version=.*$';
		my $replStr = "Version= ${swVersion}";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	if ($input_scalar =~ /^Package=/m) {
		my $origStr = '^Package=.*$';
		my $replStr = "Package= diskscan-${swVersion}-${swRelease}";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	open (OUTPUT, "> $file") or die;
	print OUTPUT "$input_scalar";
	close OUTPUT;

	# Edit spec
	$file = 'spec';
	open (INPUT,"<$file") or die;
	@input_array=<INPUT>;
	close(INPUT);
	$input_scalar=join("",@input_array);

	if ($input_scalar =~ /^%define Version/m) {
		my $origStr = '%define Version.*$';
		my $replStr = "%define Version ${swVersion}";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	if ($input_scalar =~ /^Release:/m) {
		my $origStr = '^Release:.*$';
		my $replStr = "Release: ${swRelease}%{?dist}";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	if ($input_scalar =~ /^Source:/m) {
		my $origStr = '^Source:.*$';
		my $replStr = "Source: diskscan-${swVersion}-${swRelease}.tgz";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	if ($input_scalar =~ /^BuildArch:/m) {
		my $origStr = '^BuildArch:.*$';
		my $replStr = "BuildArch: noarch";
		$input_scalar =~ s/$origStr/$replStr/m;
	}

	open (OUTPUT, "> $file") or die;
	print OUTPUT "$input_scalar";
	close OUTPUT;
}

# Build rpms
sub buildRPMS {
	chdir "$baseDir";
	changeFiles();
	system("make rpmbuild");
}

buildRPMS();
`rm changelog`;

# PGP sign the rpms
print "Sign RPM packages\n";
system("rpm --addsign $ENV{HOME}/rpmbuild/RPMS/noarch/diskscan*.rpm");

exit 0;

