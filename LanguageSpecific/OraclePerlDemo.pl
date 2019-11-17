#
# DBI programming example
# guy.a.harrison@gmail.com
#
use Time::HiRes qw(time);
use DBI;
 use DBD::Oracle qw(:ora_types);

use strict;
our $dbh;

sub main() {
	my ($login) = @_;
	$| = 1;
	$dbh = DBI->connect( 'dbi:Oracle:', $login )
	  || die $DBI::errstr;
	$dbh->{AutoCommit} = 0;

	my $fetchSize   = 1000;
	my $insertCount = 1000;
	my $fetchCount  = 1000;
	&setup();
	&arrayInsert( $insertCount, $fetchSize );

	&setup();
	&singleRowInsert($insertCount);
	$dbh->do( "begin sys.dbms_stats.gather_table_stats"
		  . "(ownname=>user,tabname=>'PerlDemo'); end; " )
	  || die $DBI::errstr;
	&flushDb();
	&simpleFetch(100);
	&flushDb();
	&simpleFetch(1);
	&flushDb();
	&fetch_all_example(100);
	&flushDb();
	&bindSelect($fetchCount);
	&flushDb();
	&noBindSelect($fetchCount);
	&flushDb();
	&bindIntSelect($fetchCount);

	print "done\n";

}

sub flushDb() {
	$dbh->do("ALTER SYSTEM FLUSH SHARED_POOL")  || die $DBI::errstr;
	$dbh->do("ALTER SYSTEM FLUSH BUFFER_CACHE") || die $DBI::errstr;
}

sub setup() {
	$dbh->do(" alter session set events '10046 trace name context forever, level 12' " )
	  || die $DBI::errstr;
	$dbh->do(" ALTER SESSION SET tracefile_identifier = PerlDemo ")
	  || die $DBI::errstr;
	$dbh->do(" DROP table PerlDemo ");

	$dbh->do(
		" CREATE TABLE PerlDemo(
			x number, y number)"
	  )
	  || die $DBI::errstr;
}

sub simpleFetch() {
	print "Simple fetch example : ";
	my ($rowCacheSize) = @_;

	$dbh->{RowCacheSize} = $rowCacheSize;

	my $start = time;
	my $sth   = $dbh->prepare("SELECT /* Simple Fetch*/ x,y FROM PerlDemo")
	  || die $DBI::errstr;
	$sth->execute() || die $DBI::errstr;
	my $sum = 0;
	while ( ( my $x, my $y ) = $sth->fetchrow_array ) {
		$sum += $x;
	}
	die "Fetch failed due to $DBI::errstr" if $DBI::err;
	$sth->finish();
	my $elapsed = time - $start;

	print "$elapsed ms SumOfX=$sum\n";
}

sub fetch_all_example() {
	print "Fetchall example : ";
	my ($rowCacheSize) = @_;
	$dbh->{RowCacheSize} = $rowCacheSize;

	my $start = time;
	my $sum   = 0;
	my $sth = $dbh->prepare("SELECT /* fetchall_arrayref */ x,y FROM PerlDemo")
	  || die $DBI::errstr;
	$sth->execute() || die $DBI::errstr;
	my $resultSet = $sth->fetchall_arrayref || die $DBI::errstr;
	for my $rownum ( 0 .. $#$resultSet ) {
		$sum += $resultSet->[$rownum][0];
	}
	$sth->finish();
	my $elapsed = time - $start;
	print "$elapsed ms SumOfX=$sum\n";
}

sub arrayInsert() {

	#
	# Example of inserting using arrays
	#
	my ( $insertCount, $array_size ) = @_;

	my @x_values;
	my @y_values;
	my @status;
	print "Array insert $insertCount rows $array_size arrays: ";
	for ( my $i = 0 ; $i < $insertCount ; $i++ ) {
		$x_values[$i] = $i;
		$y_values[$i] = $i;
	}

	my $start = time;

	my $sth = $dbh->prepare(
		qq{INSERT /* array */ INTO PerlDemo (x, y)
           VALUES (?, ?)}
	  )
	  || die $DBI::errstr;

	$dbh->{ora_array_chunk_size} = 100;
	$sth->bind_param_array( 1, \@x_values ) || die $DBI::errstr;
	$sth->bind_param_array( 2, \@y_values ) || die $DBI::errstr;

	$sth->execute_array( { ArrayTupleStatus => \@status } )
	  || die $DBI::errstr;
	$dbh->commit();
	my $elapsed = time - $start;
	print $elapsed. " ms\n";

}

