function __fish_pb_no_subcommand --description 'Test if profitbricks has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i setup datacenter server volume snapshot loadbalancer nic ipblock drives image lan request location
            return 1
        end
    end
    return 0
end

function __fish_pb_subcommand
    set -l cmd (commandline -poc)
    test (count $cmd) -eq 2
    and test $argv[1] = $cmd[2]
end

function __fish_pb_subsubcommand
    set -l cmd (commandline -poc)
    test (count $cmd) -ge 3
    and test $argv[1] = $cmd[2]
    and test $argv[2] = $cmd[3]
end

function __pb_get_servers
	return ( profitbricks server list --datacenterid $argv[1] | grep -E "^[0-9a-f]{8}\-" | awk '{ print $1 ":" $2 }' ) 
end

set pb_locations 'de/fkb de/fra us/las us/lasdev'
#set pb_dc_infos ( profitbricks datacenter list | grep -E "^[0-9a-f]{8}\-" | sed 's/  /:/' )

complete -c profitbricks -e

# subcommands
# setup
complete -c profitbricks -f -n '__fish_pb_no_subcommand' -a setup -A -d 'Configures credentials for ProfitBricks CLI'

# location
complete -c profitbricks -f -n '__fish_pb_no_subcommand'       -a location    -d 'Location operations'
complete -c profitbricks -f -n '__fish_pb_subcommand location' -a list     -A -d 'Show list of all locations'

# datacenter
complete -c profitbricks -f -n '__fish_pb_no_subcommand'         -a datacenter -d 'Datacenter operations'
complete -c profitbricks -f -n '__fish_pb_subcommand datacenter' -a list    -A -d 'Show list of all datacenters'
complete -c profitbricks -f -n '__fish_pb_subcommand datacenter' -a get        -d 'Get datacenter info'
complete -c profitbricks -f -n '__fish_pb_subcommand datacenter' -a create     -d 'Create new datacenter'
complete -c profitbricks -f -n '__fish_pb_subcommand datacenter' -a delete     -d 'Delete datacenter'

# datacenter get/delete
for cmd in get delete
	complete -c profitbricks -f -n "__fish_pb_subsubcommand datacenter $cmd"     -A -r -s i -l id -d 'ID of datacenter'
end

# datacenter create
complete -c profitbricks -f -n '__fish_pb_subsubcommand datacenter create' -r -s n -l name                         -d 'Name of datacenter'
complete -c profitbricks -f -n '__fish_pb_subsubcommand datacenter create' -r -s l -l location    -a $pb_locations -d 'Location of datacenter'
complete -c profitbricks -f -n '__fish_pb_subsubcommand datacenter create'    -s d -l description                  -d 'Description of datacenter'

# server
complete -c profitbricks -f -n '__fish_pb_no_subcommand'     -a server -d 'Server operations'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a list   -d 'Show list of all servers'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a get    -d 'Get server info'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a update -d 'Update server info'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a create -d 'Create new server'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a delete -d 'Delete server'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a start  -d 'Start server'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a stop   -d 'Stop server'
complete -c profitbricks -f -n '__fish_pb_subcommand server' -a reboot -d 'Reboot server'

# server/nic/volume list
for cmd in server list volume
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd list" -r -l datacenterid -d 'ID of datacenter'
end
#for dc_info in $pb_dc_infos
#	set dc (echo $dc_info | tr ":" "\n")
#	complete -c profitbricks -f -n "__fish_pb_subsubcommand server list" -r -l datacenterid -a $dc[1] -d $dc[2]
#end

# server get/delete/start/stop/reboot
for cmd in get delete start stop reboot
	complete -c profitbricks -f -n "__fish_pb_subsubcommand server $cmd" -r      -l datacenterid -d 'ID of datacenter'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand server $cmd" -r -s i -l id           -d 'ID of server'
end

# server create
complete -c profitbricks -f -n "__fish_pb_subsubcommand server create" -r      -l datacenterid    -d 'ID of datacenter'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server create' -r -s n -l name            -d 'Name of server'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server create' -r -s c -l cores           -d 'Number of CPU cores'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server create' -r -s r -l ram             -d 'Memory size in MB'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server create' -r      -l bootVolume      -d 'Volume ID to boot from'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server create' -r      -l bootCdrom       -d 'Drive ID to boot from'

# server update
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update" -r      -l datacenterid     -d 'ID of datacenter'
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update" -r -s i -l id               -d 'ID of server'
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update"    -s n -l name             -d 'Name of server'
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update"    -s c -l cores            -d 'Number of CPU cores'
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update"    -s r -l ram              -d 'Memory size in MB'
complete -c profitbricks -f -n "__fish_pb_subsubcommand server update"    -s a -l availabilityzone -d 'Availabilityzone'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server update'         -l bootVolume       -d 'Volume ID to boot from'
complete -c profitbricks -f -n '__fish_pb_subsubcommand server update'         -l bootCdrom        -d 'Drive ID to boot from'

