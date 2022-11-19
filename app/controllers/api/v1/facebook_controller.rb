class Api::V1::FacebookController < ApplicationController
    before_action :verify_decode_request_is_empty, :authenticate_user,:if_facebook_connection_dont_exist, :verify_the_brand_belong_to_user

    def page_facebook_data 
        
      #Get data
        fb_likes = get_insights_data("insights", "page_fans")
        fb_likes_adds = get_insights_data("insights","page_fan_adds")
        fb_likes_removes = get_insights_data("insights","page_fan_removes")
        fb_impresiones =   get_insights_data("insights","page_impressions_unique")
        fb_posts = get_post_data("published_posts")
        fb_page_total_actions = get_insights_data("insights","page_total_actions")
        fb_page_get_directions_clicks = get_insights_data("insights","page_get_directions_clicks_logged_in_unique")
        fb_page_call_phone_clicks = get_insights_data("insights","page_call_phone_clicks_logged_in_unique")
        fb_page_views_total = get_insights_data("insights", "page_views_total")
        
        

        #Convert data
        fb_all_likes = convert_objet_to_array_and_reverse_data(fb_likes)
        fb_likes_adds = convert_objet_to_array_and_reverse_data(fb_likes_adds)
        fb_likes_removes = convert_objet_to_array_and_reverse_data(fb_likes_removes)
        fb_posts = how_many_times_created_time_is_the_same(fb_posts)
        fb_impresiones = convert_objet_to_array_and_reverse_data(fb_impresiones)
        fb_page_total_actions = convert_objet_to_array_and_reverse_data(fb_page_total_actions)
        fb_page_get_directions_clicks = convert_objet_to_array_and_reverse_data(fb_page_get_directions_clicks)
        fb_page_call_phone_clicks = convert_objet_to_array_and_reverse_data(fb_page_call_phone_clicks)
        fb_page_views_total = convert_objet_to_array_and_reverse_data(fb_page_views_total)

        #total data
        total_fb_likes_adds = total_value_array(fb_likes_adds)
        total_fb_likes_removes = total_value_array(fb_likes_removes)
        total_fb_impresiones = total_value_array(fb_impresiones)
        total_fb_page_total_actions = total_value_array(fb_page_total_actions)
        fb_posts_count = count_the_posts(fb_posts)
        total_fb_page_get_directions_clicks = total_value_array(fb_page_get_directions_clicks)
        total_fb_page_call_phone_clicks = total_value_array(fb_page_call_phone_clicks)
        total_fb_page_views_total = total_value_array(fb_page_views_total)
     

        render json: {
            fb_likes: fb_all_likes,
            fb_likes_adds: fb_likes_adds,
            fb_likes_removes: fb_likes_removes,
            fb_posts: fb_posts,
            total_fb_likes_adds: total_fb_likes_adds,
            total_fb_likes_removes: total_fb_likes_removes,
            total_posts: fb_posts_count,
            fb_impresiones: fb_impresiones,
            total_fb_impresiones: total_fb_impresiones,
            fb_page_total_actions: fb_page_total_actions,
            total_fb_page_total_actions: total_fb_page_total_actions,
            fb_page_get_directions_clicks: fb_page_get_directions_clicks,
            total_fb_page_get_directions_clicks: total_fb_page_get_directions_clicks,
            fb_page_call_phone_clicks: fb_page_call_phone_clicks,
            total_fb_page_call_phone_clicks: total_fb_page_call_phone_clicks,
            fb_page_views_total: fb_page_views_total,
            total_fb_page_views_total: total_fb_page_views_total

        }
      end

      def page_profile_data 
        fb_body_data = get_profile_data("name,about,description,link,location,phone,website,cover,picture")
        render json: {
            fb_body_data: fb_body_data
        }
      end



      private

      def how_many_times_created_time_is_the_same(data)
        array_data = []
        data.each do |object|
            array_data << object["created_time"]
        end
        array_data = array_data.group_by{|x| x}.map{|k,v| [k,v.count]}.to_h
        array_data

      end

      def count_the_posts(data) 
        fb_posts_count = data.count
        return fb_posts_count
      end

        # obtener los datos de la página de facebook
        def get_insights_data(type,data_name) 
           graph, from, to = find_fb_connection
          data = graph.get_object("me/#{type}?pretty=0&since=#{from}&until=#{to}&metric=#{data_name}&period=day")
        end

        #obtener datos del perfil de la página
        def get_profile_data(data) 
            graph, from, to = find_fb_connection
            data = graph.get_object("me?fields=#{data}")
        end

        def get_post_data(end_point) 
            graph, from, to = find_fb_connection
            data = graph.get_object("me/#{end_point}?since=#{from}&until=#{to}")
        end

     
   


        #encontrar el id de la marca y crear una conexion con el token para obtener los datos
        def find_fb_connection 

          brand = Brand.find(facebook_params)
          from = params[:from]
          to = params[:to]
          facebook_connection = Facebook.find_by(brand_id:brand)
  
          graph = Koala::Facebook::API.new(facebook_connection.oauth_token)

          return graph, from, to

        end

        #convertir el objeto de facebook a un array y invertir el orden de los datos (Rquerimiento del fronted)
        def convert_objet_to_array_and_reverse_data(data) 
            array_data = []
            data[0]["values"].each do |object|
                array_data << object.values
            end

            array_data.each do |object|
              object.reverse!
        end
      end

    #totalizar los datos de un array
      def total_value_array(array)
          total = 0
          array.each do |object|
              total += object[1]
          end
          total
      end

    
    def facebook_params
        params.require(:brand_id)
    end

    def if_facebook_connection_dont_exist
        if Facebook.find_by(brand_id:facebook_params).nil?
            render json: {error: "No existe una conexión con facebook para esta marca", connected: false}, status: :unprocessable_entity
        end
    end

    def authenticate_user
        decoded_token = decode(request.headers['token'])
        @user = User.find(decoded_token["user_id"])
        render json: { message: 'Un-Authenticated Request', status: 404} unless @user
      end

      def verify_decode_request_is_empty 
        render json: { message: 'Un-Authenticated Request', status: 404 } if decode(request.headers['token']).nil?
      end
        

      def verify_the_brand_belong_to_user 
        brand = Brand.find(facebook_params)
        render json: { message: 'Not found', status: 404 } unless @user.brands.include?(brand)
      end

end
