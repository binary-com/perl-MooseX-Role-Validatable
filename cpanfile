requires 'perl', '5.008005';

requires 'Scalar::Util';
requires 'Moo';
requires 'Type::Tiny';

on test => sub {
    requires 'Test::More', '0.96';
};