# nic
complete -c profitbricks -f -n '__fish_pb_no_subcommand'  -a nic    -d 'NIC operations'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a list   -d 'Show list of all NICs of a server'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a get    -d 'Get NIC info'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a update -d 'Update NIC info'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a create -d 'Create new NIC'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a delete -d 'Delete NIC'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a attach -d 'Attach NIC'
complete -c profitbricks -f -n '__fish_pb_subcommand nic' -a detach -d 'Detach NIC'

# nic list
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic list" -r -l datacenterid   -d 'ID of datacenter'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic list" -r -l serverid       -d 'ID of server'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic list"    -l loadbalancerid -d 'ID of loadbalancer'

# nic get/delete/update/attach/detach
for cmd in get delete update attach detach
	complete -c profitbricks -f -n "__fish_pb_subsubcommand nic $cmd" -r      -l datacenterid -d 'ID of datacenter'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand nic $cmd" -r      -l serverid     -d 'ID of server'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand nic $cmd" -r -s i -l id           -d 'ID of NIC'
end

# nic create
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create" -r      -l datacenterid   -d 'ID of datacenter'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create" -r      -l serverid       -d 'ID of server'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create" -r      -l lan            -d 'LAN to be attached'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create"   -s n  -l name           -d 'Name of NIC'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create"         -l ip             -d 'IP address'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic create"         -l dhcp           -d 'DHCPd enabled'

# nic update
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update"      -l addip    -d 'Add IP address'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update"      -l removeip -d 'Remove IP address'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update" -s n -l name     -d 'Name of NIC'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update"      -l lan      -d 'LAN to be attached'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update"      -l ip       -d 'IP address'
complete -c profitbricks -f -n "__fish_pb_subsubcommand nic update"      -l dhcp     -d 'Use dhcpd of profitbricks, default=True'

# nic attach/detach
for cmd in attach detach
	complete -c profitbricks -f -n "__fish_pb_subsubcommand nic $cmd" -l loadbalancerid -d 'ID of loadbalancer'
end

# lan
complete -c profitbricks -f -n '__fish_pb_no_subcommand'  -a lan    -d 'LAN operations'
complete -c profitbricks -f -n '__fish_pb_subcommand lan' -a list   -d 'Show list of all LANs'
complete -c profitbricks -f -n '__fish_pb_subcommand lan' -a get    -d 'Get LAN info'
complete -c profitbricks -f -n '__fish_pb_subcommand lan' -a update -d 'Update LAN info'
complete -c profitbricks -f -n '__fish_pb_subcommand lan' -a create -d 'Create new LAN' 
complete -c profitbricks -f -n '__fish_pb_subcommand lan' -a delete -d 'Delete LAN'

# lan get/delete/update
for cmd in get delete update
        complete -c profitbricks -f -n "__fish_pb_subsubcommand lan $cmd" -r      -l datacenterid -d 'ID of datacenter'
        complete -c profitbricks -f -n "__fish_pb_subsubcommand lan $cmd" -r -s i -l id           -d 'ID of LAN'
end

# lan create/update
for cmd in create update
        complete -c profitbricks -f -n "__fish_pb_subsubcommand lan $cmd" -r    -l datacenterid -d 'ID of datacenter'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand lan $cmd" -s n  -l name         -d 'Name of NIC'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand lan $cmd"       -l public       -d 'Connect LAN to Internet?'
end

# volume
complete -c profitbricks -f -n '__fish_pb_no_subcommand'  -a volume -d 'Volume operations'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a list   -d 'Show list of all Volumes'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a get    -d 'Get Volume info'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a update -d 'Update Volume info'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a create -d 'Create new Volume' 
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a delete -d 'Delete Volume'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a attach -d 'Attach Volume to server'
complete -c profitbricks -f -n '__fish_pb_subcommand volume' -a detach -d 'Detach Volume from server'

# volume get/delete/update
for cmd in get delete update
        complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r      -l datacenterid -d 'ID of datacenter'
        complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r -s i -l id           -d 'ID of volume'
end

# volume create/update
for cmd in create update
        complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r      -l datacenterid -d 'ID of datacenter'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r -s s -l size         -d 'Volume size in GB'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd"    -s n -l name         -d 'Volume name'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd"    -s b -l bus          -d 'Bus type (VIRTIO or IDE)'
end

