# frozen_string_literal: true

require 'sdoc'
require 'rdoc/task'

##
# Rake task for generating documentation.
# It specifies default options like directory, files to include.
# See readme for usage.
#
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'app/', 'lib/')

  # Uncomment to print detailed statistics in console.
  # It skips creating docs, so do not commit uncommented!
  #
  # rdoc.options << '-C'
end
