# frozen_string_literal: true

module IconsHelper
  def svg_tag(name, options = {})
    file_path = Rails.root.join 'app', 'assets', 'images', 'svg', "#{name}.svg"
    return nil unless File.exist?(file_path)

    svg_content = File.read(file_path)
    
    # Extraire les classes
    classes = options.delete(:class)
    class_attr = classes.present? ? "class=\"#{classes}\" " : ""
    
    # Gérer les attributs data
    data_attrs = options.delete(:data) || {}
    data_attr_string = data_attrs.map { |k, v| "data-#{k.to_s.gsub('_', '-')}=\"#{v}\"" }.join(" ")
    data_attr_string = "#{data_attr_string} " if data_attr_string.present?
    
    # Gérer les autres attributs
    other_attrs = options.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    other_attrs = "#{other_attrs} " if other_attrs.present?

    svg_content.gsub(
      'viewBox=',
      "#{class_attr}#{data_attr_string}#{other_attrs}viewBox="
    ).strip.html_safe
  end
end

  