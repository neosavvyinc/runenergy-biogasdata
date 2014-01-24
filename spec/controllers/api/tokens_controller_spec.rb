require 'spec_helper'

describe Api::TokensController do

  let :user do
    FactoryGirl.create(:user, :email => 'tomjames@comcast.net', :password => 'igotyournumber', :password_confirmation => 'igotyournumber')
  end

  describe 'create' do

    before(:each) do
      user.should_not be_nil
    end

    it 'should return an error with status 400 if the email is nil' do
      post :create, :password => '6789'
      response.status.should eq(400)
    end

    it 'should return an error with status 4oo if the password is nil' do
      post :create, :email => 'shortcheese@shortcheese.com'
      response.status.should eq(400)
    end

    it 'should respond with a status 401 if it does not find the user by email' do
      post :create, :email => 'shortcheese@shortcheese.com', :password => '6789'
      response.status.should eq(401)
    end

    it 'should create an authentication token for the user when it is assured the user exists' do
      post :create, :email => user.email, :password => user.password
      User.find(user.id).authentication_token.should_not be_nil
    end

    it 'should return a status 401 if the password is invalid' do
      post :create, :email => user.email, :password => 'somethingnotcorrect'
      response.status.should eq(401)
    end
    
    it 'should return the authentication token with a status 200 if the password is valid' do
      post :create, :email => user.email, :password => user.password
      response.status.should eq(200)
      JSON.parse(response.body)['token'].should eq(user.authentication_token)
    end

  end

  describe 'destroy' do

    it 'should return a 404 if it does not find the user it needs to destroy' do
      post :destroy, :authentication_token => '5446'
      response.status.should eq(404)
    end

    it 'should return a status 200 if the user is found via token' do
      post :destroy, :authentication_token => user.authentication_token
      response.status.should eq(200)
    end

    it 'should reset the users token and return the old one' do
      auth_token = user.authentication_token
      post :destroy, :authentication_token => user.authentication_token
      JSON.parse(response.body)['token'].should eq(auth_token)
      User.find(user.id).authentication_token.should_not eq(auth_token)
    end

  end
end