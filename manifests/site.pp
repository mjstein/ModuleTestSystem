node  /minion1/{
  class {'kubernetes::minion':
    master_name => '173.16.32.11',
    minion_name => '173.16.32.12'
  }
  contain 'kubernetes::minion'
}

node  /minion2/{
  class {'kubernetes::minion':
    master_name => '173.16.32.11',
    minion_name => '173.16.32.13'
  }
  contain 'kubernetes::minion'
}
node  /master/{
  class {'kubernetes::master':
    master_name => '173.16.32.11',
    minion_name => ['173.16.32.12','173.16.32.13']
  }
  contain 'kubernetes::master'
}
