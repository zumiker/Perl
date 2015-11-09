#!/usr/bin/perl

package ST29;

use strict;

my @spisok;

sub show {
    if( $#spisok != -1){
        my $i = 0;
            if ($_[0] == 1) {
                foreach my $pers (@spisok) {
                    print ++$i.") Name - ".$pers->{name}."; Age = ".$pers->{age}."\n";
                }
            }
            else{
                foreach my $pers (@spisok) {
                    print "Name - ".$pers->{name}."; Age = ".$pers->{age}."\n";
                }
            }
            return 1
    }
    else{
        print "Nobody in da list\n";
        return 0
    }
};
 
sub check_name {
    my $str;
    if ($_[0]) {
        $str = "Edit Name (".$_[0].") = ";
    }
    else{
        $str = "Enter Name = ";
    }
    print  $str;
    my $name = <STDIN>;
    chomp($name);
    while($name =~ /[^a-zA-Z]/ || length($name) == 0){
        print "The Name must be literal\n". $str;
        $name = <STDIN>;
        chomp($name);
    }
    return $name
};
 
sub check_age {
    my $str;
    if ($_[0]) {
        $str = "Edit Age (".$_[0].") = ";
    }
    else{
        $str = "Enter Age = ";
    }
    print  $str;
    my $age = <STDIN>;
    chomp($age);
    while($age =~ /\D/ || $age == ""){
        print "The Age must be digit\n".$str;
        $age = <STDIN>;
        chomp($age);    
    }
    return $age
};

sub get_num {
    my $length = $#spisok;
    $length++;
    if($length == 1){
        return 1
    }
    else{
        print "Choose the number of record = ";
        my $choice = <STDIN>;
        chomp($choice);
        while($choice > $length || $choice =~ /\D/ || $choice == ""){
            print "Repeat entering!!!\nChoose the number of record = ";
            $choice = <STDIN>;
            chomp($choice);
        }
        return $choice
    }
}
 
my %arr_fun = (
    1 => sub {
        my %spi = (
            name => &check_name(),
            age => &check_age(),
            );
        push(@spisok, \%spi);
    },
    2 => sub {
        if(&show(1) == 1){
            my $num = &get_num();
            my $rec = $spisok[$num-1];
            print "Edit Name of record $num!\n";
            $rec -> {name} = &check_name($rec -> {name});
            print "Edit Age of record $num!\n";
            $rec -> {age} = &check_age($rec -> {age})

        }
    },
    3 => sub {
        if(&show(1) == 1){
            my $num = &get_num();
            splice(@spisok, --$num, 1);
            print "Record number ".++$num." has been deleted\n\n" 
        }
    },
    4 => sub {
        &show();
    },
    5 => sub {
        if($#spisok != -1){
            my %A;
            my $i = -1;
            dbmopen(%A, "file", 0666);
            foreach my $pers (@spisok){
                $A{++$i} = join('::::', $pers -> {name}, $pers -> {age});
            }
            dbmclose(%A);
            print "Complete!!!!\n"
        }
        else{
            print "Nobody in da list\n"
        }
    },
    6 => sub {
        my %A;
        my $i = -1;
        @spisok = ();
        dbmopen(%A, "file", 0666) or die "can't fight this love";
        while ( my ($key, $value) = each(%A) ) {
            (my $name, my $age) = split('::::', $value);
            my %rec = (
                name => $name,
                age => $age
            );
            push(@spisok, \%rec);
        }
        dbmclose(%A);
        print "Read complete!!!\n\n"
        
    },
    7 => sub {
        last
    }
);
 
 
 
sub menu(){
    print "Choose your destiny\n1)Add\n2)Edit\n3)Delete\n4)Show List\n5)Write *.dbm\n6)Read from file\n7)Exit\n";
    my $choice = <STDIN>;
    chomp($choice);
    if (($choice =~ /\D/) || ($choice>7) || ($choice<1)){
        print "Repeat entering!!!\n"
    }
    else{
        $arr_fun{$choice}->()
    }
}

sub st29{ 
    while(1){
        &menu();
    }
}

return 1;