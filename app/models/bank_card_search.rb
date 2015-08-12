class BankCardSearch
  def self.search q = {}
    # These fields are special
    page = q.delete(:page) || 1
    per_page = q.delete(:per_page) || 10

    search_text = q[:search] || ""
    # order_sym = q[:order].try(:to_sym)

    # Perform the search
    s = BankCard.search do
      paginate page: page, per_page: per_page
      
      fulltext search_text if search_text.present?

      # if order_sym == :votes_up
      #   order_by :votes_up, :desc
      # end
    end

    s.results
  end
end