require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = ["Shoes", "phones", "cofee"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      if @@cart.size >= 1
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      else 
        resp.write "Your cart is empty"
      end 
    elsif req.path.match(/add/)
      search_term = req.params["item"]
      if handle_cart(search_term)
        @@cart << search_term
        resp.write "added #{search_term}"
      else 
        resp.write "We don't have that item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def handle_cart(search_term)
    if @@items.include?(search_term)
      true
    else 
      false 
    end
  end
end
