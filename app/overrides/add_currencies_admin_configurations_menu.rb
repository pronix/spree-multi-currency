Deface::Override.new(:virtual_path => "admin/configurations/index",
                     :name => "currencies_admin_configurations_menu",
                     :insert_after => "[data-hook='admin_configurations_menu'], #admin_configurations_menu[data-hook]",
                     :disabled => false,
                     :text => "
<% if current_user.has_role?(:admin) %>
	<tr>
		<td><%= link_to t('currency_settings'), admin_currencies_path %></td>
		<td><%= t('currency_description') %></td>
	</tr>
	<tr>
		<td><%= link_to t('currency_converters_settings'), admin_currency_converters_path %></td>
		<td><%= t('currency_converters_description') %></td>
	</tr>
<% end %>
")
