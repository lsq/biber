use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 64;

use Biber;
use Biber::Utils;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('sections-complex.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Biblatex options
Biber::Config->setblxoption('labelalpha', 1);
Biber::Config->setblxoption('maxnames', 1);
Biber::Config->setblxoption('labelyear', undef);

# Now generate the information
$biber->prepare;
my $section0 = $biber->sections->get_section(0);
my $bibentries0 = $section0->bibentries;
my $main0 = $section0->get_list('MAIN');
my $section1 = $biber->sections->get_section(1);
my $main1 = $section1->get_list('MAIN');
my $bibentries1 = $section1->bibentries;

is($bibentries0->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=1 minnames=1 entry L1 labelalpha');
ok(is_undef($main0->get_extraalphadata('l1')), 'maxnames=1 minnames=1 entry L1 extraalpha');
is($bibentries0->entry('l2')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L2 labelalpha');
is($main0->get_extraalphadata('l2'), '1', 'maxnames=1 minnames=1 entry L2 extraalpha');
is($bibentries0->entry('l3')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L3 labelalpha');
is($main0->get_extraalphadata('l3'), '2', 'maxnames=1 minnames=1 entry L3 extraalpha');
is($bibentries0->entry('l4')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L4 labelalpha');
is($main0->get_extraalphadata('l4'), '3', 'maxnames=1 minnames=1 entry L4 extraalpha');
is($bibentries1->entry('l5')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L5 labelalpha');
is($main1->get_extraalphadata('l5'), '1', 'maxnames=1 minnames=1 entry L5 extraalpha');
is($bibentries1->entry('l6')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L6 labelalpha');
is($main1->get_extraalphadata('l6'), '2', 'maxnames=1 minnames=1 entry L6 extraalpha');
is($bibentries1->entry('l7')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L7 labelalpha');
is($main1->get_extraalphadata('l7'), '3', 'maxnames=1 minnames=1 entry L7 extraalpha');
is($bibentries1->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=1 minnames=1 entry L8 labelalpha');
ok(is_undef($main1->get_extraalphadata('l8')), 'maxnames=1 minnames=1 entry L8 extraalpha');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 2);
Biber::Config->setblxoption('minnames', 1);

for (my $i=1; $i<5; $i++) {
  $bibentries0->entry("l$i")->del_field('sortlabelalpha');
  $bibentries0->entry("l$i")->del_field('labelalpha');
  $main0->set_extraalphadata("l$i", undef);
}
for (my $i=5; $i<9; $i++) {
  $bibentries1->entry("l$i")->del_field('sortlabelalpha');
  $bibentries1->entry("l$i")->del_field('labelalpha');
  $main1->set_extraalphadata("l$i", undef);
}
$biber->prepare;
$section0 = $biber->sections->get_section(0);
$bibentries0 = $section0->bibentries;
$main0 = $section0->get_list('MAIN');
$section1 = $biber->sections->get_section(1);
$main1 = $section1->get_list('MAIN');
$bibentries1 = $section1->bibentries;

is($bibentries0->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=2 minnames=1 entry L1 labelalpha');
ok(is_undef($main0->get_extraalphadata('l1')), 'maxnames=2 minnames=1 entry L1 extraalpha');
is($bibentries0->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=1 entry L2 labelalpha');
is($main0->get_extraalphadata('l2'), '1', 'maxnames=2 minnames=1 entry L2 extraalpha');
is($bibentries0->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=1 entry L3 labelalpha');
is($main0->get_extraalphadata('l3'), '2', 'maxnames=2 minnames=1 entry L3 extraalpha');
is($bibentries0->entry('l4')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L4 labelalpha');
ok(is_undef($main0->get_extraalphadata('l4')), 'maxnames=2 minnames=1 entry L4 extraalpha');
is($bibentries1->entry('l5')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L5 labelalpha');
is($main1->get_extraalphadata('l5'), '1', 'maxnames=2 minnames=1 entry L5 extraalpha');
is($bibentries1->entry('l6')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L6 labelalpha');
is($main1->get_extraalphadata('l6'), '2', 'maxnames=2 minnames=1 entry L6 extraalpha');
is($bibentries1->entry('l7')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L7 labelalpha');
is($main1->get_extraalphadata('l7'), '3', 'maxnames=2 minnames=1 entry L7 extraalpha');
is($bibentries1->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=2 minnames=1 entry L8 labelalpha');
ok(is_undef($main1->get_extraalphadata('l8')), 'maxnames=2 minnames=1 entry L8 extraalpha');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 2);
Biber::Config->setblxoption('minnames', 2);

for (my $i=1; $i<5; $i++) {
  $bibentries0->entry("l$i")->del_field('sortlabelalpha');
  $bibentries0->entry("l$i")->del_field('labelalpha');
  $main0->set_extraalphadata("l$i", undef);
}
for (my $i=5; $i<9; $i++) {
  $bibentries1->entry("l$i")->del_field('sortlabelalpha');
  $bibentries1->entry("l$i")->del_field('labelalpha');
  $main1->set_extraalphadata("l$i", undef);
}
$biber->prepare;
$section0 = $biber->sections->get_section(0);
$bibentries0 = $section0->bibentries;
$main0 = $section0->get_list('MAIN');
$section1 = $biber->sections->get_section(1);
$main1 = $section1->get_list('MAIN');
$bibentries1 = $section1->bibentries;

is($bibentries0->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=2 minnames=2 entry L1 labelalpha');
ok(is_undef($main0->get_extraalphadata('l1')), 'maxnames=2 minnames=2 entry L1 extraalpha');
is($bibentries0->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=2 entry L2 labelalpha');
is($main0->get_extraalphadata('l2'), '1', 'maxnames=2 minnames=2 entry L2 extraalpha');
is($bibentries0->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=2 entry L3 labelalpha');
is($main0->get_extraalphadata('l3'), '2', 'maxnames=2 minnames=2 entry L3 extraalpha');
is($bibentries0->entry('l4')->get_field('sortlabelalpha'), 'DA+95', 'maxnames=2 minnames=2 entry L4 labelalpha');
ok(is_undef($main0->get_extraalphadata('l4')), 'maxnames=2 minnames=2 entry L4 extraalpha');
is($bibentries1->entry('l5')->get_field('sortlabelalpha'), 'DA+95', 'maxnames=2 minnames=2 entry L5 labelalpha');
ok(is_undef($main1->get_extraalphadata('l5')), 'maxnames=2 minnames=2 entry L5 extraalpha');
is($bibentries1->entry('l6')->get_field('sortlabelalpha'), 'DS+95', 'maxnames=2 minnames=2 entry L6 labelalpha');
is($main1->get_extraalphadata('l6'), '1', 'maxnames=2 minnames=2 entry L6 extraalpha');
is($bibentries1->entry('l7')->get_field('sortlabelalpha'), 'DS+95', 'maxnames=2 minnames=2 entry L7 labelalpha');
is($main1->get_extraalphadata('l7'), '2', 'maxnames=2 minnames=2 entry L7 extraalpha');
is($bibentries1->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=2 minnames=2 entry L8 labelalpha');
ok(is_undef($main1->get_extraalphadata('l8')), 'maxnames=2 minnames=2 entry L8 extraalpha');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 3);
Biber::Config->setblxoption('minnames', 1);

for (my $i=1; $i<5; $i++) {
  $bibentries0->entry("l$i")->del_field('sortlabelalpha');
  $bibentries0->entry("l$i")->del_field('labelalpha');
  $main0->set_extraalphadata("l$i", undef);
}
for (my $i=5; $i<9; $i++) {
  $bibentries1->entry("l$i")->del_field('sortlabelalpha');
  $bibentries1->entry("l$i")->del_field('labelalpha');
  $main1->set_extraalphadata("l$i", undef);
}

$biber->prepare;
$section0 = $biber->sections->get_section(0);
$bibentries0 = $section0->bibentries;
$main0 = $section0->get_list('MAIN');
$section1 = $biber->sections->get_section(1);
$main1 = $section1->get_list('MAIN');
$bibentries1 = $section1->bibentries;

is($bibentries0->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=3 minnames=1 entry L1 labelalpha');
ok(is_undef($main0->get_extraalphadata('l1')), 'maxnames=3 minnames=1 entry L1 extraalpha');
is($bibentries0->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=3 minnames=1 entry L2 labelalpha');
is($main0->get_extraalphadata('l2'), '1', 'maxnames=3 minnames=1 entry L2 extraalpha');
is($bibentries0->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=3 minnames=1 entry L3 labelalpha');
is($main0->get_extraalphadata('l3'), '2', 'maxnames=3 minnames=1 entry L3 extraalpha');
is($bibentries0->entry('l4')->get_field('sortlabelalpha'), 'DAE95', 'maxnames=3 minnames=1 entry L4 labelalpha');
ok(is_undef($main0->get_extraalphadata('l4')), 'maxnames=3 minnames=1 entry L4 extraalpha');
is($bibentries1->entry('l5')->get_field('sortlabelalpha'), 'DAE95', 'maxnames=3 minnames=1 entry L5 labelalpha');
ok(is_undef($main1->get_extraalphadata('l5')), 'maxnames=3 minnames=1 entry L5 extraalpha');
is($bibentries1->entry('l6')->get_field('sortlabelalpha'), 'DSE95', 'maxnames=3 minnames=1 entry L6 labelalpha');
ok(is_undef($main1->get_extraalphadata('l6')), 'maxnames=3 minnames=1 entry L6 extraalpha');
is($bibentries1->entry('l7')->get_field('sortlabelalpha'), 'DSJ95', 'maxnames=3 minnames=1 entry L7 labelalpha');
ok(is_undef($main1->get_extraalphadata('l7')), 'maxnames=3 minnames=1 entry L7 extraalpha');
is($bibentries1->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=3 minnames=1 entry L8 labelalpha');
ok(is_undef($main1->get_extraalphadata('l8')), 'maxnames=3 minnames=1 entry L8 extraalpha');

unlink <*.utf8>;