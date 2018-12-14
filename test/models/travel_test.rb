# frozen_string_literal: true

require 'test_helper'

class TravelTest < ActiveSupport::TestCase
  setup do
    @mati = users(:mati)
    @fede = users(:fede)
    @juan = users(:juan)

    @public = travels(:public)
    @private = travels(:private)
    @atlantis = travels(:atlantis)

    @params = {
      user: @mati,
      title: 'Un nuevo viaje',
      description: 'Viaje por el mundo',
      places_attributes: [
        {
          title: 'Un lugar',
          description: 'Una description',
          coordinates: "POINT(1.1111 1.1111)"
        }
      ]
    }
  end

  test 'has_many authorizations' do
    assert_equal :has_many, Travel.reflect_on_association(:authorizations).macro
  end

  test 'has_many comments' do
    assert_equal :has_many, Travel.reflect_on_association(:comments).macro
  end

  test 'has_many favorites' do
    assert_equal :has_many, Travel.reflect_on_association(:favorites).macro
  end

  test 'has_many places' do
    assert_equal :has_many, Travel.reflect_on_association(:places).macro
  end

  test 'should create travel' do
    assert_difference('Travel.count') do
      Travel.create!(@params)
    end

    assert Travel.exists?(title: @params.fetch(:title))
  end

  test 'should create private travel' do
    @params[:publicx] = false

    assert_difference('Travel.count') do
      Travel.create!(@params)
    end

    assert Travel.exists?(title: @params.fetch(:title))
  end

  test 'should not create user without user' do
    @params.delete(:user)

    assert_no_difference('Travel.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Travel.create!(@params)
      end
    end

    refute Travel.exists?(title: @params.fetch(:title))
  end

  test 'should not create user without title' do
    @params.delete(:title)

    assert_no_difference('Travel.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Travel.create!(@params)
      end
    end
  end

  test 'should not create user with title too short' do
    @params[:title] = 'T'

    assert_no_difference('Travel.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Travel.create!(@params)
      end
    end
  end

  test 'should not create user with title too long' do
    @params[:title] = 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'

    assert_no_difference('Travel.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Travel.create!(@params)
      end
    end
  end

  test 'should not create user without places' do
    @params.delete(:places_attributes)

    assert_no_difference('Travel.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Travel.create!(@params)
      end
    end

    refute Travel.exists?(title: @params.fetch(:title))
  end

  test 'manageable? should be true if user is travel author' do
    assert @private.manageable?(@mati)
  end

  test 'manageable? should be false if user is not travel author' do
    refute @private.manageable?(@juan)
  end
end
