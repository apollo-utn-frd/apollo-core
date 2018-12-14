# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @mati = users(:mati)
    @fede = users(:fede)
    @juan = users(:juan)

    @public = travels(:public)
    @private = travels(:private)
    @atlantis = travels(:atlantis)

    @params = {
      username: 'lionel',
      email: 'lionel@apollo.com.ar',
      name: 'Lionel',
      lastname: 'Fuentes',
      google_id: 'G0099'
    }
  end

  test 'has_many authorizations' do
    assert_equal :has_many, User.reflect_on_association(:authorizations).macro
  end

  test 'has_many comments' do
    assert_equal :has_many, User.reflect_on_association(:comments).macro
  end

  test 'has_many favorites' do
    assert_equal :has_many, User.reflect_on_association(:favorites).macro
  end

  test 'has_many travels' do
    assert_equal :has_many, User.reflect_on_association(:travels).macro
  end

  test 'has_many notifications' do
    assert_equal :has_many, User.reflect_on_association(:notifications).macro
  end

  test 'has_many followers' do
    assert_equal :has_many, User.reflect_on_association(:followers).macro
  end

  test 'has_many followings' do
    assert_equal :has_many, User.reflect_on_association(:followings).macro
  end

  test 'should create user' do
    assert_difference('User.count') do
      User.create!(@params)
    end

    assert User.exists?(email: @params.fetch(:email))
  end

  test 'should create user and set username if params dont include username' do
    @params.delete(:username)

    assert_difference('User.count') do
      User.create!(@params)
    end

    assert User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user with reserved username' do
    @params[:username] = 'show'

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user with invalid username' do
    @params[:username] = 'li@nel'

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user with duplicated username' do
    @params[:username] = @mati.username

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user without email' do
    @params.delete(:email)

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(name: @params.fetch(:name))
  end

  test 'should not create user with duplicated email' do
    @params[:email] = @mati.email

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(name: @params.fetch(:name))
  end

  test 'should not create user without name' do
    @params.delete(:name)

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user with name too short' do
    @params[:name] = 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user without lastname' do
    @params.delete(:lastname)

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'should not create user with lastname too long' do
    @params[:lastname] = 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'

    assert_no_difference('User.count') do
      assert_raise ActiveRecord::RecordInvalid do
        User.create!(@params)
      end
    end

    refute User.exists?(email: @params.fetch(:email))
  end

  test 'follow? should be true when user follow another' do
    assert @juan.follow?(@mati)
  end

  test 'follow? should be false when user dont follow another' do
    refute @mati.follow?(@juan)
  end

  test 'follow! should create following' do
    refute @mati.follow?(@juan)

    assert_difference('Following.count') do
      @mati.follow!(@juan)
    end

    assert @mati.follow?(@juan)
  end

  test 'follow! should dont create following if user already follow to another' do
    assert @juan.follow?(@mati)

    assert_no_difference('Following.count') do
      @juan.follow!(@mati)
    end

    assert @juan.follow?(@mati)
  end

  test 'follow! should dont create following if user follow itself' do
    assert_no_difference('Following.count') do
      assert_raise ActiveRecord::RecordInvalid do
        @juan.follow!(@juan)
      end
    end

    refute @juan.follow?(@juan)
  end

  test 'comment! should create comment if travel is public' do
    assert_difference('Comment.count') do
      @juan.comment!(@public, 'Es muy bueno')
    end

    assert @juan.comment?(@public)
  end

  test 'comment! should create comment if travel is private and has authorization' do
    assert_difference('Comment.count') do
      @juan.comment!(@private, 'Es muy bueno')
    end

    assert @juan.comment?(@private)
  end

  test 'comment! should not create comment if travel is private and has not authorization' do
    assert_no_difference('Comment.count') do
      assert_raise ActiveRecord::RecordInvalid do
        @fede.comment!(@atlantis, 'Es muy bueno')
      end
    end

    refute @fede.comment?(@atlantis)
  end

  test 'manageable? should be true if user is itself' do
    assert @juan.manageable?(@juan)
  end

  test 'manageable? should be false if user is not itself' do
    refute @juan.manageable?(@mati)
  end

  test 'posts should return user posts' do
    assert @juan.posts
  end

  test 'home_posts should return user home posts' do
    assert @juan.home_posts
  end
end
