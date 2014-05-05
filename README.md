# Puppet-graph
[![Build
Status](https://secure.travis-ci.org/rodjek/puppet-graph.png)](http://travis-ci.org/rodjek/puppet-graph)

Trivially generate dependency graphs for any arbitrary bit of Puppet code (like
classes or defined types).

## Requirements

 * Graphviz for PNG generation (if `which dot` returns a path, you're good).

## Installation

Install it as a standalone gem

    gem install puppet-graph-petems

Or as part of a bundler managed repo

    group :development do
      gem 'puppet-graph-petems'
    end

## Usage

```
Usage: puppet-graph [options]
    -c, --code CODE                  Code to generate a graph of
    -f, --fact FACT=VALUE            Override a Facter fact
    -m, --modulepath PATH            The path to your Puppet modules. Defaults to modules/
    -o, --output FILE                The file to save the graph to
    -r, --format FORMAT              Output format (png or dot). Optional if your output file ends in .dot or .png
    -h, --help                       Show this help output
    -v, --version                    Show the version
```

### Building a graph of a class

```
$ puppet-graph -c 'include foo' -o foo.png
```

### Building a graph of a defined type

```
$ puppet-graph -c "foo { 'bar': baz => 'gronk' }" -o foo.png
```

### Overriding the value of a fact

```
$ puppet-graph -c 'include foo' -f 'operatingsystem=Solaris' -o foo.png
```
