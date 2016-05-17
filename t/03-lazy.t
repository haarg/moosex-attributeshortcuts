use strict;
use warnings;

{
    package TestClass;

    use Moose;
    use namespace::autoclean;
    use MooseX::AttributeShortcuts;

    has foo => (is => 'lazy');
    has bar => (is => 'lazy', default => 'bip!');

    # if this one fails, we're just going to get a die() off it for a "cannot
    # have both a builder and a default!" violation.  So, the test here really
    # is "does it not die?"
    has baz => (is => 'lazy', default => 0);

    has buzz => (is => 'ro', lazy => 1);
    sub _build_buzz { 1 }
}

use Test::More;
use Test::Moose;

require 't/funcs.pm' unless eval { require funcs };

my %foo_accessors = (
    reader   => 'foo',
    init_arg => 'foo',
    lazy     => 1,
    builder  => '_build_foo',
    default  => undef,
);

my %bar_accessors = (
    reader   => 'bar',
    init_arg => 'bar',
    lazy     => 1,
    default  => 'bip!',
    builder  => undef,
);

my %buzz_accessors = (
    reader   => 'buzz',
    init_arg => 'buzz',
    lazy     => 1,
    default  => undef,
    builder  => '_build_buzz',
);

with_immutable {

    test_class_sanity_checks('TestClass');
    check_attribute('TestClass', foo => %foo_accessors);
    check_attribute('TestClass', bar => %bar_accessors);
    check_attribute('TestClass', buzz => %buzz_accessors);

} 'TestClass';

done_testing;

