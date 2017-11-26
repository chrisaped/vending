class Product
  attr_accessor :name, :price, :quantity

  def initialize(name, price)
    @name = name
    @price = price
    @quantity = 2
  end

  def increase_quantity(quantity)
    if quantity > 0
      @quantity += quantity
    else
      puts "Incorrect quantity"
    end		
  end	
end