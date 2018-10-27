
# class Pagination < ::WillPaginate::ActionView::LinkRenderer
#   protected

#   def html_container(html)
#     tag :ul, html, :class => 'pagination'
#   end

#   def page_number(page)
#     if page == current_page
#       tag :li, link(page, page, :rel => rel_value(page)), :class => 'active agendador-green'
#     else
#       tag :li, link(page, page, :rel => rel_value(page)), :class => 'waves-effect'
#     end
#   end

#   def gap
#     tag :li, link(super, '#'), :class => 'waves-effect'
#   end

#   def previous_or_next_page(page, text, classname)
#     if classname == "previous_page"
#       tag :li, link('<i class="material-icons small"> keyboard_arrow_left </i>', page || '#'), :class => ["waves-effect", classname, ('disabled' unless page)].join(' ')
#     else 
#       tag :li, link('<i class="material-icons small">keyboard_arrow_right </i>', page || '#'), :class => ["waves-effect", classname, ('disabled' unless page)].join(' ')
#     end
#   end
# end