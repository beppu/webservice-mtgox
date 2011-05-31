use inc::Module::Install;
name 'WebService-MtGox';
all_from 'lib/WebService/MtGox.pm';

requires 'Moo'                  => 0;
requires 'Ouch'                 => 0;
requires 'parent'               => 0; # for Ouch
requires 'JSON'                 => 0;
requires 'LWP::UserAgent'       => 0;
requires 'LWP::Protocol::https' => 0;

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
