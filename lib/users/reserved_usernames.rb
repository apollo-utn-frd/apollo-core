# frozen_string_literal: true

module ReservedUsernames
  module_function

  LIST = %w[
    about
    admin
    apollo
    auth
    authorization
    blog
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
    login
    logout
    me
    new
    notification
    place
    post
    rail
    root
    search
    show
    signin
    term
    travel
    update
    user
  ].freeze

  def include?(username)
    LIST.include?(username.downcase.singularize)
  end
end
