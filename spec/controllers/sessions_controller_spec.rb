require 'spec_helper'

describe SessionsController do
  let!(:user){ create :user, userid:'batman', email:'batman@marvel.com', password:'secret' }

  def send_post(login, password='secret')
    post :create, login:login, password:password
  end

  describe "#create" do
    context "login with userid" do
      before{ send_post 'batman'} 

      describe "response" do
        subject{ response }
        it{ should redirect_to root_url }
      end

      describe "flash" do
        subject{ flash }
        its(:notice){ should eq 'Logged in' }
      end
    end

    context "error" do
      context "login is incorrect" do
        before{ send_post 'robin'} 

        describe "response" do
          subject{ response }
          it{ should render_template :new } 
        end

        describe "flash" do
          subject{ flash }
          its(:alert){ should eq 'Invalid login or password' } 
        end
      end

      context "password is incorrect" do
        before{ send_post 'batman', 'wrong'} 

        describe "response" do
          subject{ response }
          it{ should render_template :new } 
        end

        describe "flash" do
          subject{ flash }
          its(:alert){ should eq 'Invalid login or password' } 
        end
      end
    end

    context "login with email" do
      before{ send_post 'batman@marvel.com'} 

      describe "flash" do
        subject{ flash }
        its(:notice){ should eq 'Logged in' }
      end
    end
  end  

  controller_actions = controller_actions("sessions")

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      it "should not reach the #{action} page" do
        send(req, action)
        response.redirect_url.should_not eq login_url 
      end
    end
  end

  context "a user is logged in as" do
    describe "member" do
      before(:each) do
        session[:userid] = create_member.id
      end

      controller_actions.each do |action,req|
        it "should reach the #{action} page" do
          send(req, action)
          response.redirect_url.should_not eq welcome_url
        end
      end
    end 
  end
end
