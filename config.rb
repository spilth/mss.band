require 'extensions/chords'
require 'pdf_generator'

DIFFICULTY_WORDS = %w(Beginner Easy Medium Hard).freeze

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
  prefix.flexbox = true
end
activate :chords
activate :directory_indexes
activate :pdf_generator

set :haml, { escape_html: false }

page 'songs/*', layout: 'song'
ignore 'songs/*.html.sng'

Dir.glob('source/songs/*.html.sng').each do |filename|
  song = SongPro.parse(File.read(filename))
  html_path = song.title.gsub(/[^\w\s]/i, '').parameterize

  proxy "/songs/#{html_path}.html", '/songs/template.html', locals: { song: song, ukulele: false }, ignore: true
  proxy "/songs/#{html_path}/guitar.html", '/songs/template.html', locals: { song: song, ukulele: false }, ignore: true
  proxy "/songs/#{html_path}/ukulele.html", '/songs/template.html', locals: { song: song, ukulele: true }, ignore: true
end

helpers do
  def formatted_chord(chord)
    chord.gsub("sus4", "sus<sup>4</sup>").gsub("sus2", "sus<sup>2</sup>")
  end

  def pdf_songs
    Dir.glob('source/songs/*.html.sng').sort.collect { |filename| SongPro.parse(File.read(filename)) }
  end

  def difficulty_label(difficulty)
    case difficulty
    when '0'
      '<span class="badge badge-primary">B<span class="d-none d-md-inline">eginner</span></span>'
    when '1'
      '<span class="badge badge-success">E<span class="d-none d-md-inline">asy</span></span>'
    when '2'
      '<span class="badge badge-warning">M<span class="d-none d-md-inline">edium</span></span>'
    when '3'
      '<span class="badge badge-danger">H<span class="d-none d-md-inline">ard</span></span>'
    else
      '?'
    end
  end

  def difficulty_text(difficulty)
    DIFFICULTY_WORDS[difficulty.to_i]
  end
end
