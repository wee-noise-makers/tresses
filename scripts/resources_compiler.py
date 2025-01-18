#!/usr/bin/python2.5
#
# Copyright 2012 Emilie Gillet.
#
# Author: Emilie Gillet (emilie.o.gillet@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# See http://creativecommons.org/licenses/MIT/ for more information.
#
# -----------------------------------------------------------------------------
#
# Generates .cc and .h files for string, lookup tables, etc.

"""Compiles python string tables/arrays into .cc and .h files."""

import os
import string
import sys

def to_ada_case(str):
  return "_".join(e.capitalize() for e in str.split("_"))

def type_range(typ):
  if typ == "S16":
    return (-32768, 32767)
  elif typ == "S32":
    return (-2147483648, 2147483647)
  elif typ == "U16":
    return (0, 65535)
  elif typ == "U32":
    return (0, 4294967295)
  else:
    raise Exception("Unknown type:%s" % typ)

class ResourceEntry(object):

  def __init__(self, index, key, value, dupe_of, table, in_ram):
    self._index = index
    self._in_ram = in_ram
    self._key = key
    self._value = value
    self._dupe_of = self._key if dupe_of is None else dupe_of
    self._table = table

  @property
  def variable_name(self):
    return '%s_%s' % (self._table.prefix, to_ada_case(self._key))

  @property
  def array_type(self):
    if self._table.python_type == str:
      return "String"
    else:
      return "Table_%d_%s" % (len(self._value), self._table.ada_type)

  @property
  def array_decl(self):
    if self._table.python_type == str:
      return ""
    else:
      size = len(self._value)
      if size <= 2**8:
        index_type = "U8"
      elif size <= 2**16:
        index_type = "U16"
      elif size <= 2**32:
        index_type = "U32"
      else:
        raise Exception("table size:%d" % size)

      return "type Table_%d_%s is array (%s range 0 .. %d) of %s" % \
        (size,
         self._table.ada_type,
         index_type,
         size - 1,
         self._table.ada_type)

  @property
  def declaration(self):
    array_type = self.array_type
    name = self.variable_name
    storage = ' IN_RAM' if self._in_ram else ''
    return '   %(name)s : aliased constant %(array_type)s %(storage)s' % locals()

  def Declare(self, f):
    if self._dupe_of == self._key:
      # Dupes are not declared.
      f.write('extern %s;\n' % self.declaration)

  def DeclareAlias(self, f):
    prefix = self._table.prefix
    key = self._key.upper()
    index = self._index
    if self._table.python_type == str:
      comment = '  -- %s' % self._value
      size = None
    else:
      comment = ''
      size = len(self._value)
    f.write('   %(prefix)s_%(key)s : constant := %(index)d;%(comment)s\n' % locals())
    if not size is None:
      f.write('   %(prefix)s_%(key)s_SIZE : constant := %(size)d;\n' % locals())

  def Compile(self, f):
    declaration = self.declaration

    if self._table.python_type == float:
      f.write('%(declaration)s:= (\n' % locals())
      n_elements = len(self._value)
      last = n_elements - 1
      for i in xrange(0, n_elements, 4):
        f.write('     ');
        f.write(', '.join(
            '% 16.9e' % self._value[j] \
            for j in xrange(i, min(n_elements, i + 4))))
        if i < last - 3:
          f.write(',\n');
      f.write(');\n')
    elif self._table.python_type == str:
      value = self._value
      f.write('%(declaration)s:= "%(value)s";\n' % locals())
    else:
      first, last = type_range(self._table.ada_type)
      for v in self._value:
        int_v = int(v)
        if int_v < first or int_v > last:
          raise Exception("%s value %d not in range %d .. %d" %
                          (self._key, v, first, last))

      f.write('%(declaration)s:= (\n' % locals())
      n_elements = len(self._value)
      last = n_elements - 1
      for i in xrange(0, n_elements, 4):
        f.write('     ');
        f.write(', '.join(
            '%6d' % self._value[j] \
            for j in xrange(i, min(n_elements, i + 4))))
        if i < last - 3:
          f.write(',\n')
      f.write(')\n')
      f.write('     with Linker_Section => Linker_Section;\n')


