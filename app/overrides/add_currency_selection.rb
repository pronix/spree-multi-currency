Deface::Override.new(:virtual_path => "spree/shared/_main_nav_bar",
                     :name => "currencies_admin_configurations_menu",
                     :insert_bottom => "ul#main-nav-bar",
                     :disabled => false,
                     :text => "
                     <li><%= select_tag 'currency', options_for_select(Spree::Currency.all_currencies, Spree::Currency.current.char_code) %></li>
                     <script>
                      $('#currency').on('change', function(event){
                        window.location = '/currency/' + $(this).val();

                      });
                     </script>

                     ")
