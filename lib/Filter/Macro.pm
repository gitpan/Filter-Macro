package Filter::Macro;
$Filter::Macro::VERSION = '0.02';

use strict;
use Filter::Simple sub {
    $_ = quotemeta($_);
    s/\\\n/\n/g;
    $_ = sprintf(q(
        use Filter::Simple sub {
            $_ = join("\n",
                '#line '.(__LINE__+1).' '.__FILE__,
                "%s",
                '#line %s %s',
                $_,
            );
        };
        1;
    ), $_, (caller(2))[2]+1, (caller(2))[1]);
    tr/\n//d;
};

1;

=head1 NAME

Filter::Macro - Make macro modules that are expanded inline

=head1 VERSION

This document describes version 0.02 of Filter::Macro, released
July 21, 2004.

=head1 SYNOPSIS

In F<MyHandyModules.pm>:

    package MyHandyModules;
    use Filter::Macro;
    # lines below will be expanded into caller's code
    use strict;
    use warnings;
    use Switch;
    use IO::All;
    use Quantum::Superpositions;

In your program or module:

    use MyHandyModules; # lines above are expanded here

=head1 DESCRIPTION

If many of your programs begin with the same lines, it may make sense to
abstract them away into a module, and C<use> that module instead.

Sadly, it does not work that way, because by default, all lexical pragmas,
source filters and subroutine imports invoked in F<MyHandyModules.pm> takes
effect in that module, I<not> the calling programs.

One way to solve this problem is to use B<Filter::Include>:

    use Filter::Include;
    include MyHandyModules;

However, it would be really nice if F<MyHandyModules.pm> could define the
macro-like semantic itself, instead of placing the burden on the caller.

This module lets you do precisely that.  All you need to do is to put one
line in F<MyHandyModules.pm>, after the C<package MyHandyModules;> line:

    use Filter::Macro;

With this, a program or module that says C<use Filter::Macro> will expand
lines below C<use Filter::Macro> into their own code, instead of the default
semantic of evaluating them in the C<MyHandyModules> package.

Line numbers in error and warning messages are unaffected by this module;
they still point to the correct file name and line numbers.

=head1 SEE ALSO

L<Filter::Include>, L<Filter::Simple>

=head1 AUTHORS

Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>

Based on Damian Conway's concept, covered in his excellent I<Sufficiently
Advanced Technologies> talk.

=head1 COPYRIGHT

Copyright 2004 by Autrijus Tang E<lt>autrijus@autrijus.orgE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
