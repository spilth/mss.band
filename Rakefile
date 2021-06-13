desc 'Run the Middleman Server'
task :server do
  system 'bundle exec middleman server'
end

desc 'Clean out build directory'
task :clean do
  system 'rm -rf build'
end

desc 'Build the static site'
task :build do
  system 'bundle exec middleman build'
end

desc 'Deploy site to Netlify'
task :deploy do
  system 'netlify deploy --prod --dir=build'
end

desc 'Alphabetically re-order songs'
task :sort do
  filenames = Dir.glob('source/songs/*.html.sng').sort
  filenames.each_with_index do |filename, index|
    content = File.read(filename)
    new_content = content.gsub(/\!order=\d+/, "!order=#{index + 1}")
    File.open(filename, "w") { |file| file.puts new_content }
  end
end