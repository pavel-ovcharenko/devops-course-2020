raise unless RUBY_VERSION == '2.6.0'
Dir.glob(File.dirname(__FILE__) + '/vendor/gems/*').each do |path|
  $LOAD_PATH << path + '/lib/'
end
%w[sinatra pg redis].each { |gem| require gem }
set :bind, '0.0.0.0'

get('/') { 'ruby: ok' }
get('/db?') do
  begin
    result = PG.connect(ENV['DB']).exec('SELECT 1 AS one')[0] == { 'one' => '1' }
  rescue => e
    puts e
    result = false
  end
  "db: #{result ? 'ok' : 'error'}"
end

get('/cache?') do
  begin
    Redis.new(url: ENV['CACHE']).set('test', 'value')
    result = Redis.new(url: ENV['CACHE']).get('test') == 'value'
  rescue => e
    puts e
    result = false
  end
  "cache: #{result ? 'ok' : 'error'}"
end
