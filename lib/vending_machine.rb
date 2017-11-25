require 'securerandom'
require_relative 'product'
require_relative 'money_manager'

class VendingMachine
	attr_accessor :products

	def initialize
		@products = {
			generate_code => Product.new("Cheetos", 100),
			generate_code => Product.new("Fritos", 25),
			generate_code => Product.new("Twinkies", 50),
			generate_code => Product.new("Pringles", 150),
		}
		@money_manager = MoneyManager.new
		main_menu
	end

	def incorrect_entry_message
		puts 'Incorrect entry. Please try again.'
	end	

	def generate_code
		# generate a random string with 4 characters
		SecureRandom.hex(2)
	end	

	def list_products
		@products.each do |code, product|
		  puts "#{product.name}: $#{product.price} | Quantity: #{product.quantity} | Code: #{code}"
		end
	end		

	def main_menu
		puts "Enter 'i' to insert money, 'l' to list products, 'c' to cancel, or 'a' for admin."
		entry = gets.chomp
		case entry
		when 'i'
			@money_manager.insert
			main_menu
		when 'l'
			list_products
		  select_product
		when 'c'
			cancel
		when 'a'
			admin_menu
		else
			incorrect_entry_message
			main_menu
		end
	end

	def admin_menu
		puts "Enter 'r' to restock, 's' to stock a new product, or 'm' for the main menu."
		entry = gets.chomp
		case entry
		when 'r'
			list_products
			restock
		when 's'
			stock
		when 'm'
			main_menu
		else
			incorrect_entry_message
			admin_menu
		end
	end

	def after_sale_menu
		puts "Enter 'm' for the main menu, or 'q' to quit."
		entry = gets.chomp
		case entry
		when 'm'
			main_menu
		when 'q'
			exit
		else
			incorrect_entry_message
			after_sale_menu
		end
	end		

	def select_product
		if @money_manager.slot.empty?
			puts "Insert money"
			@money_manager.insert
			main_menu
		else
			puts "Enter a code to purchase a product"
			code = gets.chomp
			product = @products[code]
			if product
				purchase(product)
			else
				incorrect_entry_message
				select_product
			end
		end
	end	

	def cancel
		total_inserted = @money_manager.total_inserted
		if total_inserted
			@money_manager.dispense_change(total_inserted)
		end		
		puts "Thank you for your business!"
	end

	def purchase(product)
		total_inserted = @money_manager.total_inserted
		if product.quantity == 0
			puts "This product is out of stock. Please make another selection."
			select_product
		elsif total_inserted < product.price
			puts "Total money inserted: #{total_inserted}"
			puts "Please insert more money."
			@money_manager.insert
			main_menu
		else
			sell(product)
		end
	end

	def restock
		puts "Please enter the code of the product you want to restock."
		code = gets.chomp
		product = @products[code]
		if product
			product.increase_quantity
			admin_menu
		else
			incorrect_entry_message
			restock
		end
	end

	def stock
		puts "Please enter the name of the product"
		name = gets.chomp
		puts "Please enter the price of the product."
		price = gets.chomp.to_i
		if name && price > 0
			@products[generate_code] = Product.new(name, price)
			puts "#{name} added!"
			admin_menu
		else
			incorrect_entry_message
			stock
		end
	end

	def sell(product)
		@money_manager.change_check(product.price)
	  product.quantity -= 1
	  puts "You've purchased #{product.name}. Yum!"
	  @money_manager.reset
		after_sale_menu
	end
end