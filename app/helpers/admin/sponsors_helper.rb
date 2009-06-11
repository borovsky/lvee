module Admin
  module SponsorsHelper
    def sponsor_type_form_column(record, input_name)
      types = SPONSOR_TYPES.map{|e| e.first}
      select "record", "sponsor_type", types
    end

  end
end
