name 'base'
description 'base role for servers'

run_list(
  # this adds NRPE support
     'recipe[nagios::client]',
       # this installs base NRPE checks (see below)
         'recipe[example::base_monitoring]'
         )
  
         default_attributes(
           :nagios => {
               # you only need this if your nagios server uses a role other than 'monitoring'
                   :server_role => 'monitoring'
                     }
                     )
