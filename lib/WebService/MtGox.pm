package WebService::MtGox;
use Moo;
use Ouch;
use JSON;
use LWP::UserAgent;

our $VERSION  = '0.01';
our $BASE_URL = 'http://mtgox.com/code';

has user     => (is => 'ro');
has password => (is => 'ro');
has base_url => (is => 'rw', lazy => 1, default => sub { $BASE_URL });
has ua       => (
  is      => 'ro',
  lazy    => 1,
  default => sub {
    my $ua = LWP::UserAgent->new();
    push @{ $ua->requests_redirectable }, 'POST';
    $ua;
  }
);

sub get_ticker {
  my $self = shift;
  my $url  = $self->base_url . "/data/ticker.php";
  my $json = $self->ua->get($url)->content();
  decode_json($json);
}

sub get_depth {
  my $self = shift;
  my $url  = $self->base_url . "/data/getDepth.php";
  my $json = $self->ua->get($url)->content();
  decode_json($json);
}

sub get_trades {
  my $self = shift;
  my $url  = $self->base_url . "/data/getTrades.php";
  my $json = $self->ua->get($url)->content();
  decode_json($json);
}

sub get_balance {
  my $self = shift;
  my $url  = $self->base_url . sprintf("/getFunds.php");
  my $json = $self->ua->post($url, { name => $self->user, pass => $self->password })->content();
  decode_json($json);
}

sub buy {
  my $self   = shift;
  my %params = @_;
  my $url    = $self->base_url . sprintf("/buyBTC.php");
  my $json = $self->ua->post($url, {
    name   => $self->user,
    pass   => $self->password,
    amount => $params{amount},
    price  => $params{price},
  })->content();
  decode_json($json);
}

sub sell {
  my $self   = shift;
  my %params = @_;
  my $url    = $self->base_url . sprintf("/sellBTC.php");
  my $json   = $self->ua->post($url, {
    name   => $self->user,
    pass   => $self->password,
    amount => $params{amount},
    price  => $params{price},
  })->content();
  decode_json($json);
}

sub list {
  my $self   = shift;
  my %params = @_;
  my $url    = $self->base_url . sprintf("/getOrders.php");
  my $json   = $self->ua->post($url, {
    name => $self->user,
    pass => $self->password,
  })->content();
  decode_json($json);
}

sub cancel {
  my $self   = shift;
  my %params = @_;
  my $url    = $self->base_url . sprintf("/cancelOrder.php");
  my $json   = $self->ua->post($url, {
    name => $self->user,
    pass => $self->password,
    oid  => $params{oid},
    type => $params{type},
  })->content();
  decode_json($json);
}

sub send {
  my $self   = shift;
  my %params = @_;
  my $url    = $self->base_url . "/withdraw.php?name=%s&pass=%s&group1=BTC&btca=&amount=%s";
  my $json   = $self->ua->post($url, {
    name   => $self->user,
    pass   => $self->password,
    group1 => 'BTC'
    btca   => $params{bitcoin_address},
    amount => $params{amount}
  })->content();
  decode_json($json);
}


1;
__END__

=head1 NAME

WebService::MtGox - access to mtgox.com's bitcoin trading API

=head1 SYNOPSIS

Creating the $mtgox client

  use WebService::MtGox;
  my $mtgox = WebService::MtGox->new(
    user     => 'you',
    password => 'secret',
  );

Getting Trade Data

  my $ticker = $mtgox->get_ticker;

Placing Buy and Sell Orders

  my $r1 = $mtgox->buy(amount => 24, price => 7.77);
  my $r2 = $mtgox->sell(amount => 10, price => 8.12);


=head1 DESCRIPTION

WebService::MtGox gives you access to MtGox's bitcoin trading API.
With this module, you can get current market data and initiate your
buy and sell orders.

=head1 API

=head2  Market Information

=head3    $mtgox->get_ticker

=head3    $mtgox->get_depth

=head3    $mtgox->get_trades

=head2  Orders

=head3    $mtgox->get_balance

=head3    $mtgox->buy

=head3    $mtgox->sell

=head3    $mtgox->list

=head3    $mtgox->cancel

=head2  Sending Bitcoins

=head3    $mtgox->send

=head1 AUTHOR

John BEPPU E<lt>beppu {at} cpan.orgE<gt>

=head1 SEE ALSO

=head2  API Documentation

L<https://mtgox.com/support/tradeAPI>

=head2  Other Bitcoin-related Modules

L<Finance::Bitcoin>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
