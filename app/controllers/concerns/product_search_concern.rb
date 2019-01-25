module ProductSearchConcern
    extend ActiveSupport::Concern
    included do
      def set_params
        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= "created_at desc"   
        params[:q].delete(:variants_size_id_in) if params.dig(:q,:variants_size_id_in) == ""
        params[:q].delete(:variants_color_id_in) if params.dig(:q,:variants_color_id_in) == ""
        params[:q].delete(:tags_id_in) if params.dig(:q,:tags_id_in) == ""
        params[:q].delete(:categories_id_in) if params.dig(:q,:categories_id_in) == ""    

        params[:q][:variants_size_id_in] =  params.dig(:q,:variants_size_id_in)&.reject { |c| c.empty? } 
        params[:q][:variants_color_id_in] =  params.dig(:q,:variants_color_id_in)&.reject { |c| c.empty? }
        params[:q][:tags_id_in] =  params.dig(:q,:tags_id_in)&.reject { |c| c.empty? }
        params[:q][:categories_id_in] =  params.dig(:q,:categories_id_in)&.reject { |c| c.empty? }

        params[:on_sale] ||= params[:q][:on_sale]
        params[:new_arrival] ||= params[:q][:new_arrival]
        params[:category_id] ||= params[:q][:categories_id_eq]
        params[:q].delete(:categories_id_eq) if params.dig(:q,:categories_id_eq)
      end
      
      def handle_category_id
        if params[:category_id].present?
          @category = Category.find_by(id: params[:category_id])
          if @category.present?
            @products = @category.products.published
            @sub_categories = @category.sub_categories.with_products
          end
        else
          @products = Product.published
        end
      end

      def handle_category_filter
        if params.dig(:q,:categories_id_in).present?
          @sub_categories = Category.sub_category.with_products.where(parent_id: params.dig(:q,:categories_id_in))
        end

        if params.dig(:q,:sub_categories_id_in).present?
          if @sub_categories&.any?
            params[:q][:sub_categories_id_in] = params[:q][:sub_categories_id_in]&.reject do |r|
              !@sub_categories&.ids&.include? r&.to_i
            end
          else
            params[:q][:sub_categories_id_in] = nil
          end
        end
      end

      def handle_new_arrival_and_sale
        if params[:on_sale].present? && params[:on_sale] == "true"
          @products = @products.where(on_sale: true)
        end

        if params[:new_arrival].present? && params[:new_arrival] == "true"
          @products = @products.where(new_arrival: true)
        end
      end
    end
  end