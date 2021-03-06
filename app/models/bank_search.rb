class BankSearch
  def self.search q = {}
    # These fields are special
    page = q.delete(:page) || 1
    per_page = q.delete(:per_page) || 10
    search_text = q[:search] || ""

    # Perform the search
    s = Bank.search do
      paginate page: page, per_page: per_page
      fulltext search_text if search_text.present?
    end

    s.results
  end
end