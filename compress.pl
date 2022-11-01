#!perl

use strict;
use warnings;
use autodie qw(:io);
use File::Slurp;
use CSS::Minifier qw(minify);

my $html = read_file 'index-orign.html';

$html =~ s{<style>(.*)</style>}{minify_css($1)}gesm;
for ($html) {
    s/\n/ /g;
    s/\s+/ /g;
    s/\s*([<>])\s*/$1/
}
write_file 'index.html', $html;

sub minify_css {
    my $css = minify(input => shift);
    for ($css) {
        s/;}/}/g;
        s/\s+(!important)/$1/g;
        # s/\s*>\s*/>/g;
    }
    return '<style>' . $css . '</style>';
}