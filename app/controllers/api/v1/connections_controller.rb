class Api::V1::ConnectionsController < ApplicationController

    def show
        connection = Connection.find(params[:id])
        render json: connection
    end

    def show_brand_connections
        brand = Brand.find(params[:id])
        facebook_connection = Facebook.find_by(brand_id:brand)
        render json: {
            facebook_connection: facebook_connection
        }
    end
        
   
    def create

        connection = Connection.new(connection_params)
        if connection.save 
                if connection.type == "Facebook"
                    graph = Koala::Facebook::API.new(connection.oauth_token)
                    long_token = graph.get_object("/oauth/access_token?grant_type=fb_exchange_token&client_id=#{ENV['FB_APP_ID']}&client_secret=#{ENV['FB_APP_SECRET']}&redirect_uri=#{ENV['FB_REDIRECT_URI']}&fb_exchange_token=#{connection.oauth_token}")
                    long_token = long_token['access_token']       
                    long_page_token = graph.get_object("#{connection.page_id}?fields=access_token&access_token=#{long_token}")
                    long_page_token = long_page_token['access_token']
                    connection.update(oauth_token: long_page_token)
                    render json: connection 
                end
                
            
        else
            render json: {error: 'Error creating connection'}
        end
    end

    def create_instagram_conenection_with_facebook_token 
        connection = Connection.new(connection_params)
        brand = Brand.find(params[:brand_id])
        has_facebook = brand.connections.find_by(type: "Facebook")
        if has_facebook
            oauth_token = has_facebook.oauth_token
            graph = Koala::Facebook::API.new(oauth_token)
            page_id = graph.get_object("/me?fields=instagram_accounts")
            page_id = page_id['instagram_accounts']['data'][0]['id']
            connection.update(page_id: page_id)
            page_name = graph.get_object("/#{page_id}?fields=name")
            page_name = page_name['name']
            connection.update(name: page_name)
            page_picture = graph.get_object("/#{page_id}?fields=profile_picture_url")
            page_picture = page_picture['profile_picture_url']
            connection.update(picture_url: page_picture)
            if connection.save
                render json: connection
            else
                render json: {error: 'Error creating connection'}
            end
    end
end



    
    def update
        connection = Connection.find(params[:id])
        connection.update(connection_params)
        render json: connection
    end

    def destroy
        connection = Connection.find(params[:id])
        connection.destroy
        render json: {message: 'Connection deleted'}
    end


    private

    def connection_params
        params.require(:connection).permit(:user_id, :brand_id, :type, :name, :picture_url, :oauth_token, :page_id, :page_type)
    end


end




     
     
     
     
     
     
     