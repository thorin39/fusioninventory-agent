package FusionInventory::Agent::Task::Inventory::OS::BSD::Memory;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled { 	
    return
        can_run('sysctl') &&
        can_run('swapctl');
};

sub doInventory {
    my (%params) = @_;

    my $inventory = $params{inventory};
    my $logger    = $params{logger};

    # Swap
    my $swapSize;
    my @bsd_swapctl = `swapctl -sk`;
    foreach (@bsd_swapctl) {
        $swapSize = $1 if /total:\s*(\d+)/i;
    }

    # RAM
    my $memorySize = getFirstLine(command => 'sysctl -n hw.physmem');
    $memorySize = $memorySize / 1024;

    $inventory->setHardware({
        MEMORY => int($memorySize / 1024),
        SWAP   => int($swapSize / 1024),
    });
}

1;
