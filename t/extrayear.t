use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 17;

use Biber;
use Biber::Utils;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('extrayear.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Biblatex options
Biber::Config->setblxoption('labelyear', [ 'year' ]);
Biber::Config->setblxoption('maxnames', 1);

# Now generate the information
$biber->prepare;
my $section = $biber->sections->get_section(0);
my $main = $section->get_list('MAIN');
my $bibentries = $section->bibentries;

is($main->get_extrayeardata('l1'), '1', 'Entry L1 - one name, first in 1995');
is($main->get_extrayeardata('l2'), '2', 'Entry L2 - one name, second in 1995');
is($main->get_extrayeardata('l3'), '3', 'Entry L3 - one name, third in 1995');
is($main->get_extrayeardata('l4'), '1', 'Entry L4 - two names, first in 1995');
is($main->get_extrayeardata('l5'), '2', 'Entry L5 - two names, second in 1995');
is($main->get_extrayeardata('l6'), '1', 'Entry L6 - two names, first in 1996');
is($main->get_extrayeardata('l7'), '2', 'Entry L7 - two names, second in 1996');
ok(is_undef($main->get_extrayeardata('l8')), 'Entry L8 - one name, only in year');
ok(is_undef($main->get_extrayeardata('l9')), 'Entry L9 - No name, same year as another with no name');
ok(is_undef($main->get_extrayeardata('l10')), 'Entry L10 - No name, same year as another with no name');
is($main->get_extrayeardata('companion1'), '1', 'Entry companion1 - names truncated to same as another entry in same year');
is($main->get_extrayeardata('companion2'), '2', 'Entry companion2 - names truncated to same as another entry in same year');
ok(is_undef($main->get_extrayeardata('companion3')), 'Entry companion3 - one name, same year as truncated names');
ok(is_undef($main->get_extrayeardata('vangennep')), 'Entry vangennep - prefix makes it different');
ok(is_undef($main->get_extrayeardata('gennep')), 'Entry gennep - different from prefix name');
ok(is_undef($main->get_extrayeardata('ly1')), 'Date range means no extrayear - 1');
ok(is_undef($main->get_extrayeardata('ly2')), 'Date range means no extrayear - 2');

unlink <*.utf8>;