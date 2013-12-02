package HTTP::Proxy::InterceptorX::Plugin::ContentModifier;

use strict;
use 5.008_005;
our $VERSION = '0.01';
use Moose::Role;
use Data::Printer;
use IO::Uncompress::Gunzip qw(gunzip $GunzipError) ;

after 'set_response' => sub {
    my ( $self, $http_request ) = @_;
    if ( defined $http_request and
         exists $self->urls_to_proxy->{ $self->url } and
         exists $self->urls_to_proxy->{ $self->url }->{ ContentModifier } ) {
        my   $content             = $http_request->content;
        if ( $content ) {
            warn "  INTERCEPTED => " , $self->url , "\n";
            $content = $self->urls_to_proxy->{ $self->url }->{ ContentModifier }( $self, $content );
            $http_request->content( $content );
            $http_request->{ _headers }->{ "content-length" } = length $content;
        }
    }
};

1;

__END__

=encoding utf-8

=head1 NAME

HTTP::Proxy::InterceptorX::Plugin::ContentModifier - Allows you to change parts or the whole response content

=head1 SYNOPSIS

    package My::Custom::Proxy;
    use Moose;
    extends qw/HTTP::Proxy::Interceptor/;
    with qw/
        HTTP::Proxy::InterceptorX::Plugin::ContentModifier
    /;
    1;

    my $p = My::Custom::Proxy->new(
      config_path => 'config_file.pl',
      port        => 9919,
    );

    $p->start;
    1;


=head1 CONFIG

save a config_file.pl

    {
        #modify the response-content, but only some words.
        #plugin used: HTTP-Proxy-InterceptorX-Plugin-ContentModifier
        "http://www.w3schools.com/" => {
            ContentModifier => sub {
                my ( $self, $content ) = @_;
                $content =~ s/Learn/CLICK FOR WRONG/gix;
                return $content;
            }
        },

        #Or change the whole content of a response
        "http://some.site.com.br?with=query" => {
            ContentModifier => sub {
                my ( $self, $content ) = @_;
                use File::Slurp;
                return read_file( "/home/user/some/content.htm" );
            }
        },
    }

and start the proxy

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
