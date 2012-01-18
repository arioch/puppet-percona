# percona_datadir.rb
Facter.add("percona_datadir") do
  setcode do
    %x{
      if [ $(which xtrabackup &>/dev/null; echo $?) -eq 0 ];
      then
        if [ $(xtrabackup | grep datadir | tail -1 | awk {'print $2'} | grep -vi error &>/dev/null) ];
        then
          echo 'error: datadir not found'
        else
          xtrabackup | grep datadir | tail -1 | awk {'print $2'}
        fi
      else
        echo 'error: xtrabackup is not installed'
      fi
    }.chomp
  end
end