sub singleRowInsert() {

	#
	# Example of inserting one row at a time
	#
	my ($insertCount) = @_;
	print "Single row insert $insertCount : ";
	my $start  = time;
	my $sumOfX = 0;

	my $sth = $dbh->prepare(
		qq{
        INSERT /* single rows*/  INTO PerlDemo (x, y)
        VALUES (?, ?)}
	) || die $DBI::errstr;

	for ( my $i = 0 ; $i < $insertCount ; $i++ ) {
		$sth->bind_param( 1, $i ) || die $DBI::errstr;
		$sth->bind_param( 2, $i ) || die $DBI::errstr;
		$sth->execute() || die $DBI::errstr;
	}

	$dbh->commit();
	my $elapsed = time - $start;
	print "$elapsed ms\n";
}

sub bindSelect() {

	# Select using bind variables (no data type specified)
	my ($rowFetches) = @_;
	print "Select with binds: ";
	my $sumOfY = 0;
	my $start  = time;

	my $sth = $dbh->prepare(qq{SELECT /*bind1*/ y FROM PerlDemo WHERE x=?})
	  || die $DBI::errstr;

	for ( my $x_value = 0 ; $x_value <= $rowFetches ; $x_value++ ) {

		$sth->bind_param( 1, $x_value ) || die $DBI::errstr;
		$sth->execute() || die $DBI::errstr;
		while ( ( my $yvalue ) = $sth->fetchrow_array ) {
			$sumOfY += $yvalue;
		}
		die "Fetch failed due to $DBI::errstr" if $DBI::err;

	}
	$sth->finish();
	my $elapsed = time - $start;
	print "$elapsed ms, sumOfY=$sumOfY\n";

}

sub bindIntSelect() {

	# Select with  bind variables, specifying that the bind is an integer
	my ($rowFetches) = @_;
	print "Select with integer binds: ";
	my $sumOfY = 0;
	my $start  = time;

	my $sth = $dbh->prepare(qq{SELECT /* bind2*/ y FROM PerlDemo WHERE x=?})
	  || die $DBI::errstr;

	for ( my $x_value = 0 ; $x_value <= $rowFetches ; $x_value++ ) {

		$sth->bind_param( 1, $x_value, { ora_type => ORA_NUMBER } )
		  || die $DBI::errstr;
		$sth->execute() || die $DBI::errstr;
		while ( ( my $yvalue ) = $sth->fetchrow_array ) {
			$sumOfY += $yvalue;
		}
		die "Fetch failed due to $DBI::errstr" if $DBI::err;
		$sth->finish();
	}

	my $elapsed = time - $start;
	print "$elapsed ms, sumOfY=$sumOfY\n";

}

sub noBindSelect() {

	my ($rowFetches) = @_;
	print "Select without binds: ";
	my $sumOfY = 0;
	my $start  = time;

	for ( my $x_value = 0 ; $x_value <= $rowFetches ; $x_value++ ) {

		# Prepare and execute the statement
		my $sth = $dbh->prepare(qq{SELECT y FROM PerlDemo WHERE x=$x_value})
		  || die $DBI::errstr;
		$sth->execute() || die $DBI::errstr;

		# Fetch the rows
		while ( ( my $yvalue ) = $sth->fetchrow_array ) {
			$sumOfY += $yvalue;
		}
		die "Fetch failed due to $DBI::errstr" if $DBI::err;
		$sth->finish();
	}

	my $elapsed = time - $start;
	print "$elapsed ms, sumOfY=$sumOfY\n";

}

&main(@ARGV);

