class Api::V1::BrandsController < ApplicationController
    before_action :verify_decode_request_is_empty, :authenticate_user

    def show
        brand = Brand.find(params[:id])
        render json: brand
    end

    
    def create
        decoded_token = decode(request.headers['token'])
        user = User.find(decoded_token["user_id"])
        brand = Brand.new(name:"Marca vacía", image:"", user_id:user.id)
        if brand.save
            render json: brand
        else
            render json: {error: 'Error creating brand'}
        end
    end

    def update
        brand = Brand.find(params[:id])
        brand.update(brand_params)
        render json: brand
    end

    def destroy
        brand = Brand.find(params[:id])
        brand.destroy
        render json: {message: 'Brand deleted'}
    end

    private

    def brand_params
        params.require(:brand).permit(:name, :image, :user_id)
    end

    def authenticate_user
        decoded_token = decode(request.headers['token'])
        @user = User.find(decoded_token["user_id"])
        render json: { message: 'Un-Authenticated Request', status: 404} unless @user
      end

      def verify_decode_request_is_empty 
        render json: { message: 'Un-Authenticated Request', status: 404 } if decode(request.headers['token']).nil?
      end
 


end