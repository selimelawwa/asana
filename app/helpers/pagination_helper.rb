module PaginationHelper
  def custom_paginate_renderer
    # Return nice pagination for materialize
    Class.new(WillPaginate::ActionView::LinkRenderer) do
      def html_container(html)
        tag :ul, html, :class => 'pagination justify-content-center'
      end
    
      def page_number(page)
        if page == current_page
          tag :li, link(page, page, :rel => rel_value(page), class: 'page-link'), :class => 'page-item disabled'
        else
          tag :li, link(page, page, :rel => rel_value(page), class: 'page-link'), :class => 'page-item'
        end
      end
    
      def gap
        tag :li, link(super, '#'), :class => 'waves-effect'
      end
    
      def previous_or_next_page(page, text, classname)
        if classname == "previous_page"
          tag :li, link('<i class="material-icons tiny"> chevron_left </i>', page || '#', class: 'page-link'), :class => ["waves-effect", 'page-item', ('disabled' unless page)].join(' ')
        else 
          tag :li, link('<i class="material-icons tiny">chevron_right </i>', page || '#', class: 'page-link'), :class => ["waves-effect", 'page-item', ('disabled' unless page)].join(' ')
        end
      end
    end
  end
end