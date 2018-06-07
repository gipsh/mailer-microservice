require 'sinatra/base'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require_relative "../workers/mail_worker.rb"

$stdout.sync = true


class App < Sinatra::Application

  get '/status' do
		stats = Sidekiq::Stats.new
		workers = Sidekiq::Workers.new
		"
		<p>Processed: #{stats.processed}</p>
		<p>In Progress: #{workers.size}</p>
		<p>Enqueued: #{stats.enqueued}</p>
		<p><a href='/'>Refresh</a></p>
		<p><a href='/add_job'>Add Job</a></p>
		<p><a href='/sidekiq'>Dashboard</a></p>
		"
  end

  post '/job' do
    content_type :json
    req = JSON.load(request.body.read.to_s)
    puts req
    # execute the job...
    jid = MailWorker.perform_async(req)
    { :job_id => jid }.to_json
    #status 200
  end
end




