class EchoEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  post '/' do
    result 200, 'Echo Success Response'
  end

  post '/echo' do
    @payload.each do |key, value|
      add_value key, value
    end

    result 200
  end

  post '/fail' do
    result 500, 'Echo Fail Response'
  end

  post '/ready' do
    code = 500
    summary = 'Payload was not very interesting.'

    @payload.each do |key, value|
      next if %w{request_id parameters}.include? key

      if value.is_a? Hash
        if value['status'] == 'ready'
          code = 200
          summary = "The '#{key}' object is ready!"
        else
          code = 500
          summary = "The '#{key}' object is invalid for this action, it's 'status' MUST be 'ready', but it WAS '#{value['status']}'."
        end
      else
        code = 500
        summary = "The '#{key}' must be an object, and it was a #{value.class}."
      end
    end

    result code, summary
  end
end
