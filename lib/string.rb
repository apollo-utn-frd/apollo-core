# frozen_string_literal: true

class String
  RESERVED_WORDS = %w[
    about
    admin
    apollo
    auth
    authorization
    create
    comment
    contact
    delete
    destroy
    edit
    event
    favorite
    follower
    following
    help
    home
    image
    index
    me
    new
    notification
    place
    post
    rail
    root
    search
    show
    travel
    update
    user
  ].freeze

  def reserved?
    RESERVED_WORDS.include?(self.downcase.singularize)
  end
end
