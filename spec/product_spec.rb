require 'product'

describe Product do
  it "creates a product with a name, price, and quantity" do
    product = Product.new("Twinkies", 50)
    expect(product.name).to eq "Twinkies"
    expect(product.price).to eq 50
    expect(product.quantity).to eq 2
  end

  it "can increase the quantity of a product" do
    product = Product.new("Twinkies", 50)
    expect(product.quantity).to eq 2
    product.increase_quantity(1)
    expect(product.quantity).to eq 3
  end

  it "does not increase the quantity of a product if the quantity is incorrect" do
    product = Product.new("Twinkies", 50)
    expect(product.quantity).to eq 2
    expect(product).to receive(:puts).with("Incorrect quantity")
    product.increase_quantity(-1)
    expect(product.quantity).to eq 2
  end
end