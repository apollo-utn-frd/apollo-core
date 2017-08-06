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
    config
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
    html
    image
    index
    jpg
    json
    login
    logout
    me
    new
    notification
    place
    png
    post
    private
    profile
    public
    rail
    robot
    root
    search
    show
    signin
    signup
    term
    thumb
    thumbnail
    txt
    travel
    update
    user
    username
    validate
  ].freeze

  def include?(username)
    LIST.include?(username.downcase.singularize)
  end
end
