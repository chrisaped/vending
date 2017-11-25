class Product
  attr_accessor :name, :price, :quantity

  def initialize(name, price)
	  @name = name
	  @price = price
	  @quantity = 2
  end

  def increase_quantity
    puts "Please enter the new quantity of this product."
    quantity = gets.chomp.to_i
    if quantity > 0
      @quantity += quantity
      puts "Your product's quantity has been updated!"
      puts "#{@name}, Quantity: #{@quantity}"
    else
      puts "Incorrect quantity. Please try again."
      increase_quantity
    end		
  end	
end