class ResourceTable(object):

  def __init__(self, resource_tuple):
    self.name = resource_tuple[1]
    self.prefix = resource_tuple[2]
    self.ada_type = resource_tuple[3]
    self.python_type = resource_tuple[4]
    self.ram_based_table = resource_tuple[5]
    self.entries = []
    self._ComputeIdentifierRewriteTable()
    keys = set()
    values = {}
    for index, entry in enumerate(resource_tuple[0]):
      if self.python_type == str:
        # There is no name/value for string entries
        key, value = entry, entry.strip()
      else:
        key, value = entry

      # Add a prefix to avoid key duplicates.
      in_ram = 'IN_RAM' in key
      key = key.replace('IN_RAM', '')
      key = self._MakeIdentifier(key)
      while key in keys:
        key = '_%s' % key
      keys.add(key)
      hashable_value = tuple(value)
      self.entries.append(ResourceEntry(index, key, value,
          values.get(hashable_value, None), self, in_ram))
      if not hashable_value in values:
        values[hashable_value] = key

  def _ComputeIdentifierRewriteTable(self):
    in_chr = ''.join(map(chr, range(256)))
    out_chr = [ord('_')] * 256
    # Tolerated characters.
    for i in string.uppercase + string.lowercase + string.digits:
      out_chr[ord(i)] = ord(i.lower())

    # Rewritten characters.
    in_rewritten = '\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09~*+=><^"|'
    out_rewritten = '0123456789TPSeglxpv'
    for rewrite in zip(in_rewritten, out_rewritten):
      out_chr[ord(rewrite[0])] = ord(rewrite[1])

    table = string.maketrans(in_chr, ''.join(map(chr, out_chr)))
    bad_chars = '\t\n\r-:()[]"\',;'
    self._MakeIdentifier = lambda s:s.translate(table, bad_chars)

  def DeclareEntries(self, f):
    if self.python_type != str:
      for entry in self.entries:
        entry.Declare(f)

  def DeclareAliases(self, f):
    for entry in self.entries:
      entry.DeclareAlias(f)

  def Compile(self, f):
    # Write a declaration for each entry.
    for entry in self.entries:
      entry.Compile(f)

  @property
  def array_decls(self):
    ret = []
    for entry in self.entries:
        ret.append(entry.array_decl)
    return ret
    # # Write the resource pointer table.
    # c_type = self.c_type
    # name = self.name
    # f.write(
    #     '\n\nconst %(c_type)s* %(name)s_table[] = {\n' % locals())
    # for entry in self.entries:
    #   f.write('  %s,\n' % entry.variable_name)
    # f.write('};\n\n')


class ResourceLibrary(object):

  def __init__(self, root):
    self._tables = []
    self._root = root
    self._highest_note = root.highest_note
    # Create resource table objects for all resources.
    for resource_tuple in root.resources:
      # Split a multiline string into a list of strings
      if resource_tuple[-2] == str:
        resource_tuple = list(resource_tuple)
        resource_tuple[0] = [x for x in resource_tuple[0].split('\n') if x]
        resource_tuple = tuple(resource_tuple)
      self._tables.append(ResourceTable(resource_tuple))

  @property
  def max_num_entries(self):
    max_num_entries = 0
    for table in self._tables:
      max_num_entries = max(max_num_entries, len(table.entries))
    return max_num_entries

  def _DeclareArrayTypes(self, f):
    types = []
    for table in self._tables:
      types += table.array_decls
    types = list(set(types))
    for t in types:
      if t != "":
        f.write('   %s;\n' % (t))

  def _DeclareTables(self, f):
    for table in self._tables:
      f.write('extern const %s* %s_table[];\n\n' % (table.c_type, table.name))

  def _DeclareEntries(self, f):
    for table in self._tables:
      table.DeclareEntries(f)

  def _DeclareAliases(self, f):
    for table in self._tables:
      table.DeclareAliases(f)

  def _CompileTables(self, f):
    for table in self._tables:
      table.Compile(f)

  def GenerateHeader(self):
    root = self._root
    sample_rate = os.environ['SAMPLE_RATE']
    f = file(os.path.join(root.target, 'tresses-resources--SR%s.ads' % sample_rate), 'wb')
    # Write header and header guard
    f.write(root.header + '\n')
    # f.write(root.includes + '\n\n')
    f.write("with Tresses_Config;\n")
    f.write("package Tresses.Resources\n")
    f.write("with Preelaborate\n")
    f.write("is\n")
    f.write("   pragma Style_Checks (Off);\n")
    f.write("   SAMPLE_RATE : constant := %s;\n" % sample_rate)
    f.write("   SAMPLE_RATE_REAL : constant := %s.0;\n" % sample_rate)
    f.write("   HIGHEST_NOTE: constant := %d;\n" % self._highest_note)
    f.write("   Linker_Section   : constant String := Tresses_Config.Resources_Linker_Section;\n")

    self._DeclareArrayTypes(f)
    # self._DeclareTables(f)
    # self._DeclareEntries(f)
    # self._DeclareAliases(f)
    self._CompileTables(f)
    f.write("end Tresses.Resources;\n")
    f.close()

  def GenerateCc(self):
    root = self._root
    file_name = os.path.join(self._root.target, 'tresses-resources.adb')
    f = file(file_name, 'wb')
    f.write(self._root.header + '\n\n')
    f.write("package body Tresses.Resources is\n")
    f.write("end Tresses.Resources;\n")
    f.close()


def Compile(path):
  # A hacky way of loading the py file passed as an argument as a module +
  # a descent along the module path.
  base_name = os.path.splitext(path)[0]
  sys.path += [os.path.abspath('.')]
  resource_module = __import__(base_name.replace('/', '.'))
  for part in base_name.split('/')[1:]:
    resource_module = getattr(resource_module, part)

  library = ResourceLibrary(resource_module)
  library.GenerateHeader()
  # library.GenerateCc()


def main(argv):
  for i in xrange(1, len(argv)):
    Compile(argv[i])


if __name__ == '__main__':
  main(sys.argv)
