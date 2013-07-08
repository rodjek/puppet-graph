class test {
  notify { 'foo': }
  notify { 'bar': }
  notify { 'baz': }

  Notify['foo'] -> Notify['bar'] -> Notify['baz']
}
