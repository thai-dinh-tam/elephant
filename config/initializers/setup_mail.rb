ActionMailer::Base.smtp_settings = {
        :address              => "mail.go-elephant.com",
        :port                 => 587,
        :domain               => "www.go-elephant.com",
        :user_name            => "no-reply@go-elephant.com",
        :password             => "jEFC5%Za",
        :authentication       => "plain",
        :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "www.go-elephant.com" if Rails.env.production?
ActionMailer::Base.default_url_options[:host] = "localhost:3000" if Rails.env.development?
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?