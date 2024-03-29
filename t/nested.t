#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Path::Class qw( file );

BEGIN{ use_ok('Config::Locale') }

my $config_dir = file( $0 )->dir->subdir('nested');

my $config = Config::Locale->new(
    directory => $config_dir,
    identity  => [qw( this that those )],
    algorithm => 'NESTED',
);

is_deeply(
    $config->combinations(),
    [
        ['all',  'all',  'all'],
        ['all',  'all',  'those'],
        ['all',  'that', 'all'],
        ['all',  'that', 'those'],
        ['this', 'all',  'all'],
        ['this', 'all',  'those'],
        ['this', 'that', 'all'],
        ['this', 'that', 'those'],
    ],
    'correct combinations',
);

my @test_cases = (
    [ [qw( foo foo foo )] => { this=>'that', what=>'yes', bar=>'no' } ],
    [ [qw( foo foo bar )] => { this=>'that', what=>'yes', bar=>'yes' } ],
);

foreach my $case (@test_cases) {
    my ($identity, $expected) = @$case;

    my $config = Config::Locale->new(
        directory       => $config_dir,
        identity        => $identity,
        algorithm       => 'NESTED',
    )->config();

    is_deeply(
        $config,
        $expected,
        'config for ' . join('.', @$identity) . ' looks right',
    );
}

done_testing;
