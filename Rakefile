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
