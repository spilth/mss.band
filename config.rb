require 'pdf_generator'
require 'extensions/chords'

page '/*.json', layout: false
page 'songs/*', layout: 'song'

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :asset_hash
activate :directory_indexes
activate :chords

activate :s3_sync do |s3_sync|
  s3_sync.bucket = 'mss.nyc'
  s3_sync.acl    = 'public-read'
end

ignore 'songs/*.html.sng'
Dir.glob('source/songs/*.html.sng').each do |filename|
  contents = File.read(filename)
  song = SongPro.parse(contents)
  chords = song.sections.collect { |section| section.lines.collect { |line| line.parts.collect { |part| part.chord }}}.flatten.uniq.reject(&:empty?)
  proxy "/songs/#{song.title.parameterize}/index.html", '/songs/template.html', locals: { song: song, chords: chords}, ignore: true
end

activate :pdf_generator

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

activate :external_pipeline,
         name: :webpack,
         command: build? ?
                      'NODE_ENV=production ./node_modules/webpack/bin/webpack.js --bail -p' :
                      './node_modules/webpack/bin/webpack.js --watch -d --progress --color',
         source: 'tmp/dist',
         latency: 1

helpers do
  def pdf_songs
    Dir.glob('source/songs/*.html.sng').sort.collect do |filename|
      song = SongPro.parse(File.read(filename))
      {
          title: song.title,
          artist: song.artist,
          difficulty: song.custom[:difficulty],
          path: song.title.parameterize,
          short: song.custom[:short],
          ignore: song.custom[:ignore],
          spotify: song.custom[:spotify],
          order: song.custom[:order],
      }
    end.select! do |song|
      song[:order]
    end
  end

  def difficulty_text(difficulty)
    case difficulty
    when '0'
      'Beginner'
    when '1'
      'Easy'
    when '2'
      'Medium'
    when '3'
      'Hard'
    else
      'Unknown'
    end
  end
end
