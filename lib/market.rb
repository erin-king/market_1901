require 'pry'

class Market

  attr_reader :name,
              :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.check_stock(item) > 0
    end
  end

  def sorted_item_list
    item_list = []
    @vendors.each do |vendor|
      item_list << vendor.inventory.keys
    end
    item_list.flatten.uniq.sort
  end

  def total_inventory
    total_inventory_hash = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        total_inventory_hash[item] += amount
      end
    end
    total_inventory_hash
  end

  def sell(item, amount)
    remaining_inventory = 0
    total_inventory.keys.include?(item) && total_inventory[item] >= amount
    if total_inventory.keys.include?(item) && total_inventory[item] >= amount
      @vendors.each do |vendor|
        if remaining_inventory = vendor.inventory[item] -= amount
          if remaining_inventory < 0
            vendor.inventory[item] = 0
            amount = remaining_inventory.abs
          end
        end
      end
    end
  end

end
