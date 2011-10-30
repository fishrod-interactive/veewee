Veewee::Session.declare({
  :cpu_count => '1', :memory_size=> '256', 
  :disk_size => '10140', :disk_format => 'VDI',:hostiocache => 'off',
  :os_type_id => 'ArchLinux_64',
  :iso_file => "archlinux-2011.08.19-netinstall-x86_64.iso",
  :iso_src => "http://archlinux.mirror.kangaroot.net/iso/2011.08.19/archlinux-2011.08.19-netinstall-x86_64.iso",
  :iso_md5 => "03a328dfd7a2f901995d77bcf645130c",
  :iso_download_timeout => "1000",
  :boot_wait => "5", :boot_cmd_sequence => [
    '<Enter>',
    '<Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait>',
    '<Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait><Wait>',
    'dhcpcd eth0<Enter><Wait><Wait><Wait><Wait>',
    'passwd<Enter>',
    'vagrant<Enter>',
    'vagrant<Enter>',
    '/etc/rc.d/sshd start<Enter><Wait>',
	'sleep 3 && wget 10.0.2.2:7122/aif.cfg<Enter>',
  ],
  :kickstart_port => "7122", :kickstart_timeout => "10000", :kickstart_file => "aif.cfg",
  :ssh_login_timeout => "10000", :ssh_user => "root", :ssh_password => "vagrant", :ssh_key => "",
  :ssh_host_port => "7222", :ssh_guest_port => "22",
  :sudo_cmd => "sh '%f'",
  :shutdown_cmd => "shutdown -h now",
  :postinstall_files => [ "postinstall.sh", "postinstall2.sh"], :postinstall_timeout => "10000"
})
