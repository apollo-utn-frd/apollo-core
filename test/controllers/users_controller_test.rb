# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @params = {
      name: 'Mati',
      lastname: 'as'
    }

    @mati = users(:mati)
    @fede = users(:fede)
    @juan = users(:juan)
  end

  test 'should show public profile of user' do
    get user_path(@fede), env: auth_env,
                          as: :json

    assert_response :ok

    response = response_body

    assert_equal response[:id], @fede.format_id
    assert_equal response[:username], @fede.username
    assert_equal response[:name], @fede.name
    assert_equal response[:lastname], @fede.lastname
    assert_equal response[:image_url], @fede.image_public_default_url
    assert_equal response[:thumbnail_url], @fede.thumbnail_public_default_url
    assert_not response.key?(:email)
    assert_not response.key?(:confirmed)
    assert_not response.key?(:authorizations)
  end

  test 'should show private profile of user' do
    get user_path(@mati), env: auth_env,
                          as: :json

    assert_response :ok

    response = response_body

    assert_equal response[:id], @mati.format_id
    assert_equal response[:username], @mati.username
    assert_equal response[:name], @mati.name
    assert_equal response[:lastname], @mati.lastname
    assert_equal response[:image_url], @mati.image_public_default_url
    assert_equal response[:thumbnail_url], @mati.thumbnail_public_default_url
    assert_equal response[:email], @mati.email
    assert_equal response[:confirmed], @mati.confirmed
    assert_equal response.dig(:authorizations, :count), @mati.authorizations.length
    assert_equal response.dig(:authorizations, :href), user_authorizations_path(@mati.format_id)
  end

  test 'should update user if it is login' do
    put user_path(@mati), env: auth_env,
                          params: @params,
                          as: :json

    assert_response :ok

    response = response_body

    assert_equal response[:id], @mati.format_id
    assert_equal response[:username], @mati.username
    assert_equal response[:name], @params[:name]
    assert_equal response[:lastname], @params[:lastname]
    assert_equal response[:image_url], @mati.image_public_default_url
    assert_equal response[:thumbnail_url], @mati.thumbnail_public_default_url
    assert_equal response[:email], @mati.email
    assert_equal response[:confirmed], @mati.confirmed
    assert_equal response.dig(:authorizations, :count), @mati.authorizations.length
    assert_equal response.dig(:authorizations, :href), user_authorizations_path(@mati.format_id)

    @mati.reload

    assert_equal @mati.name, @params[:name]
    assert_equal @mati.lastname, @params[:lastname]
  end

  test 'should not update user if it is not login' do
    put user_path(@fede), env: auth_env,
                          params: @params,
                          as: :json

    assert_response :forbidden

    @fede.reload

    assert_equal @fede.name, 'Federico'
    assert_equal @fede.lastname, 'Sanches'
  end

  test 'should show travels' do
    get user_travels_path(@fede), env: auth_env,
                                  as: :json

    assert_response :ok

    response = response_body

    assert_not_equal response.size, 0
    assert response.size, @fede.travels.readables(@mati).length

    response_travel = response.first
    travel = Travel.find(response_travel[:id])

    assert_equal response_travel[:id], travel.format_id
    assert_equal response_travel[:title], travel.title
    assert_equal response_travel[:description], travel.description
    assert_equal response_travel[:public], travel.publicx
    assert_equal response_travel[:user][:id], @fede.format_id
    assert_equal response_travel[:places].count, travel.places.count

    travel.places.each_with_index do |place, index|
      response_place = response_travel[:places][index]

      assert_equal response_place[:title], place.title
      assert_equal response_place[:longitude], place.lng
      assert_equal response_place[:latitude], place.lat
    end
  end

  test 'should show authorizations of user if it is login' do
    get user_authorizations_path(@juan), env: auth_env_as(@juan),
                                         as: :json

    assert_response :ok

    response = response_body

    assert_not_equal response.size, 0
    assert response.size, @juan.authorizations.length

    response_authorization = response.first

    assert Authorization.find_by(
      user_id: @juan.id,
      travel_id: response_authorization[:travel][:id]
    )
  end

  test 'should not show authorizations of user if it is not login' do
    get user_authorizations_path(@juan), env: auth_env,
                                         as: :json

    assert_response :forbidden
  end

  test 'should show favorites' do
    get user_favorites_path(@juan), env: auth_env_as(@juan),
                                    as: :json

    assert_response :ok

    response = response_body

    assert_not_equal response.size, 0
    assert response.size, @juan.favorites.length

    response_favorite = response.first

    assert Favorite.find_by(
      user_id: @juan.id,
      travel_id: response_favorite[:travel][:id]
    )
  end

  test 'should show followings' do
    get user_followings_path(@juan), env: auth_env_as(@juan),
                                     as: :json

    assert_response :ok

    response = response_body

    assert_not_equal response.size, 0
    assert response.size, @juan.followings.length

    response_followings = response.first

    assert Following.exists?(
      follower_id: @juan.id,
      following_id: response_followings[:following][:id]
    )
  end

  test 'should show followers' do
    get user_followers_path(@juan), env: auth_env_as(@juan),
                                    as: :json

    assert_response :ok

    response = response_body

    assert_not_equal response.size, 0
    assert response.size, @juan.followers.length

    response_followings = response.first

    assert Following.exists?(
      follower_id: response_followings[:follower][:id],
      following_id: @juan.id
    )
  end

  test 'should follow user' do
    assert_difference('Following.count') do
      post user_followers_path(@juan), env: auth_env,
                                       as: :json
    end

    assert_response :ok

    response = response_body

    assert response[:follower][:id], @mati.format_id
    assert response[:following][:id], @juan.format_id

    assert Following.exists?(
      follower_id: @mati.id,
      following_id: @juan.id
    )
  end

  test 'should unfollow user' do
    assert_difference('Following.count', -1) do
      delete user_followers_path(@mati), env: auth_env_as(@juan),
                                         as: :json
    end

    assert_response :no_content

    assert_not Following.exists?(
      follower_id: @juan.id,
      following_id: @mati.id
    )
  end

  test 'should not follow himself' do
    assert_no_difference('Following.count') do
      post user_followers_path(@mati), env: auth_env,
                                       as: :json
    end

    assert_response :unprocessable_entity

    assert_not Following.exists?(
      follower_id: @mati.id,
      following_id: @mati.id
    )
  end
end