# volume create
complete -c profitbricks -f -n "__fish_pb_subsubcommand volume create" -r -s t -l type          -d 'Volume type, currently only HDD'
complete -c profitbricks -f -n "__fish_pb_subsubcommand volume create"         -l imageid       -d 'Create volume from image'
complete -c profitbricks -f -n "__fish_pb_subsubcommand volume create"         -l licencetype   -d 'licencetype of volume'
complete -c profitbricks -f -n "__fish_pb_subsubcommand volume create"         -l imagepassword -d 'One-time password is set on the Image for the appropriate account'
complete -c profitbricks -f -n "__fish_pb_subsubcommand volume create"         -l sshkey        -d 'SSH-key'

# volume attach/detach
for cmd in attach detach
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r      -l datacenterid -d 'ID of datacenter'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r      -l serverid     -d 'ID of server'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand volume $cmd" -r -s i -l id           -d 'ID of volume'
end

# image
complete -c profitbricks -f -n '__fish_pb_no_subcommand'     -a image -d 'Image operations'
complete -c profitbricks -f -n '__fish_pb_subcommand image' -a list   -d 'Show list of all images'
complete -c profitbricks -f -n '__fish_pb_subcommand image' -a get    -d 'Get image info'
complete -c profitbricks -f -n '__fish_pb_subcommand image' -a update -d 'Update image info'
complete -c profitbricks -f -n '__fish_pb_subcommand image' -a delete -d 'Delete image'

# image get/delete/update
for cmd in get delete
	complete -c profitbricks -f -n "__fish_pb_subsubcommand image $cmd" -r -s i -l id -d 'ID of image'
end

# image/snapshot update
for cmd in image snapshot
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update" -s n -l name                -d 'Image name'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update" -s d -l description         -d 'Image description'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l licencetype         -d 'licencetype of image'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l cpuHotPlug          -d 'is capable of CPU hot plug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l cpuHotUnplug        -d 'is capable of CPU hot unplug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l ramHotPlug          -d 'is capable of memory hot plug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l ramHotUnplug        -d 'is capable of memory hot unplug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l nicHotPlug          -d 'is capable of NIC hot plug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l nicHotUnplug        -d 'is capable of NIC hot unplug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l discVirtioHotPlug   -d 'is capable of Virt-IO drive hot plug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l discVirtioHotUnplug -d 'is capable of Virt-IO drive hot unplug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l discScsiHotPlug     -d 'is capable of SCSI drive hot plug'
	complete -c profitbricks -f -n "__fish_pb_subsubcommand $cmd update"      -l discScsiHotUnplug   -d 'is capable of SCSI drive hot unplug'
end

# snapshot
complete -c profitbricks -f -n '__fish_pb_no_subcommand'    -a snapshot -d 'Snapshot operations'
complete -c profitbricks -f -n '__fish_pb_subcommand snapshot' -a list   -d 'Show list of all snapshots'
complete -c profitbricks -f -n '__fish_pb_subcommand snapshot' -a get    -d 'Get snapshot info'
complete -c profitbricks -f -n '__fish_pb_subcommand snapshot' -a update -d 'Update snapshot info'
complete -c profitbricks -f -n '__fish_pb_subcommand snapshot' -a create -d 'Create snapshot'
complete -c profitbricks -f -n '__fish_pb_subcommand snapshot' -a delete -d 'Delete snapshot'

# snapshot get/delete
for cmd in get delete
	complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot $cmd" -r -s i -l id -d 'ID of snapshot'
end

# snapshot create
complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot create" -r      -l datacenterid -d 'ID of datacenter'
complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot create" -r      -l volumeid     -d 'ID of volume'
complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot create"    -s n -l name         -d 'Snapshot name'
complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot create"    -s d -l description  -d 'Snapshot description'

# snapshot update
complete -c profitbricks -f -n "__fish_pb_subsubcommand snapshot update" -r -s i -l id -d 'ID of snapshot'

# ipblock
complete -c profitbricks -f -n '__fish_pb_no_subcommand'      -a ipblock -d 'Public IP operations'
complete -c profitbricks -f -n '__fish_pb_subcommand ipblock' -a list   -d 'Show list of all reserved public IPs'
complete -c profitbricks -f -n '__fish_pb_subcommand ipblock' -a get    -d 'Get IP info'
complete -c profitbricks -f -n '__fish_pb_subcommand ipblock' -a create -d 'Reserve new public IP block'
complete -c profitbricks -f -n '__fish_pb_subcommand ipblock' -a delete -d 'Release public IP block'

# ipblock get/delete
for cmd in get delete
	complete -c profitbricks -f -n "__fish_pb_subsubcommand ipblock $cmd" -r -s i -l id -d 'ID of IP block'
end

# ipblock create
complete -c profitbricks -f -n '__fish_pb_subsubcommand ipblock create' -r -s l -l location -a $pb_locations -d 'Location of datacenter'
complete -c profitbricks -f -n "__fish_pb_subsubcommand ipblock create" -r -s s -l size     -d 'Number of IPs to allocate'
