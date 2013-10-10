package HTTP::Proxy::InterceptorX::Plugin::ContentModifier;

use strict;
use 5.008_005;
our $VERSION = '0.01';

=head2

Plugin para permite alterar o conteúdo de uma página. 

Uma exigencia é usar perl no seu config.pl ao inves de config.json

    "http://www.w3schools.com/" => {
        "code" => sub {
          my ( $self, $content ) = @_;
          $content =~ s/Learn/CLICK FOR WRONG/gix;
          return $content;
        }
    },

No caso acima, sempte que abrir o site www.w3schools vai trocar a palavra "Learn" por "CLICK FOR WRONG"

mas poderia ser usado para trocar caminhos de scripts, ou de imagens.

=cut

use Moose::Role;
use Data::Printer;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError) ;

after 'set_response' => sub {
    my ( $self, $http_request ) = @_; 
    if ( defined $http_request and
         exists $self->urls_to_proxy->{ $self->url } and 
         exists $self->urls_to_proxy->{ $self->url }->{ code } ) {
        my   $content             = $http_request->content;
        if ( exists $http_request->{ _headers }->{ "content-encoding" } and
                    $http_request->{ _headers }->{ "content-encoding" } =~ m/gzip/ig ) {
            my ( $content_decompressed, $scalar, $GunzipError );
            gunzip \$content => \$content_decompressed,
                        MultiStream => 1, Append => 1, TrailingData => \$scalar
               or die "gunzip failed: $GunzipError\n";
               $content = $content_decompressed;
                delete $http_request->{ _headers }->{ "content-encoding" };
                       $http_request->{ _headers }->{ "content-length" } = length $content_decompressed;
        }
        if ( defined $content ) {
            warn "  INTERCEPTED => " , $self->url , "\n";
            $content = $self->urls_to_proxy->{ $self->url }->{ code }( $self, $content );
            $http_request->content( $content );
            $http_request->{ _headers }->{ "content-length" } = length $content;
        }
    }
};

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Proxy::InterceptorX::Plugin::ContentModifier - Blah blah blah

=head1 SYNOPSIS

  use HTTP::Proxy::InterceptorX::Plugin::ContentModifier;

=head1 DESCRIPTION

HTTP::Proxy::InterceptorX::Plugin::ContentModifier is

=head1 AUTHOR

Hernan Lopes E<lt>hernan@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- Hernan Lopes

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
