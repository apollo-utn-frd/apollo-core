# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @mati = users(:mati)
    @fede = users(:fede)
    @juan = users(:juan)

    @public = travels(:public)
    @private = travels(:private)
    @atlantis = travels(:atlantis)

    @params = {
      user: @mati,
      content: 'Un nuevo viaje',
      travel: @public
    }
  end

  test 'belongs_to users' do
    assert_equal :belongs_to, Comment.reflect_on_association(:user).macro
  end

  test 'belongs_to travels' do
    assert_equal :belongs_to, Comment.reflect_on_association(:travel).macro
  end

  test 'should create comment' do
    assert_difference('Comment.count') do
      Comment.create!(@params)
    end

    assert Comment.exists?(content: @params.fetch(:content))
  end

  test 'should not create without user' do
    @params.delete(:travel)

    assert_no_difference('Comment.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Comment.create!(@params)
      end
    end

    refute Comment.exists?(content: @params.fetch(:content))
  end

  test 'should not create without travel' do
    @params.delete(:user)

    assert_no_difference('Comment.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Comment.create!(@params)
      end
    end

    refute Comment.exists?(content: @params.fetch(:content))
  end

  test 'should not create without content' do
    @params.delete(:content)

    assert_no_difference('Comment.count') do
      assert_raise ActiveRecord::RecordInvalid do
        Comment.create!(@params)
      end
    end
  end
end
