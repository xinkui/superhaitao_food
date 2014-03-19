class ValueAddedService < ActiveRecord::Base

  #add audit support
  include Auditable

  belongs_to :order

  def get_service_name
    case name
      when 'firm_package' then '加固包装'
      when 'balloon' then '气柱'
      when 'warehouse_charges' then '仓储费用'
    end
  end

end
