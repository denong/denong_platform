class BankCardTypeSearch
  def self.search q = {}

    page = q.delete(:page) || 1
    per_page = q.delete(:per_page) || 10
    search_text = q[:search] || ""
    bank_card_type = q[:bank_card_type] || 0

    s = BankCardType.search do
      paginate page: page, per_page: per_page
      
      fulltext search_text if search_text.present?
      with :bank_card_type, bank_card_type
    end

    s.results

  end
end