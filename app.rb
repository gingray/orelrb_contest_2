require 'agoo'
require 'pry'
require 'oj'
require 'digest'

Agoo::Server.init(6464, 'root', {bind: 'tcp://0.0.0.0'})

class MyHandler
  def call(req)
    payload = Oj.load(req["rack.hijack"].body)
    payload['first_name'] = "#{payload['first_name']} #{Digest::MD5.hexdigest(payload['first_name'])}"
    payload['last_name'] = "#{payload['last_name']} #{Digest::MD5.hexdigest(payload['last_name'])}"
    payload['current_time'] = Time.now.strftime("%F %T %z")
    payload['say'] = 'Ruby is Dead 2'
    str = Oj.dump(payload)
    [ 200, {"Content-Type" => "application/json" }, [ str ]]
  end
end

handler = MyHandler.new
Agoo::Server.handle(:POST, "/", handler)
Agoo::Server.start()