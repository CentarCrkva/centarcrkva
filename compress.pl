#!perl

use strict;
use warnings;
use autodie qw(:io);
use File::Slurp;
use CSS::Minifier;
use JavaScript::Minifier;

my $html = read_file 'index-orign.html';

$html =~ s{<style>(.*)</style>}{minify_css($1)}gesm;
$html =~ s{<script>(.*)</script>}{minify_js($1)}gesm;
for ($html) {
    s/\n/ /g;
    s/\s+/ /g;
    s/\s+([<>])/ $1/g;
    s/([<>])\s+/$1 /g;
}
write_file 'index.html', $html;

sub minify_css {
    my $css = CSS::Minifier::minify(input => shift);
    for ($css) {
        s/;}/}/g;
        s/\s+(!important)/$1/g;
    }
    return '<style>' . $css . '</style>';
}
sub minify_js {
    my $js = JavaScript::Minifier::minify(input => shift);
    return '<script>' . $js . '</script>';
}