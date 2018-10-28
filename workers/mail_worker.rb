require 'sidekiq'
require 'net/smtp'
require 'erb'
require 'zaru'


class MailWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailer', retry: false, backtrace: true

#  settings = YAML.load(File.read("#{Dir.pwd}/config/config.yml"))
  settings = YAML.load(ERB.new(File.read("#{Dir.pwd}/config/config.yml")).result)



  # TODO: use any smtp based on a arg[:stmp] or default
  $smtp_label = 'aws'
  $smtp_host = settings['smtp'][$smtp_label]['host']
  $smtp_user = settings['smtp'][$smtp_label]['user'] 
  $smtp_pass = settings['smtp'][$smtp_label]['pass']
  $smtp_port = settings['smtp'][$smtp_label]['port'] 
  $smtp_domain = settings['smtp'][$smtp_label]['domain'] 

  
  def perform(args)
    puts args
    puts args['params']
    template_name = Zaru.sanitize! args['params']['template'] 
    if File.file?("#{Dir.pwd}/templates/#{template_name}") 
      send_mail(args['params']['to'], args['params']['from'], args['params']['subject'] ,args['params'], "#{Dir.pwd}/templates/#{template_name}")
    else
      puts "Teamplate not found [#{Dir.pwd}/templates/#{template_name}]"		
    end
  end

 def send_mail(mailto, mailfrom, mailsubject, args, template_file)
        b = binding

        from = mailfrom
        to = mailto
	subject = mailsubject
        params = args

	# render the mail template 
        template = File.read(template_file)

        renderer = ERB.new(template)
        output = renderer.result(b)

	# send mail 
        smtp = Net::SMTP.new $smtp_host, $smtp_port 
        smtp.enable_starttls
        smtp.start($smtp_domain, $smtp_user, $smtp_pass, :login) do
           smtp.send_message(output, from, to)
        end
  end


end
