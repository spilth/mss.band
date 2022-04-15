require 'pdf_generator'
require 'extensions/chords'

page 'songs/*.html.sng', layout: 'song'

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
  prefix.flexbox = true
end

activate :directory_indexes
activate :chords

ignore 'songs/*.html.sng'
Dir.glob('source/songs/*.html.sng').each do |filename|
  contents = File.read(filename)
  song = SongPro.parse(contents)
  proxy "/songs/#{song.title.parameterize}.html", '/songs/template.html', locals: { song: song, ukulele: false }, ignore: true
  proxy "/songs/#{song.title.parameterize}/guitar.html", '/songs/template.html', locals: { song: song, ukulele: false }, ignore: true
  proxy "/songs/#{song.title.parameterize}/ukulele.html", '/songs/template.html', locals: { song: song, ukulele: true }, ignore: true
end

activate :pdf_generator

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

helpers do
  def formatted_chord(chord)
    chord.gsub("sus4", "sus<sup>4</sup>").gsub("sus2", "sus<sup>2</sup>")
  end

  def pdf_songs
    Dir.glob('source/songs/*.html.sng').sort.collect do |filename|
      SongPro.parse(File.read(filename))
    end
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
    end
  end

  def difficulty_text(difficulty)
    case difficulty
    when '0'
      'B'
    when '1'
      'E'
    when '2'
      'M'
    when '3'
      'H'
    else
      '?'
    end
  end
end
