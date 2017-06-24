# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :set_comment, except: [:search]

  def show
    render json: @comment
  end

  def search
    query = params.fetch(:query, '')
    search = Comment.search(query)

    render json: search.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  private

  def set_comment
    comment_id = params[:id] || params[:comment_id]

    @comment = Comment.find(comment_id)

    unless @comment.readable?(current_user)
      raise ActiveRecord::RecordNotFound.new(nil, Comment, :id, comment_id)
    end

    @comment
  end
end
