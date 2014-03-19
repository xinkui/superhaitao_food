module Shipping
  module Buyer
    class HelpsController < ActionController::Base

      layout lambda { |controller| current_user.try(:role) == 'admin' ? 'admin' : 'application' }

      def cancan_error

      end

      def index

      end

      def shopping_guide

      end

      def shopping_guide_amazon

      end

      def shopping_guide_allyouneed

      end

      def shopping_guide_bodyguard

      end

      def shopping_guide_mytime

      end

      def shopping_guide_windeln

      end

      def superhaitao_guide

      end

      def price_guide

      end

      def point_guide

      end

      def tax_guide

      end

      def goods_guide

      end

      def package_guide

      end

      def shipping_protocol

      end

      def embargo_list

      end

    end
  end
end
