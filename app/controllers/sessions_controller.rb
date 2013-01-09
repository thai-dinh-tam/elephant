class SessionsController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def new
        flash[:error] = "Please login"
        redirect_to root_path
    end

    def create

        puts "creating new session..........................."

        user = User.find_by_email(params[:session][:email].strip.downcase)
        puts params[:session][:email].strip.downcase
        puts params[:session][:password]
        if user && user.authenticate(params[:session][:password])
            response.headers['X-CSRF-Token'] = form_authenticity_token
            respond_to do |format|
                format.html {
                    puts "html..................."
                    if user.create_password?
                        redirect_to update_password_path(email: user.email), :flash => {:error => "Please create a password"}
                    else
                        sign_in(user, params[:session]["stay_logged_in"] == "1")
                        redirect_to root_path
                    end
                }
                format.xml {
                    puts "xml..................."
                    sign_in(user, params[:session]["stay_logged_in"] == "1")
                    render xml: user, except: [ :created_at, :updated_at, :password_digest, :remember_token, :elephant_admin, :create_password ]
                }
            end
        else
            puts "not authenticated..................."
            redirect_to root_path, :flash => {:error => "Invalid email/password combination"}
        end
    end

    def destroy
        sign_out
        redirect_to root_url
    end

    def edit

    end

    def update
        current_password = params[:session][:current_password]
        params[:session].delete(:current_password)

        user = User.find_by_email(params[:session][:email].strip.downcase)
        if user && user.authenticate(current_password)
            user.password = params[:session][:password]
            user.password_confirmation = params[:session][:password_confirmation]
            user.create_password = false
            if user.save
                flash[:success] = "Password updated"
                sign_in(user, true)
                redirect_to root_path
            else
                redirect_to update_password_path(email: user.email), :flash => {:error => "Passwords do not match"}
            end
        else
            render "edit", :flash => {:error => "Invalid email/password combination"}
        end
    end

    def reset_password
        if params[:session]
            @email = params[:session][:email].strip.downcase
            @user = User.find_by_email(@email)

            if @user

                password = SecureRandom.urlsafe_base64[1..7]
                @user.password = password
                @user.password_confirmation = password
                @user.create_password = true

                if @user.save
                    flash[:success] = "Email sent to " + @email
                    @user.delay.send_reset_password_email(password)
                end
            else
                flash[:error] = "Could not find user with that email"
            end

            redirect_to reset_password_path
        end
    end


end
