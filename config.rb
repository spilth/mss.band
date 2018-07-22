require 'tilt'
require 'tilt/template'

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :directory_indexes

activate :s3_sync do |s3_sync|
  s3_sync.bucket = 'mss.nyc'
  s3_sync.acl    = 'public-read'
end

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

class ChordProTemplate < Tilt::Template
  self.default_mime_type = 'text/html'

  def prepare
    @output = nil
  end

  def evaluate(scope, locals, &block)
    @output ||= Chordpro.html(data)
  end

  def allows_script?
    false
  end
end

Tilt.register ChordProTemplate, 'crd'

