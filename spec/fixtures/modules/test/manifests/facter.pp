class test::facter {
  if $::operatingsystem == 'foo' {
    notify { 'foo': }
  } else {
    notify { 'other': }
  }
}
