module Paginated
  extend ActiveSupport::Concern

  included do
  end

  def paginate(scope)
    per_page = params.fetch(:per_page, 20).to_i
    page     = params.fetch(:page, 1).to_i
    offset   = (page - 1) * per_page

    scope.limit(per_page).offset(offset)
  end
end
