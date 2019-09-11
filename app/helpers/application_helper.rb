module ApplicationHelper
  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end

  def month_options
    months_array = Date::ABBR_MONTHNAMES.map.with_index { |month, index| [month, index] }

    options_for_select(months_array)
  end

  def classes_for_menu(name)
    classes = %w[btn btn-sm btn-mustard ml-3]
    classes << 'btn-mustard-selected' if params[:selected_filter] == name || name == "attendance" && params[:selected_filter].nil?
    classes.join(' ')
  end
end
