# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, except: %i[search]

  def show
    render :show
  end

  def search
    @comments = Comment.search(search_params).order(created_at: :desc)

    render :index
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

  def search_params
    params.fetch(:query, '')
  end
end
