# frozen_string_literal: true

module Enumerable
  def readables(user)
    select { |rsc| rsc.readable?(user) }
  end

  def paginate_by(params)
    paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end
end
