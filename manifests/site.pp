node  /minion1/{
  class {'kubernetes::minion':
    master_name => '173.16.33.11',
    minion_name => '173.16.33.12'
  }
  contain 'kubernetes::minion'
}

node  /minion2/{
  class {'kubernetes::minion':
    master_name => '173.16.33.11',
    minion_name => '173.16.33.13'
  }
  contain 'kubernetes::minion'
}
node  /master/{
  class {'kubernetes::master':
    master_name => '173.16.33.11',
    minion_name => ['173.16.33.12','173.16.33.13']
  }
  contain 'kubernetes::master'
}
