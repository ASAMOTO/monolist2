class RankingsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]
  
  def index
    @items = Item.all.order("updated_at DESC").limit(30)
  end
  
  def have
    #items.title,items.description,items.detail_page_url,items.small_image,items.medium_image,items.large_image,items.created_at,items.updated_at,items.item_code
    @items = Item.find_by_sql(['SELECT items.id,items.title,items.description,items.detail_page_url,items.small_image,items.medium_image,items.large_image,items.created_at,items.updated_at,items.item_code FROM items INNER JOIN ownerships ON items.id == ownerships.item_id WHERE ownerships.type == "Have" GROUP BY ownerships.item_id ORDER BY count(type) DESC LIMIT 10'])
  end
  
  def want
    @items = Item.find_by_sql(['SELECT items.id,items.title,items.description,items.detail_page_url,items.small_image,items.medium_image,items.large_image,items.created_at,items.updated_at,items.item_code FROM items INNER JOIN ownerships ON items.id == ownerships.item_id WHERE ownerships.type == "Want" GROUP BY ownerships.item_id ORDER BY count(type) DESC LIMIT 10'])
  end
  
  def new
    if params[:q]
      response = RakutenWebService::Ichiba::Item.search(
        keyword: params[:q],
        imageFlag: 1,
      )
      @items = response.first(20)
    end
  end

  def show
    @users_have = @item.have_users
    @users_want = @item.want_users
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end
end
