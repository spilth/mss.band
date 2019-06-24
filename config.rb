require 'pdf_generator'
require 'extensions/chords'

page '/*.json', layout: false
page 'songs/*', layout: 'song'

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :asset_hash, :exts => %w(.js .css)
activate :directory_indexes
activate :chords
activate :middleman_simple_thumbnailer

ignore 'songs/*.html.sng'
Dir.glob('source/songs/*.html.sng').each do |filename|
  contents = File.read(filename)
  song = SongPro.parse(contents)
  proxy "/songs/#{song.title.parameterize}/index.html", '/songs/template.html', locals: { song: song}, ignore: true
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
          year: song.year,
          key: song.key,
          tempo: song.tempo,
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
