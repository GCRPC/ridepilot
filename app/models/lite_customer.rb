class LiteCustomer < ApplicationRecord

  belongs_to :provider

  scope :for_provider,  -> (provider_id) { where(provider_id: provider_id) }

  def self.by_term( term, limit = nil )
    return LiteCustomer if term.blank?

    if term.match /^[a-z]+$/i
      #a single word, either a first or a last name
      query, args = make_customer_name_query("first_name", term)
      lnquery, lnargs = make_customer_name_query("last_name", term)
      query += " or " + lnquery
      args += lnargs
    elsif term.match /^[a-z]+[ ,]\s*$/i
      comma = term.index(",")
      #a single word, either a first or a last name, complete
      term.gsub!(",", "")
      term = term.strip
      if comma
        query, args = make_customer_name_query("last_name", term, :complete)
      else
        query, args = make_customer_name_query("first_name", term, :complete)
      end

    elsif term.match /^[a-z]+\s+[a-z]{2,}$/i
      #a first name followed by two or more letters of a last name

      first_name, last_name = term.split(" ").map(&:strip)

      query, args = make_customer_name_query("first_name", first_name, :complete)
      lnquery, lnargs = make_customer_name_query("last_name", last_name)
      query += " and " + lnquery
      args += lnargs
    elsif term.match /^[a-z]+\s*,\s*[a-z]+$/i
      #a last name, a comma, some or all of a first name

      last_name, first_name = term.split(",").map(&:strip)

      query, args = make_customer_name_query("last_name", last_name, :complete)
      fnquery, fnargs = make_customer_name_query("first_name", first_name)
      query += " and " + fnquery
      args += fnargs
    else
      # the final catch-all
      query, args = make_customer_name_query("first_name", term)
      lnquery, lnargs = make_customer_name_query("last_name", term)
      query += " or " + lnquery
      args += lnargs
    end

    conditions = [query] + args
    customers  = where(conditions)

    limit ? customers.limit(limit) : customers
  end

  def self.make_customer_name_query(field, value, option=nil)
    value = value.downcase
    like  = "#{value}%"
    if option == :initial
      return "(LOWER(%s) = ?)" % field, [value]
    elsif option == :complete
      return "(LOWER(%s) = ? or LOWER(%s) LIKE ? )" % [field, field], [value, like]
    else
      return "(LOWER(%s) like ?)" % [field], [like]
    end
  end

  def group
    return false
  end

  def message
    return ""
  end

  def name
    return "%s %s" % [first_name, last_name]
  end

  def as_autocomplete
    {
      :label                     => name,
      :id                        => id,
      :group                     => group,
      :message                   => message.try(:strip)
    }
  end

end