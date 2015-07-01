require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models/item.rb'

get '/' do
  @items = Item.all.order(paid_at: :desc)
  @graph_items = Item.all.order(category_id: :asc)
  @total = -(Item.sum(:price) - 2 * Item.where(:category_id => 1).sum(:price))
  # @total = Item.sum(:price)
  @categories = Category.all
  erb:index
end

post '/create' do
  Item.create({
      paid_at:params[:date],
      title:params[:title],
      price:params[:price],
      category_id:params[:category]
    })

 redirect '/'
end

get '/category/:id' do
  @categories = Category.all
  @category = Category.find(params[:id])
  @category_name  =@category.name
  @items = @category.items
  @graph_items = @category.items
  @total = -(@items.sum(:price) - 2 * @items.where(:category_id => 1).sum(:price))
  erb:index
end

# get '/' do
#   @items = Item.all.order(paid_at: :desc)
#   @total = Item.sum(:price)
#   @categories = Category.all
#   erb:index
# end

# post '/create' do
#   Item.create({
#       title:params[:title],
#       price:params[:price],
#       category_id:params[:category]
#   })
#
#   redirect '/'
# end

get '/category/:id' do
  @categories    = Category.all
  @category      = Category.find(params[:id])
  @category_name = @category.name
  @items         = @category.items
  puts "="*20
  p @category.present?
  puts "="*20
  erb:index
end

get '/date/:date' do
  @categories    = Category.all
  @items = Item.where(:paid_at => params[:date])
  @graph_items = Item.where(:paid_at => params[:date]).order(category_id: :asc)
  @total = -(@items.sum(:price) - 2 * @items.where(:category_id => 1).sum(:price))
  erb :index
end

post '/delete/:id' do
  Item.find(params[:id]).destroy
  redirect '/'
end

post '/edit/:id' do
  @item = Item.find(params[:id])
  @categories    = Category.all
  erb:edit
end

post '/renew/:id' do
  @item = Item.find(params[:id])
  @item.update({
    title:params[:title],
    price:params[:price],
    category_id: params[:category],
  })
  redirect '/'
end
