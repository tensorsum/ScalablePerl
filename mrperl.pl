#!/usr/bin/perl -I/u/PP

# Scalable Perl datamining.
# It took some time to get here. 
# Paul Tchistopolskii
# March 29. 2015.

# July 13. 2015. 
# I am forgetting important things, let's make them obvious

# Background:

# "Perl is dead end" 
# https://speakerdeck.com/stevan_little/perl-is-not-dead-it-is-a-dead-end
# Slide 90 yells about (lack of) normal signatures in the language.

# In fact, I've implemented those in 2003 and announced in p5p:
# http://www.nntp.perl.org/group/perl.perl5.porters/2003/07/msg78432.html

use PerlP;
use DH;
use Data::Dumper;
use QLCS;

#my @lines = `cat slide.stat | tail`;
my @lines = `cat slide.stat`;

my @pats = ();
my %vokab = ();
my %p2n = ();

foreach my $l (@lines){
    chop $l;
    my ($dt, $pat) = split( /\t/, $l);
    push @pats, $pat;
}

#print Dumper(\@pats);
#my $p = $pats[0];

foreach my $p (@pats){
# { Create Nwrks (split @ on list) and call and wait }
    Iterate( $p );
}

# { Create Nwrks (split @ on list) and call and wait }
Count();

foreach my $p (keys %p2n){
    my $n = $p2n{$p};
    my $ln = length $p;
    print "$n\t$ln\t$p\n";
}

#print Dumper(\%vokab);

# { MR Count in: @pats, %vokab out: %p2n }

:sub Count() {
    foreach my $p (@pats){ 
        foreach my $v (keys %vokab){
            #print "$p\n";
            if ( index($p, $v) >=0 ){
                $p2n{$v}++;
            }
        }
    }
:}

# { MR Iterate in: @pats out: %vokab }

my %Seen = ();

:sub SeenK($p, $ap){
    my $ak = ( $p gt $ap ) ? "$p#$ap" : "$ap#$p";
    my $ret = ( $Seen{$ak} ) ? 1 : 0;
    $Seen{$ak}=1;
    return $ret;
:}

:sub Iterate($ap){
    foreach my $p (@pats){
        next if ($ap eq $p);
        next if SeenK($p, $ap);
        my $lcs = QLCS::lcs( $ap, $p );
        $vokab{$lcs}=1;
    }
:}

