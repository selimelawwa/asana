egypt = Country.find_or_initialize_by(name: 'Egypt')
if egypt.new_record?
  egypt.default_shipping_price = 50
  egypt.save
end

['Cairo', 'Alexandria'].each do |city_name|
  city = egypt.cities.find_or_initialize_by(name: city_name)
  if city.new_record?
    city.save
  end
end
puts "Created Egypt, Alexandria,Cairo"

['Women', 'Boys', 'Girls'].each do |category_name|
  Category.category.where(name: category_name).first_or_create
end
puts "Created Main Categories"

['XS','S','M','L','XL','XXL'].each do |size_name|
  Size.where(name: size_name).first_or_create
end
puts "Created Sizes"