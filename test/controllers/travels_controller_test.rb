# frozen_string_literal: true

require 'test_helper'

class TravelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @params = {
      title: 'Título de prueba',
      description: 'Descripción de prueba',
      public: true,
      places: [
        {
          title: 'Primer lugar de prueba',
          description: 'Primera descripción de prueba',
          longitude: '-1.424242',
          latitude: '1.20001'
        },
        {
          title: 'Segundo lugar de prueba',
          description: 'Segunda descripción de prueba',
          longitude: '-3.424242',
          latitude: '3.20001'
        }
      ]
    }

    @public = travels(:public)
    @private = travels(:private)
    @mati = users(:mati)
    @fede = users(:fede)
    @juan = users(:juan)
  end

  test 'should show public travel' do
    get travel_path(@public), env: auth_env

    assert_response :ok

    response = response_body

    assert_equal response[:id], @public.format_id
    assert_equal response[:title], @public.title
    assert_equal response[:description], @public.description
    assert_equal response[:public], @public.publicx
    assert_equal response[:user][:id], @public.user.format_id
    assert_equal response[:favorites][:count], @public.favorites.count
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], @public.comments.count
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], @public.authorizations.count
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @public.places.count

    @public.places.each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place.title
      assert_equal response_place[:longitude], place.lng
      assert_equal response_place[:latitude], place.lat
    end
  end

  test 'should show public travel if user is not login' do
    get travel_path(@public)

    assert_response :ok

    response = response_body

    assert_equal response[:id], @public.format_id
    assert_equal response[:title], @public.title
    assert_equal response[:description], @public.description
    assert_equal response[:public], @public.publicx
    assert_equal response[:user][:id], @public.user.format_id
    assert_equal response[:favorites][:count], @public.favorites.count
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], @public.comments.count
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], @public.authorizations.count
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @public.places.count

    @public.places.each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place.title
      assert_equal response_place[:longitude], place.lng
      assert_equal response_place[:latitude], place.lat
    end
  end

  test 'should show private travel if was created by user' do
    get travel_path(@private), env: auth_env

    assert_response :ok

    response = response_body

    assert_equal response[:id], @private.format_id
    assert_equal response[:title], @private.title
    assert_equal response[:description], @private.description
    assert_equal response[:public], @private.publicx
    assert_equal response[:user][:id], @private.user.format_id
    assert_equal response[:favorites][:count], @private.favorites.count
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], @private.comments.count
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], @private.authorizations.count
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @private.places.count

    @private.places.each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place.title
      assert_equal response_place[:longitude], place.lng
      assert_equal response_place[:latitude], place.lat
    end
  end

  test 'should show private travel if was authorized' do
    get travel_path(@private), env: auth_env_as(@juan)

    assert_response :ok

    response = response_body

    assert_equal response[:id], @private.format_id
    assert_equal response[:title], @private.title
    assert_equal response[:description], @private.description
    assert_equal response[:public], @private.publicx
    assert_equal response[:user][:id], @private.user.format_id
    assert_equal response[:favorites][:count], @private.favorites.count
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], @private.comments.count
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], @private.authorizations.count
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @private.places.count

    @private.places.each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place.title
      assert_equal response_place[:longitude], place.lng
      assert_equal response_place[:latitude], place.lat
    end
  end

  test 'should not show private travel if was not authorized' do
    get travel_path(@private), env: auth_env_as(@fede)

    assert_response :not_found
  end

  test 'should not show travel if not exists' do
    get travel_path(1), env: auth_env

    assert_response :not_found
  end

  test 'should create public travel' do
    assert_difference('Travel.publicx.count') do
      post travels_path, env: auth_env,
                         params: @params
    end

    assert_response :created

    response = response_body

    assert_not_nil response[:id]
    assert_equal response[:title], @params[:title]
    assert_equal response[:description], @params[:description]
    assert_equal response[:public], @params[:public]
    assert_equal response[:user][:id], @mati.format_id
    assert_equal response[:favorites][:count], 0
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], 0
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], 0
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @params[:places].count

    @params[:places].each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place[:title]
      assert_equal response_place[:longitude].to_s, place[:longitude]
      assert_equal response_place[:latitude].to_s, place[:latitude]
    end

    travel = Travel.find(response[:id])

    assert_equal travel.title, @params[:title]
    assert_equal travel.description, @params[:description]
    assert_equal travel.publicx, @params[:public]
    assert_equal travel.user, @mati
    assert_equal travel.places.count, @params[:places].count

    travel.places.each_with_index do |place, index|
      params_place = @params[:places][index]

      assert_equal params_place[:title], place.title
      assert_equal params_place[:description], place.description
      assert_equal params_place[:longitude], place.lng.to_s
      assert_equal params_place[:latitude], place.lat.to_s
    end
  end

  test 'should create private travel with authorization with id' do
    @params[:public] = false
    @params[:authorizations] = [
      {
        id: @juan.format_id
      }
    ]

    assert_difference('Travel.privatex.count') do
      post travels_path, env: auth_env,
                         params: @params
    end

    assert_response :created

    response = response_body

    assert_not_nil response[:id]
    assert_equal response[:title], @params[:title]
    assert_equal response[:description], @params[:description]
    assert_equal response[:public], @params[:public]
    assert_equal response[:user][:id], @mati.format_id
    assert_equal response[:favorites][:count], 0
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], 0
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], 1
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @params[:places].count

    @params[:places].each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place[:title]
      assert_equal response_place[:longitude].to_s, place[:longitude]
      assert_equal response_place[:latitude].to_s, place[:latitude]
    end

    travel = Travel.find(response[:id])

    assert_equal travel.title, @params[:title]
    assert_equal travel.description, @params[:description]
    assert_equal travel.publicx, @params[:public]
    assert_equal travel.user, @mati
    assert travel.authorizations.first.user_id, @params[:authorizations].first[:id]
    assert_equal travel.places.count, @params[:places].count

    travel.places.each_with_index do |place, index|
      params_place = @params[:places][index]

      assert_equal params_place[:title], place.title
      assert_equal params_place[:description], place.description
      assert_equal params_place[:longitude], place.lng.to_s
      assert_equal params_place[:latitude], place.lat.to_s
    end
  end

  test 'should create private travel with authorization with username' do
    @params[:public] = false
    @params[:authorizations] = [
      {
        username: @juan.username
      }
    ]

    assert_difference('Travel.privatex.count') do
      post travels_path, env: auth_env,
                         params: @params
    end

    assert_response :created

    response = response_body

    assert_not_nil response[:id]
    assert_equal response[:title], @params[:title]
    assert_equal response[:description], @params[:description]
    assert_equal response[:public], @params[:public]
    assert_equal response[:user][:id], @mati.format_id
    assert_equal response[:favorites][:count], 0
    assert_not_nil response[:favorites][:href]
    assert_equal response[:comments][:count], 0
    assert_not_nil response[:comments][:href]
    assert_equal response[:authorizations][:count], 1
    assert_not_nil response[:authorizations][:href]
    assert_equal response[:places].count, @params[:places].count

    @params[:places].each_with_index do |place, index|
      response_place = response[:places][index]

      assert_equal response_place[:title], place[:title]
      assert_equal response_place[:longitude].to_s, place[:longitude]
      assert_equal response_place[:latitude].to_s, place[:latitude]
    end

    travel = Travel.find(response[:id])

    assert_equal travel.title, @params[:title]
    assert_equal travel.description, @params[:description]
    assert_equal travel.publicx, @params[:public]
    assert_equal travel.user, @mati
    assert travel.authorizations.first.user_id, @params[:authorizations].first[:id]
    assert_equal travel.places.count, @params[:places].count

    travel.places.each_with_index do |place, index|
      params_place = @params[:places][index]

      assert_equal params_place[:title], place.title
      assert_equal params_place[:description], place.description
      assert_equal params_place[:longitude], place.lng.to_s
      assert_equal params_place[:latitude], place.lat.to_s
    end
  end

  test 'should not create private travel if any user not exists' do
    @params[:public] = false
    @params[:authorizations] = [
      {
        username: 'not exits'
      }
    ]

    assert_no_difference('Travel.privatex.count') do
      post travels_path, env: auth_env,
                         params: @params
    end

    assert_response :not_found
  end

  test 'should not create private travel if any user not follow to login user' do
    @params[:public] = false
    @params[:authorizations] = [
      {
        username: @fede.username
      }
    ]

    assert_no_difference('Travel.privatex.count') do
      post travels_path, env: auth_env,
                         params: @params
    end

    assert_response :unprocessable_entity
  end

  test 'should destroy travel' do
    assert_difference('Travel.count', -1) do
      delete travel_path(@public.id), env: auth_env
    end

    assert_response :no_content

    refute Travel.exists?(id: @public.id)
  end

  test 'should not destroy travel if user is not the creator of travel' do
    assert_no_difference('Travel.count') do
      delete travel_path(@public.id), env: auth_env_as(@fede)
    end

    assert_response :forbidden

    assert Travel.exists?(id: @public.id)
  end
end
