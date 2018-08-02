require "socket"

def parse_request(request_line)
  http_method, url = request_line.split(' ')
  path, query_string = url.split('?')

  unless query_string.nil?
    params = query_string.split('&')
                         .map { |param| param.split('=') }
                         .to_h
  else
    params = {}
  end

  [http_method, path, params]
end

server = TCPServer.new("", 3333)
loop do
  client = server.accept
  request_line = client.gets

  method, path, params = parse_request(request_line)

  # Server Terminal Output
  puts "Request received..."
  puts "==================="
  puts "Method: #{method}"
  puts "Path: #{path}"
  puts "Params: #{params}"
  puts

  # Client Response
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/plain\r\n\r\n"

  params["rolls"].to_i.times do
    sides = params["sides"].to_i
    client.puts rand(sides) + 1
  end

  client.close
end
