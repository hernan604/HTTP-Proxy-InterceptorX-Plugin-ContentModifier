# NAME

HTTP::Proxy::InterceptorX::Plugin::ContentModifier - Allows you to change parts or the whole response content

# SYNOPSIS

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



# CONFIG

save a config\_file.pl

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

# DESCRIPTION

HTTP::Proxy::InterceptorX::Plugin::ContentModifier is

# AUTHOR

Hernan Lopes <hernan@cpan.org>

# COPYRIGHT

Copyright 2013- Hernan Lopes

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
